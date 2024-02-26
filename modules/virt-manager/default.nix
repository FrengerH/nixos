{ config, pkgs, ... }:

let
  nixos-vm = pkgs.writeShellScriptBin "nixos-vm" ''
    state=`virsh dominfo nixos | grep 'State:' | awk '{ print $2 }'`
    if [ "$state" != "running" ]; then
      virsh start nixos
    fi
    virt-viewer -c virt-viewer -c qemu:///session --domain-name nixos -f -w
  '';
  nixos-bug = pkgs.writeShellScriptBin "nixos-bug" ''
    state=`virsh dominfo bug | grep 'State:' | awk '{ print $2 }'`
    if [ "$state" != "running" ]; then
      virsh start bug
    fi
    virt-viewer -c virt-viewer -c qemu:///session --domain-name bug -f -w
  '';
  nixos-vm-desktop = (pkgs.makeDesktopItem {
    name = "nixos-vm";
    desktopName = "Nixos vm";
    exec = "nixos-vm";
  });
  nixos-bug-desktop = (pkgs.makeDesktopItem {
    name = "nixos-bug";
    desktopName = "Nixos bug";
    exec = "nixos-bug";
  });
in
  {
    boot.kernelModules = [ "kvm-intel" ];
    virtualisation.libvirtd.enable = true;
    # virtualisation.libvirtd.extraConfig = ''
    #   unix_sock_group = "libvirtd"
    #   unix_sock_rw_perms = "0770"
    # '';
    environment.systemPackages = with pkgs; [
      virt-manager
      virt-viewer
      dconf
      nixos-vm
      nixos-vm-desktop
      nixos-bug
      nixos-bug-desktop
    ];

    virtualisation.spiceUSBRedirection.enable = true;

    users.users.${config.defaultUser}.extraGroups = [ "libvirtd" ];
  }

