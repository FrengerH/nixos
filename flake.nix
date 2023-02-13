{
  description = "System flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
    hyprland.url = "github:hyprwm/Hyprland";
  };
  
  outputs = {self, nixpkgs, hyprland, ...} @inputs:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config = { 
        allowUnfree = true; 
        pulseaudio = true;
      };
    };

    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      nixos-vm = lib.nixosSystem {
        inherit system;

        modules = [
          # hyprland.nixosModules.default
          # ./modules/hyprland
          /etc/nixos/configuration.nix
          ./modules/dwm
          ./modules/common
          ./modules/vm
          ./modules/neovim
          ./modules/wireguard
        ];

        specialArgs = { inherit inputs; };
      };

      work = lib.nixosSystem {
        inherit system;

        modules = [
          /etc/nixos/configuration.nix
          ./modules/dwm
          ./modules/common
          ./modules/virt-manager
          ./modules/neovim
          ./modules/work
          ./modules/wireguard
          ./modules/laptop-hp
        ];

        specialArgs = { inherit inputs; };
      };

    };
  };
}
