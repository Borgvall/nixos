{ pkgs, ... }:

{
  programs.vim = {
    enable = true;
    defaultEditor = true;
    package = (
      pkgs.vim-full.customize {
        vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
          start = [
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

          set spell spelllang=de

          " Vertikales Aufteilen für den „diff-Modus“
          set diffopt=filler,vertical


          " HLS Registrierung aktivieren, sobald wir eine Haskell-Datei öffnen
          if executable('haskell-language-server-wrapper')
              au User lsp_setup call lsp#register_server({
                  \ 'name': 'haskell-language-server',
                  \ 'cmd': {server_info->['haskell-language-server-wrapper', '--lsp']},
                  \ 'whitelist': ['haskell'],
                  \ })
          endif

          " Nix Language Server (nixd) Registrierung aktivieren
          if executable('nixd')
              au User lsp_setup call lsp#register_server({
                  \ 'name': 'nixd',
                  \ 'cmd': {server_info->['nixd']},
                  \ 'whitelist': ['nix'],
                  \ })
          endif

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

  environment.systemPackages = with pkgs; [
    nixd
  ];

  programs.vscode.extensions = [
    pkgs.vscode-extensions.vscodevim.vim
  ];
}
