{ config, pkgs, ... }:

let
  rofiPkgs = import ./programs/rofi.nix { pkgs = pkgs; };
  dwmConfig = pkgs.writeText "config.def.h" (builtins.readFile ./overlays/configs/dwm.conf.h);
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
      package = (pkgs.dwm.override { conf = dwmConfig; }); 
    };

    services.samba.enable = true;
    services.gvfs.enable = true;

    services.acpid.enable = true;
    services.autorandr.enable = true;

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
