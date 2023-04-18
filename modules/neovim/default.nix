{ config, pkgs, ... }:

let
in
  {
    environment.variables.EDITOR = "nvim";
    environment.systemPackages = with pkgs; [
      clang-tools_14
      fzf
      neovim
      rnix-lsp
      sumneko-lua-language-server
      php82Packages.psalm
    ];

    nixpkgs.overlays = map import [ 
      ./overlays/neovim
    ];
  }

