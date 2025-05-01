# Main system configuration, imported by flake.nix
{ config, lib, pkgs, inputs, ... }: # Note: 'inputs' is available via specialArgs from flake.nix

{
  # Pin the kernel to 'latest'
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Hostname
  networking.hostName = "gwenix";

  # Network configuration
  networking.useDHCP = false;
  services.resolved.llmnr = "false";
  systemd.network.enable = true;
  systemd.network.networks."10-frieren-realm" = {
    matchConfig.Name = "ens18";
    address = [ "10.20.20.9/24" ];
    routes = [ { Gateway = "10.20.20.1"; } ];
    dns = [ "10.20.20.1" ];
    domains = [ "frieren.realm" "frieren.vpn" ];
    linkConfig.RequiredForOnline = "routable";
  };

  # Time zone
  time.timeZone = "America/Los_Angeles";

  # Internationalisation
  i18n.defaultLocale = "en_US.UTF-8";

  # Swap
  swapDevices = [ { device = "/.swapfile"; size = 4096; } ];

  # X11 Keymap
  services.xserver.xkb.layout = "us";

  # Users and user settings
  users.mutableUsers = false;
  security.sudo.wheelNeedsPassword = false;
  users.users = {
    root = {
      hashedPassword = "$y$j9T$SdinXsXYNP1r.nDqiTofV/$W.q5mGKvWs89/F6pRRgZ/dLCFhNgGSE0clUtbCF95p.";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEE13L/7S03mXtA4275QE5GT6LXgRPHuqx41E1Bd7ecJ charlie@Gwen"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEQdXL/1hfuL1TaXRVnDGppR+7cLBDn19U/sxc00r2EY charlie.lowe@aubergeresorts.com"
      ];
    };

    charlie = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      hashedPassword = "$y$j9T$SdinXsXYNP1r.nDqiTofV/$W.q5mGKvWs89/F6pRRgZ/dLCFhNgGSE0clUtbCF95p.";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEE13L/7S03mXtA4275QE5GT6LXgRPHuqx41E1Bd7ecJ charlie@Gwen"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEQdXL/1hfuL1TaXRVnDGppR+7cLBDn19U/sxc00r2EY charlie.lowe@aubergeresorts.com"
      ];
    };
  };

  # Enable Hyprland and Firefox
  programs.hyprland.enable = true;
  programs.firefox.enable = true;

  # System-wide packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    dig
    kitty
  ];

  # SSH Server
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = true;
      PubkeyAuthentication = true;
    };
  };

  # System state version
  system.stateVersion = "24.11";
}