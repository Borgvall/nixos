{pkgs, ...}:

let
  kernel = pkgs.linux_7_2.override {
    argsOverride = rec {
      src = /home/johannes/src/linux-7.2-regression;

      # Must be adapted to the tree state:
      version = "7.2.8";
      modDirVersion = version;
    };
  };
in
{
  boot.kernelPackages = pkgs.linuxPackagesFor kernel;
}
