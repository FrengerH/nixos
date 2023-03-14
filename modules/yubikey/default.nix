{ config, pkgs, ... }:

let
  lock = pkgs.writeShellScriptBin "lock" (builtins.readFile ./scripts/lock.sh); 
in
  {
    services.udev.packages = [ pkgs.yubikey-personalization ];
    services.pcscd.enable = true;

    services.udev.extraRules = ''
      ACTION=="remove", ENV{PRODUCT}=="1050/407/*", RUN+="${lock}/bin/lock"
    '';

    security.pam.u2f.enable = true;
    security.pam.u2f.control = "required";
    security.pam.services = {
      login.u2fAuth = true;
      sudo.u2fAuth = true;
    };

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "qt";
    };

    environment.systemPackages = with pkgs; [
      yubikey-manager-qt
      yubikey-personalization
      yubikey-touch-detector
      pinentry-qt
    ];
    
    environment.shellInit = ''
      gpg-connect-agent /bye
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    '';
  }

