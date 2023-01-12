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
    boot.kernelPackages = pkgs.linuxPackages_6_0;
    nix.extraOptions = ''
        experimental-features = nix-command flakes
    '';

    sound.enable = pkgs.lib.mkForce false;
    # hardware.pulseaudio.enable = true;
    # hardware.pulseaudio.package = pkgs.pulseaudioFull;

    hardware.pulseaudio.enable = pkgs.lib.mkForce false;
    # rtkit is optional but recommended
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
    };

    services.picom = {
      enable = true;
      settings = {
        inactive-opacity = 0.8;
        frame-opacity = 1.0;
        inactive-opacity-override = false;
        active-opacity = 1.0;
        inactive-dim = 0.2;
        opacity-rule = [
          "99:class_g = 'dwm'"
          "99:class_g = 'Rofi'"
        ];
      };
    };

    hardware.enableAllFirmware  = true;

    users.users.${config.defaultUser}.extraGroups = [ "audio" ];

    users.defaultUserShell = unstable.fish;

    services.xserver.libinput.enable = true;
    services.xserver.libinput.touchpad.naturalScrolling = true;
    services.xserver.libinput.touchpad.tapping = true;

    services.xserver.enable = true;
    services.xserver.displayManager = {
      # defaultSession = "none+dwm";
      lightdm = {
        enable = true;
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

    boot = {
      kernelModules = [ "acpi_call" ];
      extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
    };

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
