{ pkgs, lib, ... }:

{
  imports = [
    ./compressingswap.nix
    ./developement.nix
    ./dictionaries.nix
    ./dvd-mount.nix
    ./host-specific-options.nix
    ./hpofficejet.nix
    ./internet.nix
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

  boot.kernelPackages = pkgs.linuxPackages_latest;

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

  services.xserver.xkb = {
    layout = "de,de";
    variant = lib.mkDefault "neo,nodeadkeys";
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

  programs.command-not-found.enable = true;

  environment.shellAliases = {
    sudo-wayland = "sudo --preserve-env=XDG_RUNTIME_DIR,WAYLAND_DISPLAY";
  };

  environment.systemPackages = with pkgs; [
    rhythmbox
    celluloid
    geeqie
    mpv
    yt-dlp

    libreoffice

    file
    net-tools
    psmisc
  ];
}
