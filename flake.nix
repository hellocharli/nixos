{
  description = "NixOS configuration for gwenix + Lanzaboote Secure Boot";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Lanzaboote input
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      # This is important! It makes lanzaboote use the same nixpkgs as your system,
      # preventing potential conflicts and reducing download/build size.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Add other flake inputs here if you use things like home-manager
    # home-manager = {
    #   url = "github:nix-community/home-manager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = { self, nixpkgs, lanzaboote, ... }@inputs: {
    nixosConfigurations."gwenix" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      # Pass flake inputs to modules. This allows modules (like configuration.nix)
      # to access flake inputs if needed, although it's not strictly necessary
      # for this specific setup.
      specialArgs = { inherit inputs; };

      modules = [
        # Import your main configuration file
        ./configuration.nix

        # Import your hardware-specific configuration
        ./hardware-configuration.nix

        # Import the Lanzaboote NixOS module from the flake input
        lanzaboote.nixosModules.lanzaboote

        # If using home-manager, add its module here:
        # inputs.home-manager.nixosModules.home-manager
      ];
    };

    # You can add other outputs here, like developer shells, packages, etc.
  };
}
