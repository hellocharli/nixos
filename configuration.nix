# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:
{
  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # Don't use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = lib.mkForce false;

  # Use the lanzaboote version of systemd-boot (systemd-boot is actually still used)
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  # Hostname
  networking.hostName = "gwenix";

  # Network configuration
  networking.useDHCP = false;
  services.resolved.llmnr = "false";
  systemd.network.enable = true;
  systemd.network.networks."10-frieren-realm" = {
    matchConfig.Name = "ens18";
    address = [ "10.20.20.9/24" ];
    routes = [
      { Gateway = "10.20.20.1"; }
    ];
    dns = [ "10.20.20.1" ];
    domains = [
      "frieren.realm"
      "frieren.vpn"
    ];
    linkConfig.RequiredForOnline = "routable";
  };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  swapDevices = [ { device = "/.swapfile"; size = 4096; } ];

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Users and user settings
  users.mutableUsers = false; # Enforce user state from this file
  security.sudo.wheelNeedsPassword = false; # Enable passwordless sudo for 'wheel'

  users.users = {
    # Root User Configuration
    root = {
      hashedPassword = "$y$j9T$SdinXsXYNP1r.nDqiTofV/$W.q5mGKvWs89/F6pRRgZ/dLCFhNgGSE0clUtbCF95p.";

      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEE13L/7S03mXtA4275QE5GT6LXgRPHuqx41E1Bd7ecJ charlie@Gwen"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEQdXL/1hfuL1TaXRVnDGppR+7cLBDn19U/sxc00r2EY charlie.lowe@aubergeresorts.com"
      ];
    };

    # Charlie User Configuration
    charlie = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      hashedPassword = "$y$j9T$SdinXsXYNP1r.nDqiTofV/$W.q5mGKvWs89/F6pRRgZ/dLCFhNgGSE0clUtbCF95p.";

      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEE13L/7S03mXtA4275QE5GT6LXgRPHuqx41E1Bd7ecJ charlie@Gwen"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEQdXL/1hfuL1TaXRVnDGppR+7cLBDn19U/sxc00r2EY charlie.lowe@aubergeresorts.com"
      ];

      # User-specific packages
      packages = with pkgs; [
        neofetch
      ];
    };
  };

  programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    dig
    sbctl
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      # Allow root login, but ONLY with public key authentication
      PermitRootLogin = "prohibit-password";

      # Explicitly allow password authentication globally (for charlie)
      # This is often the default, but being explicit is good.
      PasswordAuthentication = true;

      # Ensure Public Key authentication is enabled (usually default)
      PubkeyAuthentication = true;
    };
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  system.stateVersion = "24.11";
}
