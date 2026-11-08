{
  pkgs,
  lib,
  ...
}:

let
  # LSP servers registered in Vim. A server is only registered when its
  # executable is on PATH, so toolchains that direnv adds inside a project
  # (e.g. the Haskell server) work without changing this module.
  lspServers = [
    {
      name = "clangd";
      command = [ "clangd" ];
      filetypes = [
        "c"
        "cpp"
        "objc"
        "objcpp"
      ];
    }
    {
      name = "haskell-language-server";
      command = [
        "haskell-language-server-wrapper"
        "--lsp"
      ];
      filetypes = [ "haskell" ];
    }
    {
      name = "nixd";
      command = [ "nixd" ];
      filetypes = [ "nix" ];
    }
    {
      name = "texlab";
      command = [ "texlab" ];
      filetypes = [
        "tex"
        "bib"
      ];
    }
  ];

  vimString = text: "'${lib.replaceStrings [ "'" ] [ "''" ] text}'";
  vimList = items: "[${lib.concatMapStringsSep ", " vimString items}]";

  lspSetup = lib.concatMapStringsSep "\n" (server: ''
    if executable('${builtins.head server.command}')
      au User lsp_setup call lsp#register_server({
            \ 'name': ${vimString server.name},
            \ 'cmd': ${vimList server.command},
            \ 'whitelist': ${vimList server.filetypes},
            \ })
    endif
  '') lspServers;
in
{
  programs.vim = {
    enable = true;
    defaultEditor = true;
    package = (
      pkgs.vim-full.customize {
        vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
          start = [
            (pkgs.callPackage ./pkgs/vim-spelllang-de/package.nix { })
            vim-fugitive
            vimtex
            vim-lsp
            asyncomplete-vim
            asyncomplete-lsp-vim
          ];
        };

        vimrcConfig.customRC = ''
          set nocompatible
          syntax on
          set shiftwidth=2 tabstop=2 softtabstop=2 expandtab
          set backspace=2
          set autoindent
          set number
          set hlsearch incsearch

          filetype plugin indent on

          " Switch between windows
          nnoremap gl <C-w>w
          nnoremap gL <C-w>W

          set spell spelllang=en

          " Vertikales Aufteilen für den „diff-Modus“
          set diffopt=filler,vertical

          ${lspSetup}
          " Nützliche Tastenkombinationen für die Entwicklung
          function! s:on_lsp_buffer_enabled() abort
              setlocal omnifunc=lsp#complete
              nmap <buffer> gd <plug>(lsp-definition)
              nmap <buffer> gr <plug>(lsp-references)
              nmap <buffer> <leader>rn <plug>(lsp-rename)
              nmap <buffer> K <plug>(lsp-hover)
          endfunction

          augroup LspHaskell
              autocmd!
              autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
          augroup END
        '';
      }
    );
  };
}
