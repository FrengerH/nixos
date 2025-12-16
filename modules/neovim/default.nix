{ config, pkgs, ... }:

let
  unstable = import
    (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/nixpkgs-unstable)
    # reuse the current configuration
    { config = config.nixpkgs.config; };
in
  {
    environment.variables.EDITOR = "nvim";
    environment.systemPackages = with pkgs; [
      clang-tools
      fzf
      neovim
      # rnix-lsp
      lua-language-server
      php82Packages.psalm
      python312Packages.python-lsp-server
      python312Packages.pylsp-mypy
      unstable.nixd
    ];

    nixpkgs.overlays = map import [ 
      ./overlays/neovim
    ];
  }

