{ config, pkgs, ... }:

let
in
  {
    environment.variables = {
      HYPRLAND_LOG_WLR="1";

      # Tell XWayland to use a cursor theme
      XCURSOR_THEME="Bibata-Modern-Classic";

      # Set a cursor size
      XCURSOR_SIZE="24";

      # Example IME Support: fcitx
      GTK_IM_MODULE="fcitx";
      QT_IM_MODULE="fcitx";
      XMODIFIERS="@im=fcitx";
      SDL_IM_MODULE="fcitx";
      GLFW_IM_MODULE="ibus";

      WLR_RENDERER_ALLOW_SOFTWARE="1";
    };

    environment.systemPackages = with pkgs; [
      st
    ];

    programs.hyprland.enable = true;
    services.xserver.enable = true;
    services.xserver.displayManager.sddm.enable = true;
  }

