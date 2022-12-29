{ config, pkgs, lib, ... }:

with lib;

let
in
  {
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
  }

