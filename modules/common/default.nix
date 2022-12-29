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
    };

    config = {
      defaultUser = userConf.defaultUser;

      nix.settings.auto-optimise-store = true;

      environment.systemPackages = with pkgs; [
        git
        gcc
        ripgrep
        gimp
        nmap
        firefox
        flameshot
      ];

      nixpkgs.overlays = map import [ 
        ./overlays/firefox
      ];
      
    };
}
