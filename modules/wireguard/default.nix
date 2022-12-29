{ config, pkgs, ... }:

let
  # cp -Rf secrets/nixos ~/.config/nixos/secrets.json
  secrets = builtins.fromJSON(builtins.readFile("/home/" + config.defaultUser + "/.config/nixos/secrets.json"));

in
  {
    environment.systemPackages = with pkgs; [
      wireguard-tools
    ];

    networking.firewall = {
      allowedUDPPorts = [ secrets.wireguard.listenport ];
    };

    networking.wg-quick.interfaces = {
      wg0 = {
        address = [ secrets.wireguard.client_ip ];
        dns = [ secrets.wireguard.dns ];

        # Creating a keypair is simple:

        # umask 077
        # mkdir ~/wireguard-keys
        # wg genkey > ~/wireguard-keys/private
        # wg pubkey < ~/wireguard-keys/private > ~/wireguard-keys/public

        privateKeyFile = "/home/" + config.defaultUser + "/.config/nixos/wireguard-keys/private";

        peers = [
          {
            publicKey = secrets.wireguard.server_public_key;
            # allowedIPs = [ "0.0.0.0/0" ];
            allowedIPs = secrets.wireguard.allowed_ips;
            endpoint = secrets.wireguard.endpoint;
            persistentKeepalive = 25;
          }
        ];
      };
    };
  }
