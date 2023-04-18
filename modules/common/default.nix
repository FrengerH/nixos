{ config, pkgs, lib, ... }:

let
   userConf = builtins.fromJSON(builtins.readFile("/etc/nixos/username.json"));
    unstable = import
        (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/nixpkgs-unstable)
        # reuse the current configuration
        { config = config.nixpkgs.config; };
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

      nix.settings.auto-optimise-store = true;

      nix.extraOptions = ''
        experimental-features = nix-command flakes
      '';

      hardware.enableAllFirmware  = true;
      
      users.defaultUserShell = unstable.fish;

      services.autorandr.enable = true;
      services.samba.enable = true;
      services.gvfs.enable = true;

      fonts.fonts = with pkgs; [
        fira-code
        (nerdfonts.override { fonts = [ "FiraCode" ]; })
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
        zoxide
        zellij
        wmctrl
        xdg-user-dirs
        numlockx
        cinnamon.nemo
        gnome.file-roller
        xorg.xrandr
        dracula-theme
        catppuccin-gtk
        any-nix-shell
        gnome.gnome-disk-utility
      ];

      programs = {
        fish = import ./programs/fish.nix;    
        starship = import ./programs/starship.nix;    
        nm-applet.enable = true;
      };

      environment.pathsToLink = [
        "/share/nix-direnv"
      ];

      nixpkgs.overlays = map import [ 
        ./overlays/firefox
        ./overlays/direnv
      ];
      
    };
  }
