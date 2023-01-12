{ config, pkgs, lib, ... }:

let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in
  {
    boot.kernelPackages = pkgs.linuxPackages_6_0;

    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.opengl.enable = true;
    services.hardware.bolt.enable = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
    hardware.nvidia.modesetting.enable = true;

    boot.extraModprobeConfig = ''
      options nvidia_drm modeset=1
    '';

    hardware.nvidia.prime = {
      offload.enable = true;

      # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
      intelBusId = "PCI:0:2:0";

      # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
      nvidiaBusId = "PCI:1:0:0";
    };

    environment.systemPackages = with pkgs; [
      nvidia-offload
    ];

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

    users.users.${config.defaultUser}.extraGroups = [ "audio" ];

    services.xserver.libinput.enable = true;
    services.xserver.libinput.touchpad.naturalScrolling = true;
    services.xserver.libinput.touchpad.tapping = true;

    boot = {
      kernelModules = [ "acpi_call" ];
      extraModulePackages = with config.boot.kernelPackages; [
        acpi_call 
        nvidia_x11
      ];
    };

    services.acpid.enable = true;
    services.autorandr.enable = true;

    services.autorandr = {
      hooks.postswitch = {
        "change-bg" = "feh --bg-fill /etc/wallpaper/wallpaper.jpg";
      };
      profiles = {
        "defaulti" = {
          fingerprint = {
            eDP1 = "00ffffffffffff0006af8ba000000000001d0104a5221378033e8591565991281f505400000001010101010101010101010101010101143780b4703824406c30aa0058c110000018b82480b4703824406c30aa0058c11000001800000000000000000000000000000000000000000002001430ff123cc80b0719c820202000bd";
          };
          config = {
            eDP1 = {
              enable = true;
              crtc = 0;
              primary = true;
              position = "0x0";
              mode = "1920x1080";
              rate = "60.16";
            };
          };
        };
        "default" = {
          fingerprint = {
            eDP-1 = "00ffffffffffff0006af8ba000000000001d0104a5221378033e8591565991281f505400000001010101010101010101010101010101143780b4703824406c30aa0058c110000018b82480b4703824406c30aa0058c11000001800000000000000000000000000000000000000000002001430ff123cc80b0719c820202000bd";
          };
          config = {
            eDP-1 = {
              enable = true;
              crtc = 0;
              primary = true;
              position = "0x0";
              mode = "1920x1080";
              rate = "60.16";
            };
          };
        };
        "homei" = {
          fingerprint = {
            eDP1 = "00ffffffffffff0006af8ba000000000001d0104a5221378033e8591565991281f505400000001010101010101010101010101010101143780b4703824406c30aa0058c110000018b82480b4703824406c30aa0058c11000001800000000000000000000000000000000000000000002001430ff123cc80b0719c820202000bd";
            DP2-1 = "00ffffffffffff0010ac7aa04c4d4a302f15010380342078eaee95a3544c99260f5054a1080081408180a940b300d1c0010101010101283c80a070b023403020360006442100001a000000ff005931483554314248304a4d4c0a000000fc0044454c4c2055323431324d0a20000000fd00323d1e5311000a20202020202000fb";
          };
          config = {
            eDP1 = {
              enable = true;
              crtc = 0;
              primary = false;
              position = "1920x0";
              mode = "1920x1080";
              rate = "60.16";
            };
            DP2-1 = {
              enable = true;
              crtc = 1;
              primary = true;
              position = "0x0";
              mode = "1920x1200";
              rate = "59.95";
            };
          };
        };
        "home" = {
          fingerprint = {
            eDP-1 = "00ffffffffffff0006af8ba000000000001d0104a5221378033e8591565991281f505400000001010101010101010101010101010101143780b4703824406c30aa0058c110000018b82480b4703824406c30aa0058c11000001800000000000000000000000000000000000000000002001430ff123cc80b0719c820202000bd";
            DP-2-1 = "00ffffffffffff0010ac7aa04c4d4a302f15010380342078eaee95a3544c99260f5054a1080081408180a940b300d1c0010101010101283c80a070b023403020360006442100001a000000ff005931483554314248304a4d4c0a000000fc0044454c4c2055323431324d0a20000000fd00323d1e5311000a20202020202000fb";
          };
          config = {
            eDP-1 = {
              enable = true;
              crtc = 0;
              primary = false;
              position = "1920x0";
              mode = "1920x1080";
              rate = "60.16";
            };
            DP-2-1 = {
              enable = true;
              crtc = 1;
              primary = true;
              position = "0x0";
              mode = "1920x1200";
              rate = "59.95";
            };
          };
        };
      };
    };
  }

