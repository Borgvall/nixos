{
  config,
  pkgs,
  ...
}:

{
  programs.hyprland = {
    enable = true;
    # XWayland wird standardmäßig aktiviert
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  environment.etc."hypr/hyprland.conf".text =
    let
      xkb = config.services.xserver.xkb;
    in ''
    # Hyprland configuration file

    # --- Monitors ---
    monitor = Hewlett Packard HP 27es 3CM9271PKW, preferred, auto, 1
    monitor = Samsung Electric Company SAMSUNG 0x00000F00, preferred, auto, 1, vrr, 1
    monitor = Unknown Unknown Unknown, 1600x1200@60, auto, 1
    monitor = Red Hat, Inc. QEMU Monitor Unknown, 1600x1200@60, auto, 1
    monitor = *, background #c9ecee, preferred, auto, 1

    # --- Input ---
    input {
      kb_layout = ${xkb.layout}
      kb_variant = ${xkb.variant}
      kb_options = ${xkb.options}
      follow_mouse = 1
    }

    # --- General / Gaps ---
    general {
      gaps_in = 4
      gaps_out = 4
      border_size = 2
      layout = dwindle
    }

    decoration {
      rounding = 0
    }

    # --- Keybindings ---
    $mod = SUPER

    # Start a terminal
    bind = $mod, Return, exec, alacritty

    # Kill focused window
    bind = $mod, V, killactive

    # Start wofi (program launcher)
    bind = $mod, E, exec, wofi -S run
    bind = $mod, P, exec, wofi -S drun

    # Start wofi-emoji
    bind = $mod, colon, exec, wofi-emoji

    # Search and open files in home directory
    bind = $mod SHIFT, F, exec, fd -d 5 . ~ | wofi -i --dmenu | xargs -r -d \\n xdg-open

    # Change focus (N, T, R, D layout)
    bind = $mod, N, movefocus, l
    bind = $mod, T, movefocus, d
    bind = $mod, R, movefocus, u
    bind = $mod, D, movefocus, r

    # Move focused window
    bind = $mod SHIFT, H, movewindow, l
    bind = $mod SHIFT, F, movewindow, d
    bind = $mod SHIFT, G, movewindow, u
    bind = $mod SHIFT, Q, movewindow, r

    # Arrow keys for moving focus
    bind = $mod, Left, movefocus, l
    bind = $mod, Down, movefocus, d
    bind = $mod, Up, movefocus, u
    bind = $mod, Right, movefocus, r

    # Arrow keys for moving windows
    bind = $mod SHIFT, Left, movewindow, l
    bind = $mod SHIFT, Down, movewindow, d
    bind = $mod SHIFT, Up, movewindow, u
    bind = $mod SHIFT, Right, movewindow, r

    # Enter fullscreen mode
    bind = $mod, L, fullscreen, 0

    # Toggle tiling / floating
    bind = $mod SHIFT, Space, togglefloating

    # Focus parent / child (Hyprland handles focus tree differently, fallback to group/focus invariants or basic switching)
    bind = $mod, M, layoutmsg, focusmaster
    bind = $mod SHIFT, M, layoutmsg, swapprev

    # Switch workspaces
    bind = $mod, period, workspace, m+1
    bind = $mod, comma, workspace, m-1
    bind = $mod, 1, workspace, 1
    bind = $mod, 2, workspace, 2
    bind = $mod, 3, workspace, 3
    bind = $mod, 4, workspace, 4
    bind = $mod, 5, workspace, 5
    bind = $mod, 6, workspace, 6
    bind = $mod, 7, workspace, 7
    bind = $mod, 8, workspace, 8
    bind = $mod, 9, workspace, 9
    bind = $mod, 0, workspace, 10

    # Move container to workspace
    bind = $mod SHIFT, period, movetoworkspace, m+1
    bind = $mod SHIFT, comma, movetoworkspace, m-1
    bind = $mod SHIFT, 1, movetoworkspace, 1
    bind = $mod SHIFT, 2, movetoworkspace, 2
    bind = $mod SHIFT, 3, movetoworkspace, 3
    bind = $mod SHIFT, 4, movetoworkspace, 4
    bind = $mod SHIFT, 5, movetoworkspace, 5
    bind = $mod SHIFT, 6, movetoworkspace, 6
    bind = $mod SHIFT, 7, movetoworkspace, 7
    bind = $mod SHIFT, 8, movetoworkspace, 8
    bind = $mod SHIFT, 9, movetoworkspace, 9
    bind = $mod SHIFT, 0, movetoworkspace, 10

    # Reload configuration
    bind = $mod, Y, exec, hyprctl reload

    # Exit Hyprland / Session management
    bind = $mod, X, exec, swaynag -t warning -m 'Do you really want to exit Hyprland?' \
      -B 'Logout' 'hyprctl dispatch exit' \
      -B 'Suspend' 'systemctl suspend' \
      -B 'Poweroff' 'systemctl poweroff' \
      -B 'Reboot' 'systemctl reboot'
    bind = $mod SHIFT, X, exit

    # Lock screen
    bind = $mod, Pause, exec, swaylock

    # --- Submaps (Modes) ---

    # Resize mode
    submap = resize
    binde = , D, resizeactive, -10 0
    binde = , R, resizeactive, 0 10
    binde = , T, resizeactive, 0 -10
    binde = , N, resizeactive, 10 0
    binde = , Left, resizeactive, -10 0
    binde = , Down, resizeactive, 0 10
    binde = , Up, resizeactive, 0 -10
    binde = , Right, resizeactive, 10 0
    bind = , Return, submap, reset
    bind = , Escape, submap, reset
    submap = reset
    bind = $mod, C, submap, resize

    # Start Programme mode
    submap = Start Programme
    bind = , F, exec, firefox
    bind = , D, exec, nautilus
    bind = , M, exec, evolution
    bind = , V, exec, gvim
    bind = , P, exec, seahorse
    bind = , S, exec, steam
    bind = , H, exec, heroic
    bind = , W, exec, wire-desktop --password-store=gnome-libsecret
    bind = , Return, submap, reset
    bind = , Escape, submap, reset
    submap = reset
    bind = $mod, S, submap, Start Programme

    # Einstellungen mode
    submap = Einstellungen
    bind = , P, exec, hyprctl keyword monitor "*, 3840x2160@50, auto, 1"
    bind = , N, exec, hyprctl keyword monitor "*, 3840x2160@60, auto, 1"
    bind = , V, exec, hyprctl keyword general:allow_tearing false
    bind = , Shift+V, exec, hyprctl keyword general:allow_tearing true
    bind = , Return, submap, reset
    bind = , Escape, submap, reset
    submap = reset
    bind = $mod, W, submap, Einstellungen

    # Swaync notification center toggle
    bind = $mod, dead_circumflex, exec, swaync-client -t -sw

    # --- Startup Applications ---
    exec-once = ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
    exec-once = dbus-update-activation-environment --systemd --all
    exec-once = swaync
    exec-once = swayidle -w before-sleep 'swaylock -f'

    # --- Window Rules ---
    windowrulev2 = float, title:^(EA)$
    windowrulev2 = float, class:^(zoom)$
    windowrulev2 = float, title:^(Ubisoft Connect)$
  '';
}
