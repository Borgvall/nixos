{ config, lib, pkgs, ... }:

{
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      swaylock
      swaynotificationcenter
      wofi
      xfce.xfce4-terminal
      conky
      source-code-pro
    ];
  };
  environment.etc."sway/config".text = ''
    # sway config file (v4)

    set $mod Mod4

    input "type:keyboard" {
      xkb_layout "de,de"
      xkb_variant "neo,nodeadkeys"
      xkb_options grp:sclk_toggle
    }

    output * {
      background ~/Bilder/ElaundJohannes.png fit #c9ecee
      dpms on
    }

    output "Hewlett Packard HP 27es 3CM9271PKW   " {
      #max_render_time 2
    }

    output "Samsung Electric Company SAMSUNG 0x00000F00" {
      adaptive_sync on
      #max_render_time 2
      #scale 1.2
    }

    # Font for window titles. Will also be used by the bar unless a different font
    # is used in the bar {} block below. ISO 10646 = Unicode
    #font -misc-fixed-medium-r-normal--11-120-75-75-C-70-iso10646-1
    # The font above is very space-efficient, that is, it looks good, sharp and
    # clear in small sizes. However, if you need a lot of unicode glyphs or
    # right-to-left text rendering, you should instead use pango for rendering and
    # chose a FreeType font, such as:
    #font pango:DejaVu Sans Mono 11
    font pango:Source Code Pro Regular 11

    # default to stacking layout
    #workspace_layout stacking
    workspace_layout default

    # Use Mouse+$mod to drag floating windows to their wanted position
    floating_modifier $mod

    # start a terminal
    bindsym $mod+Return exec xfce4-terminal

    bindsym $mod+k exec xkill

    # kill focused window
    bindsym $mod+v kill

    # start wofi (a program launcher)
    bindsym $mod+e exec wofi -S run
    bindsym $mod+p exec wofi -S drun

    # change focus
    bindsym $mod+n focus left
    bindsym $mod+t focus down
    bindsym $mod+r focus up
    bindsym $mod+d focus right

    # move focused window
    bindsym $mod+h move left
    bindsym $mod+f move down
    bindsym $mod+g move up
    bindsym $mod+q move right

    # alternatively, you can use the cursor keys:
    bindsym $mod+Left move left
    bindsym $mod+Down move down
    bindsym $mod+Up move up
    bindsym $mod+Right move right

    # split in horizontal orientation
    bindsym $mod+z split horizontal

    # split in vertical orientation
    bindsym $mod+o split vertical

    # enter fullscreen mode for the focused container
    bindsym $mod+l fullscreen

    # change container layout (stacked, tabbed, toggle split)
    bindsym $mod+u layout stacking
    bindsym $mod+i layout tabbed
    bindsym $mod+a layout toggle split

    # toggle tiling / floating
    bindsym $mod+Shift+space floating toggle

    # change focus between tiling / floating windows
    bindsym $mod+space focus mode_toggle

    # focus the parent container
    bindsym $mod+m focus parent

    # focus the child container
    bindsym $mod+Shift+m focus child

    # switch to workspace
    bindsym $mod+period workspace next
    bindsym $mod+comma workspace prev
    bindsym $mod+1 workspace 1
    bindsym $mod+2 workspace 2
    bindsym $mod+3 workspace 3
    bindsym $mod+4 workspace 4
    bindsym $mod+5 workspace 5
    bindsym $mod+6 workspace 6
    bindsym $mod+7 workspace 7
    bindsym $mod+8 workspace 8
    bindsym $mod+9 workspace 9
    bindsym $mod+0 workspace 10

    # move focused container to workspace
    bindsym $mod+Shift+period move container to workspace next
    bindsym $mod+Shift+comma move container to workspace prev
    bindsym $mod+Shift+1 move container to workspace 1
    bindsym $mod+Shift+2 move container to workspace 2
    bindsym $mod+Shift+3 move container to workspace 3
    bindsym $mod+Shift+4 move container to workspace 4
    bindsym $mod+Shift+5 move container to workspace 5
    bindsym $mod+Shift+6 move container to workspace 6
    bindsym $mod+Shift+7 move container to workspace 7
    bindsym $mod+Shift+8 move container to workspace 8
    bindsym $mod+Shift+9 move container to workspace 9
    bindsym $mod+Shift+0 move container to workspace 10

    # render time settings
    bindsym $mod+Shift+s max_render_time 4
    bindsym $mod+Shift+n max_render_time 8
    bindsym $mod+Shift+r max_render_time off
    bindsym $mod+Shift+t max_render_time 16
    bindsym $mod+Shift+d max_render_time 24
    bindsym $mod+Shift+y max_render_time 31

    # reload the configuration file
    bindsym $mod+y reload
    # start sway inplace (preserves your layout/session, can be used to upgrade sway)
    bindsym $mod+colon restart
    # exit sway (logs you out of your X session)
    bindsym $mod+x exec "swaynag -t warning -m 'Do you really want to exit sway?' -B 'Logout' 'swaymsg exit' -B 'Suspend' '/home/johannes/bin/sway-suspend.sh' -B 'Poweroff' 'systemctl poweroff' -B 'Reboot' 'systemctl reboot'"
    bindsym $mod+Shift+x exit

    # lock the screen
    bindsym $mod+Pause exec swaylock
    #bindsym $mod+Scroll output * dpms toggle

    # resize window (you can also use the mouse for that)
    mode "resize" {
            # These bindings trigger as soon as you enter the resize mode

            # Pressing left will shrink the window’s width.
            # Pressing right will grow the window’s width.
            # Pressing up will shrink the window’s height.
            # Pressing down will grow the window’s height.
            bindsym d resize shrink width 10 px or 10 ppt
            bindsym r resize grow height 10 px or 10 ppt
            bindsym t resize shrink height 10 px or 10 ppt
            bindsym n resize grow width 10 px or 10 ppt

            # same bindings, but for the arrow keys
            bindsym Left resize shrink width 10 px or 10 ppt
            bindsym Down resize grow height 10 px or 10 ppt
            bindsym Up resize shrink height 10 px or 10 ppt
            bindsym Right resize grow width 10 px or 10 ppt

            # back to normal: Enter or Escape
            bindsym Return mode "default"
            bindsym Escape mode "default"
    }
    bindsym $mod+c mode "resize"

    mode "Start Programme" {
      bindsym c exec celluloid
      bindsym f exec firefox
      bindsym d exec nautilus
      bindsym m exec evolution
      bindsym v exec gvim
      bindsym e exec emacs
      bindsym p exec seahorse
      bindsym r exec remmina
      bindsym s exec steam
      # Win 11 VM
      bindsym w exec sdl-freerdp /size:1920x1080 +dynamic-resolution -wallpaper -grab-keyboard +mouse-motion -auto-reconnect /u:Joe\ Doe /p:foobar /v:192.168.122.221

      # back to normal: Enter or Escape
      bindsym Return mode "default"
      bindsym Escape mode "default"
    }
    bindsym $mod+s mode "Start Programme"

    # start an environment for setting configuration
    mode "Einstellungen" {
      # Switch between stereo and 5.1 surround mode of hdmi
      bindsym s exec pactl set-card-profile alsa_card.pci-0000_28_00.1 output:hdmi-stereo
      bindsym m exec pactl set-card-profile alsa_card.pci-0000_28_00.1 output:hdmi-surround
      
      # Wechsel zwischen PAL und NTSC
      bindsym p output * mode 1920x1080@50Hz
      bindsym n output * mode 1920x1080@60Hz

      bindsym v output * adaptive_sync on

      # Wechsel zwischen NEO und Nodeadkeys
      bindsym e input * xkb_switch_layout 1
      bindsym f input * xkb_switch_layout 0

      # back to normal: Enter or Escape
      bindsym Return mode "default"
      bindsym Escape mode "default"
    }
    bindsym $mod+w mode "Einstellungen"

    # toggle if the bar is hidden or shown
    bindsym $mod+j bar mode toggle

    # Start i3bar to display a workspace bar (plus the system information i3status
    # finds out, if available)
    bar {
      status_command conky
      #mode hide
      modifier $mod
      position top
    }

    #startup programs at the beginning
    exec evolution
    exec firefox
    exec /usr/libexec/polkit-gnome-authentication-agent-1
    exec dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
    #exec corectrl

    # Sway notification center
    exec swaync
    # Toggle control center
    bindsym $mod+dead_circumflex exec swaync-client -t -sw

    # Automatically assign applications to workspaces
    assign [class="Steam"] 9
    assign [instance="amazon games ui.exe"] 8
    for_window [instance="origin.exe"] 8

    # See "window_properties" of `swaymsg -t get_tree`
    for_window [instance="origin.exe"] floating enable
    for_window [instance="amazon games ui.exe"] floating enable
    for_window [app_id="zoom"] floating enable
    for_window [title="Ubisoft Connect"] floating enable
    #no_focus [app_id="firefox"]
  '';
}
