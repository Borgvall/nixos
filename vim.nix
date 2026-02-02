{ config, lib, pkgs, ... }:

{
  programs.vim = {
    enable = true;
    defaultEditor = true;
    package = (pkgs.vim-full.customize {
      vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
        start = [
          vim-fugitive
          vimtex
          ale
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

        " Ale
        let g:ale_completion_enabled = 1
        let g:ale_completion_autoimport = 1

        let g:ale_linters = { 'haskell': [ 'hls' ] }
      '';
    });
  };
}
