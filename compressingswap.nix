{ config, ... }:
let
  hasSwapDevice = [ ] != config.swapDevices;
in
{
  boot.zswap.enable = hasSwapDevice;
  zramSwap.enable = !hasSwapDevice;
}
