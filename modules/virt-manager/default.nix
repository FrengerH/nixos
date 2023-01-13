{ config, pkgs, ... }:

let
in
  {
    boot.kernelModules = [ "kvm-intel" ];
    virtualisation.libvirtd.enable = true;
    environment.systemPackages = with pkgs; [
      virt-manager
      virt-viewer
      dconf
    ];
    
    users.users.${config.defaultUser}.extraGroups = [ "libvirtd" ];
  }

