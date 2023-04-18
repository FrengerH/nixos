{ config, pkgs, ... }:

let
  rofiPkgs = import ./programs/rofi.nix { pkgs = pkgs; };
  dwmConfig = import ./overlays/configs/dwm.conf.nix { inherit config; inherit pkgs; };
in
  {
    services.picom = {
      enable = true;
      settings = {
        # inactive-opacity = 0.8;
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

    environment.extraInit = ''
      export DWM_AUTOSTART_DIR="/etc/dwm/autostart/"
    '';

    environment.etc."dwm/autostart/dwm".source = ./scripts/autostart;

    environment.systemPackages = with pkgs; [
      st
      feh
      xclip
      rink
      brightnessctl
      lightlocker
      dwmblocks
      libnotify
      dunst
      pavucontrol
      alsa-firmware
      rofi
      rofiPkgs.power-menu
      rofiPkgs.launcher
      pulseaudio
    ];

    nixpkgs.overlays = map import [ 
      ./overlays/dwm.nix
      ./overlays/st.nix
      ./overlays/dwmblocks.nix
    ];
  }
