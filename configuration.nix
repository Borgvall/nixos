{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./gaming.nix
      ./sway.nix
      ./vim.nix
    ];

  fileSystems."/" = {
    options = [ "subvol=nixos-root" "compress=zstd" "noatime" ];
  };

  fileSystems."/nix" = {
    options = [ "subvol=nixos-nix" "compress=zstd" "noatime" ];
  };

  fileSystems."/home" = {
    options = [ "subvol=home" "compress=zstd" "noatime" ];
  };

  services.fstrim.enable = true;

  hardware.graphics.enable32Bit = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos-johannes";

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "de_DE.UTF-8";

  system.autoUpgrade = {
    enable = true;
    dates = "daily";
    allowReboot = false;
  };

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  security.apparmor = {
    enable = true;
    packages = [ pkgs.apparmor-profiles ];
  };

  services.xserver.enable = true;

  services.displayManager.gdm = {
    enable = true;
    wayland = true;
  };
  services.desktopManager.gnome.enable = true;
  

  services.xserver.xkb = {
    layout = "de,de";
    variant = "neo,nodeadkeys";
    options = "grp:sclk_toggle";
  };

  console.useXkbConfig = true; 

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [ pkgs.hplip ];
  };

  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.hplip ];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true; # Erlaubt Auflösung von .local Domains
    openFirewall = true; # Öffnet UDP 5353 für Avahi
  };

  # Firewall: Port 427 (SLP) wird oft für die HP-Erkennung benötigt
  networking.firewall.allowedUDPPorts = [ 427 ];

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  environment.etc."inputrc".text = ''
    set completion-ignore-case on
    #
    # Arrow keys in ANSI mode
    #
    "\C-[[A"        history-search-backward
    "\C-[[B"        history-search-forward
  '';

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.johannes = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  nixpkgs.config.allowUnfree = true;

  programs.firefox = {
    enable = true;
    languagePacks = [ "de" ];
  };

  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    lfs.enable = true;
    config = {
      init = {
        defaultBranch = "main";
      };
    };
  };

  programs.nix-index = {
    enable = true;
    enableBashIntegration = true;
  };

  environment.systemPackages = with pkgs; [
    apparmor-utils

    gitg

    evolution
    rhythmbox

    gimp

    (texlive.withPackages (ps: with ps; [
      scheme-medium
      koma-script
      moderncv
      ucs
    ]))
  ];

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?
}
