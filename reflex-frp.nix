{ config, ...}:

{
  # Enable the binary cache of Reflex-Frp on NixOS
  # see https://github.com/reflex-frp/reflex-platform/blob/develop/notes/NixOS.md
  nix.settings.substituters = [ "https://nixcache.reflex-frp.org" ];
  nix.settings.trusted-public-keys = [ "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI=" ];
}
