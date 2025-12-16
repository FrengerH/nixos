{ config, pkgs, lib, ... }:

let
  userConf = builtins.fromJSON(builtins.readFile("/etc/nixos/username.json"));
  unstable = import
    (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/nixpkgs-unstable)
    # reuse the current configuration
    { config = config.nixpkgs.config; };
  old = import (builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/5a83f6f984f387d47373f6f0c43b97a64e7755c0.tar.gz";
  }) {};
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

      boot.supportedFilesystems = [ "ntfs" ];
#      boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
      boot.initrd.supportedFilesystems = [ "nfs" ];
      boot.initrd.availableKernelModules = [ "nfs" ];

#      fileSystems."/mnt/nfs" = {
#        device = "192.168.123.149:/media";   # replace with server details
#        fsType = "nfs";                            # or "nfs4" for NFSv4
#        options = [
#          "rw"
#          "hard"
#          "nfsvers=3"
#        ];
#      };

      nix.settings.auto-optimise-store = true;

      nix.extraOptions = ''
        experimental-features = nix-command flakes
      '';

      hardware.enableAllFirmware  = true;
      
      users.defaultUserShell = pkgs.fish;

      services.autorandr.enable = true;
      services.samba.enable = true;
      services.gvfs.enable = true;

      fonts.packages = with pkgs; [
        fira-code
        nerd-fonts.fira-code
      ];

      environment.etc."xdg/gtk-3.0/settings.ini" = {
        text = ''
          [Settings]
          gtk-icon-theme-name=Dracula
          gtk-theme-name=Adwaita-dark
          gtk-cursor-theme-name=Adwaita
        '';
        mode = "444";
      };

      environment.etc."xdg/user-dirs.defaults".text = ''
        DESKTOP=/home/${config.defaultUser}/.desktop
        DOWNLOAD=/home/${config.defaultUser}/downloads
        TEMPLATES=/home/${config.defaultUser}
        PUBLICSHARE=/home/${config.defaultUser}
        DOCUMENTS=/home/${config.defaultUser}
        MUSIC=/home/${config.defaultUser}
        PICTURES=/home/${config.defaultUser}
        VIDEOS=/home/${config.defaultUser}
      '';

      environment.etc."wallpaper/wallpaper.jpg".source = ./theme/wallpaper.jpg;
      environment.etc."zellij/config.kdl".source = ./overlays/configs/zellij.conf.kdl;
      environment.etc."zellij/layouts/main.kdl".source = ./overlays/configs/zellij.layout.kdl;
      environment.etc."zellij/plugins/custom-compact-bar.wasm".source = ./scripts/compact-bar.wasm;

      # Create symlink for user zellij config to use Nix-managed config
      system.activationScripts.zellijConfig = ''
        mkdir -p /home/${config.defaultUser}/.config/zellij
        rm -f /home/${config.defaultUser}/.config/zellij/config.kdl
        ln -sf /etc/zellij/config.kdl /home/${config.defaultUser}/.config/zellij/config.kdl
        chown -h ${config.defaultUser}:users /home/${config.defaultUser}/.config/zellij/config.kdl
      '';

      users.users.${config.defaultUser}.extraGroups = [ "dialout" ];

      services.printing.enable = true;
      services.avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };

      environment.systemPackages = with pkgs; [
        nfs-utils
        unstable.obsidian
        alsa-utils
        system-config-printer
        epson-escpr2
        git
        gcc
        ripgrep
        gimp
        nmap
        flameshot
        old.libreoffice
        bat
#        sweethome3d.application
        zoxide
        unstable.zellij
        unstable.ollama
        # (callPackage unstable.ollama.override { llama-cpp = (unstable.llama-cpp.override {cudaSupport = true; openblasSupport = false; }); })
        wmctrl
        xdg-user-dirs
        numlockx
        nemo-with-extensions
        xorg.xrandr
        dracula-theme
        catppuccin-gtk
        any-nix-shell
        gnome-disk-utility
        jq
        yq
        claude-code
      ];

      programs = {
        fish = import ./programs/fish.nix;    
        starship = import ./programs/starship.nix;    
        firefox = import ./programs/firefox.nix{inherit pkgs;};
        nm-applet.enable = true;
        direnv = {
          enable = true;
          silent = true;
          nix-direnv.enable = true;
        };
      };

      # nixpkgs.overlays = map import [ 
      #   ./overlays/firefox
      # ];
      
    };
  }
