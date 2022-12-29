{ config, pkgs, ... }:

let
  rofiPkgs = import ./programs/rofi.nix { pkgs = pkgs; };
in
  {
    nix.extraOptions = ''
        experimental-features = nix-command flakes
    '';

    sound.enable = true;
    hardware.pulseaudio.enable = true;
    hardware.pulseaudio.package = pkgs.pulseaudioFull;
    hardware.enableAllFirmware  = true;

    users.users.${config.defaultUser}.extraGroups = [ "audio" ];

    users.defaultUserShell = pkgs.fish;

    services.xserver.libinput.enable = true;
    services.xserver.libinput.touchpad.naturalScrolling = true;
    services.xserver.libinput.touchpad.tapping = true;

    services.xserver.enable = true;
    services.xserver.displayManager.lightdm.enable = true;
    services.xserver.windowManager.dwm = {
      enable = true;
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

    environment.etc."dwm/autostart/dwm".source = ./scripts/autostart;
    environment.etc."wallpaper/wallpaper.jpg".source = ./theme/wallpaper.jpg;

    environment.systemPackages = with pkgs; [
      st
      git
      feh
      lshw
      xclip
      rink
      lightlocker
      xorg.xrandr
      autorandr
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
      usbutils
      cinnamon.nemo
      gnome.file-roller
    ];

    programs = {
      tmux = import ./programs/tmux.nix { pkgs = pkgs; };
      fish = import ./programs/fish.nix;    
      starship = import ./programs/starship.nix;    
      nm-applet.enable = true;
    };

    nixpkgs.overlays = map import [ 
      ./overlays/dwm.nix
      ./overlays/st.nix
      ./overlays/tmux-dracula.nix
      ./overlays/dwmblocks.nix
    ];
}
