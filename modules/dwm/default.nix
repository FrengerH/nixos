{ config, pkgs, ... }:

let
  rofiPkgs = import ./programs/rofi.nix { pkgs = pkgs; };
  dwmConfig = import ./overlays/configs/dwm.conf.nix { inherit config; inherit pkgs; };
  unstable = import
    (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/nixpkgs-unstable)
    # reuse the current configuration
    { config = config.nixpkgs.config; };
in
  {
    nix.extraOptions = ''
        experimental-features = nix-command flakes
    '';

    services.picom = {
      enable = true;
      settings = {
        inactive-opacity = 0.8;
        frame-opacity = 1.0;
        inactive-opacity-override = false;
        active-opacity = 1.0;
        inactive-dim = 0.2;
        opacity-rule = [
          "100:class_g = 'dwm'"
          "100:class_g = 'Rofi'"
        ];
        wintypes = {
          dock = { shadow = false; };
          dnd = { shadow = false; };
          tooltip = { shadow = false; };
          menu        = { opacity = false; };
          dropdown_menu = { opacity = false; };
          popup_menu    = { opacity = false; };
          utility       = { opacity = false; };
        };
        unredir-if-possible = false;
        backend = "xrender"; # try "glx" if xrender doesn't help
        vsync = true;
      };
    };

    hardware.enableAllFirmware  = true;

    users.defaultUserShell = unstable.fish;

    services.autorandr.enable = true;

    services.xserver.enable = true;
    services.xserver.displayManager = {
      # defaultSession = "none+dwm";
      lightdm = {
        enable = true;
        background = "/etc/wallpaper/wallpaper.jpg";
        greeters.gtk.extraConfig = ''
          hide-user-image=true
          indicators=~spacer;~spacer;~spacer;~spacer;~spacer;~spacer;~power
        '';
      };
    };
    
    services.xserver.windowManager.dwm = {
      enable = true;
      package = (pkgs.dwm.override { conf = dwmConfig.config; }); 
    };

    services.samba.enable = true;
    services.gvfs.enable = true;

    fonts.fonts = with pkgs; [
      fira-code
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];

    environment.extraInit = ''
      export DWM_AUTOSTART_DIR="/etc/dwm/autostart/"
    '';

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

    environment.etc."dwm/autostart/dwm".source = ./scripts/autostart;
    environment.etc."wallpaper/wallpaper.jpg".source = ./theme/wallpaper.jpg;
    environment.etc."zellij/config.kdl".source = ./overlays/configs/zellij.conf.kdl;
    environment.etc."zellij/layouts/main.kdl".source = ./overlays/configs/zellij.layout.kdl;

    environment.systemPackages = with pkgs; [
      st
      git
      feh
      xclip
      rink
      brightnessctl
      lightlocker
      xorg.xrandr
      dracula-theme
      catppuccin-gtk
      dwmblocks
      libnotify
      dunst
      pavucontrol
      alsa-firmware
      rofi
      rofiPkgs.power-menu
      rofiPkgs.launcher
      cinnamon.nemo
      gnome.file-roller
      numlockx
      xdg-user-dirs
      pulseaudio
      fasd
      zellij
      wmctrl
    ];

    programs = {
      fish = import ./programs/fish.nix;    
      starship = import ./programs/starship.nix;    
      nm-applet.enable = true;
    };

    nixpkgs.overlays = map import [ 
      # ./overlays/zellij.nix
      ./overlays/dwm.nix
      ./overlays/st.nix
      ./overlays/dwmblocks.nix
    ];
}
