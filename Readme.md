# NixOS Configuration (nixos-johannes)

This is the modular NixOS configuration for the host `nixos-johannes`, designed for gaming, productivity, and a tiling window manager workflow.

## ✨ Features

* **Desktop Environment:** Sway (Wayland) with a custom configuration for multi-monitor setups (HP & Samsung) and a status bar via `conky`.
* **Input:** System-wide keyboard layout configured for **Neo2** (`de`, `neo`).
* **Gaming:** Optimized setup including Steam (with Gamescope & Proton-GE), Heroic Launcher, Bottles, MangoHud, and Gamemode.
* **Editor:** Vim set as the default editor, heavily customized for LaTeX (`vimtex`) and Git (`vim-fugitive`).
* **Filesystem:** Btrfs with subvolumes (`nixos-root`, `nixos-nix`, `home`) and zstd compression.
* **Virtualization:** Enabled `libvirtd` and `virt-manager`.

## 📂 File Structure

* **`configuration.nix`**: The central entry point. Manages system services, the user (`johannes`), network settings, and base packages.
* **`sway.nix`**: Configuration for the Sway Window Manager, including keybindings, display outputs, and window-specific rules.
* **`gaming.nix`**: Bundles all gaming-relevant packages and settings (Steam, Wine, drivers).
* **`vim.nix`**: Configuration for Vim, including plugins and `.vimrc` settings.
* **`hardware-configuration.nix`**: Automatically generated hardware detection and filesystem mounts.

## ℹ️ Notes

* **State Version:** 25.11.
* **Printing/Scanning:** HPLIP drivers for HP printers and scanners are pre-installed.
* **Maintenance:** Automatic updates and Garbage Collection (daily, deleting items older than 7 days) are enabled.
