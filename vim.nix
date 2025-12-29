{ config, lib, pkgs, ... }:

{
  programs.vim = {
    enable = true;
    package = pkgs.vim-full;
    defaultEditor = true;
  };

  environment.systemPackages = with pkgs; [
    ((vim-full.customize {
      vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
        start = [
          vim-fugitive
          vimtex
        ];
      };
      
      vimrcConfig.customRC = ''
        set nocompatible
        syntax on
        set shiftwidth=2 tabstop=2 softtabstop=2 expandtab
        set backspace=2
        set expandtab
        set autoindent
        set number

        filetype plugin indent on

        " Switch between windows
        nnoremap gl <C-w>w
        nnoremap gL <C-w>W

        set spell spelllang=de

        " Vertikales Aufteilen für den „diff-Modus“
        set diffopt=filler,vertical

        " Konfiguration für vimtex
        let g:vimtex_view_method = 'general'
      '';
    }))
  ];
}
