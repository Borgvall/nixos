{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./compressingswap.nix
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

  services.fwupd.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "de_DE.UTF-8";

  system.autoUpgrade = {
    enable = true;
    runGarbageCollection = true;
    dates = "daily";
    allowReboot = false;
    flags = [
      "--update-input" "nixpkgs"
      "--no-write-lock-file"
      "--print-build-logs"
    ];
  };

  nix.gc = {
    options = "--delete-older-than 14d";
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

  users.users.test = {
    isNormalUser = true;
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

  programs.yazi = {
    enable = true;
    plugins = {
      inherit (pkgs.yaziPlugins) jump-to-char;
    };
    settings.keymap = {
      mgr.prepend_keymap = [
        {
          on = "f";
          run = "plugin jump-to-char";
          desc = "Jump to char";
        }
      ];
    };
  };

  programs.nix-index = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.virt-manager.enable = false;
  virtualisation.libvirtd.enable = false;

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

    psmisc
  ];

  # Damit Apps die Wörterbücher auch finden:
  environment.sessionVariables = {
    DICPATH = "/run/current-system/sw/share/hunspell:/run/current-system/sw/share/hyphen";
  };
}
