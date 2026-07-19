{ ... }:
{
  system.autoUpgrade = {
    enable = true;
    runGarbageCollection = true;
    dates = "daily";
    allowReboot = false;
    flags = [
      "--update-input"
      "nixpkgs"
      "--no-write-lock-file"
      "--print-build-logs"
    ];
  };

  nix.gc = {
    options = "--delete-older-than 14d";
  };

}
