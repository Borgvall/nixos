{ pkgs, ... }:

{
  imports = [
    ./compressingswap.nix
    ./dvd-mount.nix
    ./host-specific-options.nix
    ./hpofficejet.nix
    ./kernellocal.nix
    ./sway.nix
    ./upgradesandgc.nix
    ./users.nix
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

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "de_DE.UTF-8";

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
  };

  services.xserver.enable = true;

  services.displayManager.gdm = {
    enable = true;
  };
  services.desktopManager.gnome.enable = true;

  # Hint Electron Apps to use Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.xserver.xkb = {
    layout = "de,de";
    variant = "neo,nodeadkeys";
    options = "grp:sclk_toggle";
  };

  console.useXkbConfig = true;

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
  programs.command-not-found.enable = false;

  environment.systemPackages = with pkgs; [
    ghc
    nixfmt
    gh

    signal-desktop
    wire-desktop

    chromium

    rhythmbox
    celluloid
    geeqie
    mpv
    yt-dlp

    libreoffice
    hunspell
    hunspellDicts.de_DE
    hunspellDicts.en_US
    hyphen
    hyphenDicts.de_DE
    hyphenDicts.en_US

    file
    net-tools
    psmisc
  ];

  # Damit Apps die Wörterbücher auch finden:
  environment.sessionVariables = {
    DICPATH = "/run/current-system/sw/share/hunspell:/run/current-system/sw/share/hyphen";
  };
}
