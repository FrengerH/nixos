{ config, pkgs, lib, ... }:

let
   userConf = builtins.fromJSON(builtins.readFile("/etc/nixos/username.json"));
in
  {
    options = with lib.options; {
      defaultUser = mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = lib.mdDoc "Default username";
      };
      notesDir = mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = lib.mdDoc "Default notes directory";
      };
    };

    config = {
      defaultUser = userConf.defaultUser;
      notesDir = "/home/${config.defaultUser}/notes";

      nix.settings.auto-optimise-store = true;

      environment.systemPackages = with pkgs; [
        git
        gcc
        ripgrep
        gimp
        nmap
        firefox
        flameshot
        direnv
        nix-direnv
        bat
      ];

      environment.pathsToLink = [
        "/share/nix-direnv"
      ];

      nixpkgs.overlays = map import [ 
        ./overlays/firefox
        ./overlays/direnv
      ];
      
    };
  }
