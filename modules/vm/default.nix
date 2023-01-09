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
      "/mnt/share" = {
        device = "//${secrets.nas.ip}/share";
        fsType = "cifs";
        options = [ "username=${secrets.nas.user}" "password=${secrets.nas.password}" "domain=${secrets.nas.domain}" ];
      };
    };
  }

