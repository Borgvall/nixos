# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
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

  hardware.graphics.enable32Bit = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos-johannes"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "de_DE.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # 1. Automatische Updates (inkl. Sicherheitsupdates)
  system.autoUpgrade = {
    enable = true;
    dates = "daily";
    allowReboot = false;
  };

  # 2. Automatische Bereinigung (Löscht alte Generationen)
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };

  # 3. Speicherplatz optimieren (Deduplizierung)
  # Identische Dateien im Store werden nur einmal gespeichert
  nix.settings.auto-optimise-store = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;


  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm = {
    enable = true;
    wayland = true;
  };
  services.desktopManager.gnome.enable = true;
  

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de,de";
    variant = "neo,nodeadkeys";
    options = "grp:sclk_toggle";
  };

  # Konfiguration für die Konsole (TTY)
  # Übernimmt das Layout von oben auch für das Terminal ohne Grafikoberfläche
  console.useXkbConfig = true; 

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

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
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
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
  programs.vim = {
    enable = true;
    package = pkgs.vim-full;
    defaultEditor = true;
  };

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    #remotePlay.openFirewall = true; # Optional: Für Steam Remote Play
    #dedicatedServer.openFirewall = true; # Optional: Für Source Dedicated Server
  };
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    ((vim-full.customize {
      vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
        start = [
          vim-fugitive
          vimtex
        ];
      };
      
      vimrcConfig.customRC = ''
        set nocompatible
        syntax on
        set shiftwidth=2 tabstop=2 softtabstop=2 expandtab
        set backspace=2
        set expandtab
        set autoindent
        set number

        filetype plugin indent on

        " Switch between windows
        nnoremap gl <C-w>w
        nnoremap gL <C-w>W

        set spell spelllang=de

        " Vertikales Aufteilen für den „diff-Modus“
        set diffopt=filler,vertical

        " Konfiguration für vimtex
        let g:vimtex_view_method = 'general'
      '';
    }))

    gitg

    evolution

    swaylock
    swaynotificationcenter
    wofi
    xfce.xfce4-terminal
    conky

    heroic
    bottles
    winetricks
    wineWow64Packages.staging

    gimp

    (texlive.withPackages (ps: with ps; [
      scheme-medium
      koma-script
      moderncv
      ucs
    ]))
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

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

