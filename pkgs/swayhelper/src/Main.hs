{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import Control.Applicative ((<|>))
import Control.Exception (bracket)
import Control.Monad (unless, when)
import Data.Aeson (FromJSON (parseJSON), eitherDecode, withObject, (.:), (.:?))
import Data.Bits ((.&.))
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
runCommandMessage, getWorkspacesMessage :: Word32
runCommandMessage = 0
getWorkspacesMessage = 1

-- Events have the highest bit set in the reply type.
eventFlag :: Word32
eventFlag = 0x80000000

data Action = FocusNext | MoveNext

data Workspace = Workspace
  { workspaceNum :: Int
  , workspaceFocused :: Bool
  }

instance FromJSON Workspace where
  parseJSON = withObject "Workspace" $ \o ->
    Workspace <$> o .: "num" <*> o .: "focused"

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

runAction :: Socket -> Action -> [Workspace] -> IO ()
runAction sock action workspaces =
  runCommand sock $
    case (action, nextTarget workspaces) of
      (FocusNext, Just target) -> "workspace number " ++ show target
      (MoveNext, Just target) -> "move container to workspace number " ++ show target
      (FocusNext, Nothing) -> "workspace next"
      (MoveNext, Nothing) -> "move container to workspace next"

-- | Return the number of the workspace to create if sway would otherwise wrap
-- around to the first workspace.  Numbered workspaces are visited before named
-- ones, so a new one is only created when neither exists.
nextTarget :: [Workspace] -> Maybe Int
nextTarget workspaces =
  case [workspaceNum w | w <- workspaces, workspaceFocused w] of
    (current : _)
      | current >= 0
      , all (\w -> workspaceNum w <= current) workspaces
      , all (\w -> workspaceNum w >= 0) workspaces ->
          Just (current + 1)
    _ -> Nothing

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
