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
      clang-tools_14
      fzf
      neovim
      rnix-lsp
      sumneko-lua-language-server
      php82Packages.psalm
      python310Packages.python-lsp-server
      python310Packages.pylsp-mypy
      unstable.nixd
    ];

    nixpkgs.overlays = map import [ 
      ./overlays/neovim
    ];
  }

