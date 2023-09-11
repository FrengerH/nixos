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
      python310Packages.python-lsp-server
      python310Packages.pylsp-mypy
    ];

    nixpkgs.overlays = map import [ 
      ./overlays/neovim
    ];
  }

