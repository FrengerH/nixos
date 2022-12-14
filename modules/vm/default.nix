{ config, pkgs, lib, ... }:

with lib;

let
    secrets = builtins.fromJSON(builtins.readFile("/home/" + config.defaultUser + "/.config/nixos/secrets.json"));
in
  {
    environment.systemPackages = [ pkgs.cifs-utils ]; 

    services.xserver.displayManager.autoLogin = {
      enable = true;
      user = config.defaultUser;
    };
    
    services.qemuGuest.enable = true;
    services.spice-vdagentd.enable = true;
    fileSystems = mkIf (config.defaultUser or "" != "") {
      "/home/${config.defaultUser}/vmshare"= {
        device = "vmshare";
        fsType = "9p";
        options = [ "trans=virtio" "version=9p2000.L" ];
      };
    };

    services.autorandr.profiles = {
        "vm-min" = {
          fingerprint = {
            Virtual-1 = "--CONNECTED-BUT-EDID-UNAVAILABLE--Virtual-1";
          };
          config = {
            Virtual-1 = {
              enable = true;
              crtc = 0;
              primary = true;
              position = "0x0";
              mode = "1912x988_60.00";
              rate = "60.00";
            };
          };
        };
        "vm-max" = {
          fingerprint = {
            Virtual-1 = "--CONNECTED-BUT-EDID-UNAVAILABLE--Virtual-1";
          };
          config = {
            Virtual-1 = {
              enable = true;
              crtc = 0;
              primary = true;
              position = "0x0";
              mode = "1920x1080";
              rate = "60.00";
            };
          };
        };
      };

  }

