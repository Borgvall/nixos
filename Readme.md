# NixOS Configuration

Personal NixOS flake configuration, currently for the host `johannes-pc`
(Sway/GNOME, gaming, development, etc.).

## Apply

    sudo nixos-rebuild switch --flake .#johannes-pc

## Structure

- `flake.nix` — entry point, defines `nixosConfigurations`.
- `hosts/<name>/` — host-specific configuration (hardware, filesystems, hostname, ...).
- Remaining `*.nix` files at the root — topical, host-independent modules (desktop, gaming, editor, maintenance, ...).
- `pkgs/` — custom package definitions.

Details about individual modules (what's enabled, which options are set) live
in the respective file rather than here, so this overview doesn't go stale.
