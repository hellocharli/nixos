{
  description = "NixOS configuration for gwenix with Lanzaboote Secure Boot";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, lanzaboote, home-manager, ... }@inputs: {
    nixosConfigurations."gwenix" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      # Pass flake inputs to all modules.
      # This allows configuration.nix or other modules to access them if needed.
      specialArgs = { inherit inputs; };

      modules = [
        # 1. Import Lanzaboote module
        lanzaboote.nixosModules.lanzaboote

        # 2. Configure Lanzaboote and related bootloader settings
        ({ lib, pkgs, ... }: {
          # Enable flakes system-wide
          nix.settings.experimental-features = [ "nix-command" "flakes" ];

          # Lanzaboote configuration
          boot.lanzaboote = {
            enable = true;
            pkiBundle = "/var/lib/sbctl";
          };

          # Explicitly disable the standard systemd-boot loader
          # as Lanzaboote provides its own version/management.
          boot.loader.systemd-boot.enable = lib.mkForce false;

          # Install sbctl package for key management
          environment.systemPackages = [ pkgs.sbctl ];
        })

        # 3. Import hardware configuration
        ./hosts/vm/hardware-configuration.nix

        # 4. Import main system configuration
        ./configuration.nix

        # 5. Import Home Manager setup module
        # This keeps the flake cleaner than defining HM inline.
        ./home-manager.nix

        # Optional: Add other custom modules here if you create them
        # ./modules/my-custom-settings.nix
      ];
    };

    # You can add other outputs here later (e.g., dev shells) if needed.
  };
}