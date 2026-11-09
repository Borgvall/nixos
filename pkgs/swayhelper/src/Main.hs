{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import Control.Applicative ((<|>))
import Control.Exception (bracket)
import Control.Monad (unless, when)
import Data.Aeson (FromJSON (parseJSON), eitherDecode, withObject, (.:), (.:?), (.!=))
import Data.Bits ((.&.))
import Data.Maybe (mapMaybe)
import Data.Word (Word32)
import qualified Data.ByteString as BS
import qualified Data.ByteString.Builder as BB
import qualified Data.ByteString.Char8 as BC
import qualified Data.ByteString.Lazy as BL
import Network.Socket
  ( Family (AF_UNIX)
  , SockAddr (SockAddrUnix)
  , Socket
  , SocketType (Stream)
  , close
  , connect
  , defaultProtocol
  , socket
  )
import Network.Socket.ByteString (recv, sendAll)
import System.Environment (getArgs, lookupEnv)
import System.Exit (exitFailure)
import System.IO (hPutStrLn, stderr)

-- Message types from sway-ipc(7).
runCommandMessage, getWorkspacesMessage, getTreeMessage :: Word32
runCommandMessage = 0
getWorkspacesMessage = 1
getTreeMessage = 4

-- Events have the highest bit set in the reply type.
eventFlag :: Word32
eventFlag = 0x80000000

data Action = FocusNext | MoveNext

data Workspace = Workspace
  { workspaceName :: String
  , workspaceNum :: Int
  , workspaceFocused :: Bool
  }

instance FromJSON Workspace where
  parseJSON = withObject "Workspace" $ \o ->
    Workspace <$> o .: "name" <*> o .: "num" <*> o .: "focused"

-- | The part of the layout tree that is needed to tell empty workspaces from
-- populated ones.
data Node = Node
  { nodeType :: String
  , nodeName :: String
  , nodeNodes :: [Node]
  , nodeFloatingNodes :: [Node]
  }

instance FromJSON Node where
  parseJSON = withObject "Node" $ \o ->
    Node
      <$> o .: "type"
      <*> o .: "name"
      <*> o .:? "nodes" .!= []
      <*> o .:? "floating_nodes" .!= []

data CommandReply = CommandReply
  { commandSucceeded :: Bool
  , commandError :: Maybe String
  }

instance FromJSON CommandReply where
  parseJSON = withObject "CommandReply" $ \o ->
    CommandReply <$> o .: "success" <*> o .:? "error"

main :: IO ()
main = do
  action <- parseArgs
  bracket openSwaySocket close $ \sock -> do
    workspaces <- getWorkspaces sock
    runAction sock action workspaces

parseArgs :: IO Action
parseArgs = do
  args <- getArgs
  case args of
    ["next"] -> pure FocusNext
    ["move-next"] -> pure MoveNext
    _ -> usage

usage :: IO a
usage = do
  hPutStrLn stderr "usage: swayhelper next|move-next"
  hPutStrLn stderr "  next       focus the next workspace, creating one at the end"
  hPutStrLn stderr "  move-next  move the focused container, creating a workspace at the end"
  exitFailure

getWorkspaces :: Socket -> IO [Workspace]
getWorkspaces sock = do
  payload <- request sock getWorkspacesMessage BS.empty
  case eitherDecode (BL.fromStrict payload) of
    Left err -> die ("cannot parse GET_WORKSPACES reply: " ++ err)
    Right workspaces -> pure workspaces

getTree :: Socket -> IO Node
getTree sock = do
  payload <- request sock getTreeMessage BS.empty
  case eitherDecode (BL.fromStrict payload) of
    Left err -> die ("cannot parse GET_TREE reply: " ++ err)
    Right tree -> pure tree

runAction :: Socket -> Action -> [Workspace] -> IO ()
runAction sock action workspaces = do
  target <- nextTarget sock action workspaces
  runCommand sock $
    case (action, target) of
      (FocusNext, Just number) -> "workspace number " ++ show number
      (MoveNext, Just number) -> "move container to workspace number " ++ show number
      (FocusNext, Nothing) -> "workspace next"
      (MoveNext, Nothing) -> "move container to workspace next"

-- | Return the number of the workspace to create if sway would otherwise wrap
-- around to the first workspace.  Numbered workspaces are visited before named
-- ones, so a new one is only created when neither exists.
--
-- An empty workspace at the end is a temporary one: it is the leftover of a
-- previous switch.  Leaving it should wrap around again instead of piling up
-- one empty workspace after another.
nextTarget :: Socket -> Action -> [Workspace] -> IO (Maybe Int)
nextTarget sock action workspaces =
  case [workspaceNum w | w <- workspaces, workspaceFocused w] of
    (current : _)
      | current >= 0
      , all (\w -> workspaceNum w <= current) workspaces
      , all (\w -> workspaceNum w >= 0) workspaces ->
          case action of
            MoveNext -> pure (Just (current + 1))
            FocusNext -> do
              empty <- focusedWorkspaceEmpty sock workspaces
              pure (if empty then Nothing else Just (current + 1))
    _ -> pure Nothing

focusedWorkspaceEmpty :: Socket -> [Workspace] -> IO Bool
focusedWorkspaceEmpty sock workspaces =
  case [workspaceName w | w <- workspaces, workspaceFocused w] of
    (name : _) -> do
      tree <- getTree sock
      pure (maybe False isEmptyWorkspace (findWorkspace name tree))
    [] -> pure False

-- | A workspace without tiling or floating children, i.e. one that sway is
-- going to destroy as soon as it loses focus.
isEmptyWorkspace :: Node -> Bool
isEmptyWorkspace node = null (nodeNodes node) && null (nodeFloatingNodes node)

findWorkspace :: String -> Node -> Maybe Node
findWorkspace name node
  | nodeType node == "workspace" && nodeName node == name = Just node
  | otherwise =
      case mapMaybe
        (findWorkspace name)
        (nodeNodes node ++ nodeFloatingNodes node) of
        (found : _) -> Just found
        [] -> Nothing

runCommand :: Socket -> String -> IO ()
runCommand sock command = do
  payload <- request sock runCommandMessage (BC.pack command)
  case eitherDecode (BL.fromStrict payload) of
    Left err -> die ("cannot parse RUN_COMMAND reply: " ++ err)
    Right replies
      | not (null replies) && all commandSucceeded replies -> pure ()
      | otherwise ->
          die ("sway rejected the command: " ++ command ++ errorDetails replies)

errorDetails :: [CommandReply] -> String
errorDetails replies =
  case [err | CommandReply {commandError = Just err} <- replies] of
    [] -> ""
    errors -> " (" ++ unwords errors ++ ")"

request :: Socket -> Word32 -> BS.ByteString -> IO BS.ByteString
request sock messageType payload = do
  sendAll sock (encodeMessage messageType payload)
  header <- recvAll sock 14
  unless (BS.take 6 header == "i3-ipc") $
    die "unexpected reply from sway (bad magic string)"
  let replyLength = decodeWord32LE (BS.take 4 (BS.drop 6 header))
      replyType = decodeWord32LE (BS.take 4 (BS.drop 10 header))
  when (replyType .&. eventFlag /= 0) $
    die "received an event while waiting for a reply"
  recvAll sock (fromIntegral replyLength)

encodeMessage :: Word32 -> BS.ByteString -> BS.ByteString
encodeMessage messageType payload =
  BL.toStrict . BB.toLazyByteString $
    BB.byteString "i3-ipc"
      <> BB.word32LE (fromIntegral (BS.length payload))
      <> BB.word32LE messageType
      <> BB.byteString payload

decodeWord32LE :: BS.ByteString -> Word32
decodeWord32LE bytes =
  fromIntegral (BS.index bytes 0)
    + fromIntegral (BS.index bytes 1) * 0x100
    + fromIntegral (BS.index bytes 2) * 0x10000
    + fromIntegral (BS.index bytes 3) * 0x1000000

recvAll :: Socket -> Int -> IO BS.ByteString
recvAll sock size = go size []
  where
    go 0 chunks = pure (BS.concat (reverse chunks))
    go remaining chunks = do
      chunk <- recv sock (min remaining 65536)
      if BS.null chunk
        then die "sway closed the IPC connection unexpectedly"
        else go (remaining - BS.length chunk) (chunk : chunks)

openSwaySocket :: IO Socket
openSwaySocket = do
  path <- swaySocketPath
  sock <- socket AF_UNIX Stream defaultProtocol
  connect sock (SockAddrUnix path)
  pure sock

swaySocketPath :: IO FilePath
swaySocketPath = do
  sway <- lookupEnv "SWAYSOCK"
  i3 <- lookupEnv "I3SOCK"
  case sway <|> i3 of
    Just path -> pure path
    Nothing -> die "SWAYSOCK is not set; run swayhelper inside a sway session"

die :: String -> IO a
die message = do
  hPutStrLn stderr ("swayhelper: " ++ message)
  exitFailure
