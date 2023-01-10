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
      ];

      environment.pathsToLink = [
        "/share/nix-direnv"
      ];

      nixpkgs.overlays = map import [ 
        ./overlays/firefox
        ./overlays/direnv
      ];
      
      services.autorandr.profiles = {
        "default" = {
          fingerprint = {
            eDP1 = "00ffffffffffff0006af8ba000000000001d0104a5221378033e8591565991281f505400000001010101010101010101010101010101143780b4703824406c30aa0058c110000018b82480b4703824406c30aa0058c11000001800000000000000000000000000000000000000000002001430ff123cc80b0719c820202000bd";
          };
          config = {
            eDP1 = {
              enable = true;
              crtc = 0;
              primary = true;
              position = "0x0";
              mode = "1920x1080";
              rate = "60.16";
            };
          };
        };
        "home" = {
          fingerprint = {
            eDP1 = "00ffffffffffff0006af8ba000000000001d0104a5221378033e8591565991281f505400000001010101010101010101010101010101143780b4703824406c30aa0058c110000018b82480b4703824406c30aa0058c11000001800000000000000000000000000000000000000000002001430ff123cc80b0719c820202000bd";
            DP2-1 = "00ffffffffffff0010ac7aa04c4d4a302f15010380342078eaee95a3544c99260f5054a1080081408180a940b300d1c0010101010101283c80a070b023403020360006442100001a000000ff005931483554314248304a4d4c0a000000fc0044454c4c2055323431324d0a20000000fd00323d1e5311000a20202020202000fb";
          };
          config = {
            eDP1 = {
              enable = true;
              crtc = 0;
              primary = false;
              position = "1920x0";
              mode = "1920x1080";
              rate = "60.16";
            };
            DP2-1 = {
              enable = true;
              crtc = 1;
              primary = true;
              position = "0x0";
              mode = "1920x1200";
              rate = "59.95";
            };
          };
        };
      };
    };
}
