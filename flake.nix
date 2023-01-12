{
  description = "System flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
  };
  
  outputs = {self, nixpkgs, ...} @inputs:
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
          /etc/nixos/configuration.nix
          ./modules/dwm
          ./modules/vm
          #./modules/virt-manager
          ./modules/neovim
          ./modules/common
          ./modules/wireguard
        ];

        specialArgs = { inherit inputs; };
      };

      work = lib.nixosSystem {
        inherit system;

        modules = [
          /etc/nixos/configuration.nix
          ./modules/dwm
          ./modules/virt-manager
          ./modules/neovim
          ./modules/common
          ./modules/work
          ./modules/wireguard
          ./modules/laptop-hp
        ];

        specialArgs = { inherit inputs; };
      };

    };
  };
}
