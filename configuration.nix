{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hosts/johannes-pc/configuration.nix

      ./flatpak.nix
      ./gaming.nix
      ./reflex-frp.nix
      ./sway.nix
      ./vim.nix
    ];

  services.fstrim.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.cpu.amd.updateMicrocode = true;
  services.fwupd.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

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
  #           Port 161 SNMP status check of HP Printers
  networking.firewall.allowedUDPPorts = [ 161 427 ];

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
    extraGroups = [ "libvirtd" "wheel" ];
  };

  nixpkgs.config.allowUnfree = true;

  programs.direnv = {
    enable = true;
  };

  programs.firefox = {
    enable = true;
    languagePacks = [ "de" ];
  };

  programs.evolution = {
    enable = true;
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

  programs.virt-manager.enable = true;
  virtualisation.libvirtd.enable = true;

  # Dconf is needed by virt-manager
  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    ghc

    signal-desktop
    rhythmbox
    celluloid
    mpv
    yt-dlp

    libreoffice-fresh
    hunspell
    hunspellDicts.de_DE
    hunspellDicts.en_US
    hyphen
    hyphenDicts.de_DE
    hyphenDicts.en_US

    ollama-vulkan
    alpaca

    psmisc
  ];

  # Damit Apps die Wörterbücher auch finden:
  environment.sessionVariables = {
    DICPATH = "/run/current-system/sw/share/hunspell:/run/current-system/sw/share/hyphen";
  };

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
