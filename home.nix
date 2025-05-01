# Home Manager configuration for user 'charlie'
{ pkgs, inputs, ... }: # 'inputs' is available via extraSpecialArgs

{
  # Set target username and home directory
  home.username = "charlie";
  home.homeDirectory = "/home/charlie";

  # Set state version for Home Manager itself
  home.stateVersion = "24.11";

  # Packages to install only for this user
  home.packages = with pkgs; [
    neofetch
    htop
  ];

  # Git configuration
  programs.git = {
    enable = true;
    userName = "charlie";
    userEmail = "111490544+hellocharli@users.noreply.github.com";
  };

  # Example: Starship prompt configuration (if you like custom prompts)
  # programs.starship = {
  #   enable = true;
  #   # Add custom settings if needed
  # };

  # Example: Basic shell alias
  # home.shellAliases = {
  #   ll = "ls -alF";
  #   update = "sudo nixos-rebuild switch --flake /etc/nixos#gwenix";
  #   hmupdate = "home-manager switch --flake /etc/nixos#charlie"; # Assumes you add a HM output later if desired
  # };

  # You can manage dotfiles here too:
  # home.file.".config/kitty/kitty.conf".source = ./dotfiles/kitty.conf;

  # Enable the Home Manager service itself
  programs.home-manager.enable = true;
}