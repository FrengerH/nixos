{ config, pkgs, ... }:

let
in
  {
    environment.systemPackages = with pkgs; [
      clang-tools_14
      fzf
      neovim
      rnix-lsp
      sumneko-lua-language-server
    ];

    nixpkgs.overlays = map import [ 
      ./overlays/neovim
    ];
  }

