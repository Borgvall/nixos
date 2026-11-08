{ pkgs ? import <nixpkgs> {} }:

pkgs.vimUtils.buildVimPlugin {
  pname = "vim-spelllang-de";
  version = "0.1-test";
  src = ./src;
}
