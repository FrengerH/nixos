{ config, pkgs, ... }:

let
in
  {
    boot.kernelModules = [ "kvm-intel" ];
    virtualisation.libvirtd.enable = true;
    environment.systemPackages = with pkgs; [
      virt-manager
    ];
    
    users.users.${config.defaultUser}.extraGroups = [ "libvirtd" ];
  }

