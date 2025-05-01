{ inputs, pkgs, ... }: {
  # Import the main Home Manager module for NixOS
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    # Use nixpkgs defined in the flake for consistency
    useGlobalPkgs = true;
    # Manage user packages defined in home.nix, etc.
    useUserPackages = true;

    # Pass flake inputs down to Home Manager modules (like home.nix)
    # This allows home.nix to potentially access things from flake inputs if needed.
    extraSpecialArgs = { inherit inputs; };

    # Define users managed by Home Manager
    users = {
      # Reference the specific home.nix file for the 'charlie' user
      charlie = import ./home.nix;
    };
  };
}