{
  config,
  pkgs,
  ...
}:

let
  hyprlandConfig = pkgs.writeText "hyprland.lua" ''
    -- Hyprland configuration file (Hyprland 0.57 Lua configuration)

    local mainMod = "SUPER"

    ---------------------------------
    ---- MONITORS ----
    ---------------------------------

    -- Hyprland identifies monitors by connector name (for example "DP-1").
    -- With "desc:" a monitor can be matched by its description as reported
    -- by `hyprctl monitors`. Adjust these entries if a monitor is not found.
    local monitors = {
      "desc:Hewlett Packard HP 27es 3CM9271PKW",
      "desc:Samsung Electric Company SAMSUNG 0x00000F00",
      "desc:Unknown Unknown Unknown",
      "desc:Red Hat, Inc. QEMU Monitor Unknown",
    }

    -- Apply a monitor rule to every known output (and to unknown outputs as
    -- fallback). Hyprland's empty output name is only a fallback, therefore
    -- the explicit outputs are needed for the settings submap.
    local function for_all_monitors(values)
      for _, output in ipairs(monitors) do
        values.output = output
        hl.monitor(values)
      end

      values.output = ""
      hl.monitor(values)
    end

    hl.monitor({
      output = "desc:Hewlett Packard HP 27es 3CM9271PKW",
      mode = "preferred",
      position = "auto",
      scale = "1",
    })

    hl.monitor({
      output = "desc:Samsung Electric Company SAMSUNG 0x00000F00",
      mode = "preferred",
      position = "auto",
      scale = "1",
      vrr = 1,
    })

    hl.monitor({
      output = "desc:Unknown Unknown Unknown",
      mode = "1600x1200@60",
      position = "auto",
      scale = "1",
    })

    hl.monitor({
      output = "desc:Red Hat, Inc. QEMU Monitor Unknown",
      mode = "1600x1200@60",
      position = "auto",
      scale = "1",
    })

    hl.monitor({
      output = "",
      mode = "preferred",
      position = "auto",
      scale = "1",
    })

    ---------------------------------
    ---- INPUT ----
    ---------------------------------

    local xkb = {
      layout = "${config.services.xserver.xkb.layout}",
      variant = "${config.services.xserver.xkb.variant}",
      options = "${config.services.xserver.xkb.options}",
    }

    hl.config({
      input = {
        kb_layout = xkb.layout,
        kb_variant = xkb.variant,
        kb_options = xkb.options,
        follow_mouse = 1,
      },
    })

    ---------------------------------
    ---- LOOK AND FEEL ----
    ---------------------------------

    hl.config({
      general = {
        gaps_in = 4,
        gaps_out = 4,
        border_size = 1,
        layout = "dwindle",
      },
      decoration = {
        rounding = 0,
        shadow = {
          enabled = false,
        },
      },
      animations = {
        enabled = false,
      },
    })

    ---------------------------------
    ---- KEYBINDINGS ----
    ---------------------------------

    -- Start a terminal
    hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("alacritty"))

    -- Kill the focused window
    hl.bind(mainMod .. " + V", hl.dsp.window.kill())

    -- Start wofi (program launcher)
    hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("wofi -S run"))
    hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("wofi -S drun"))

    -- Start wofi-emoji to enter Unicode emojis
    hl.bind(mainMod .. " + colon", hl.dsp.exec_cmd("wofi-emoji"))

    -- Search and open files in the home directory
    hl.bind(
      mainMod .. " + SHIFT + F",
      hl.dsp.exec_cmd(
        "fd -d 5 . ~ | wofi -i --dmenu | xargs -r -d '\\n' xdg-open"
      )
    )

    -- Change focus
    hl.bind(mainMod .. " + N", hl.dsp.focus({ direction = "left" }))
    hl.bind(mainMod .. " + T", hl.dsp.focus({ direction = "down" }))
    hl.bind(mainMod .. " + R", hl.dsp.focus({ direction = "up" }))
    hl.bind(mainMod .. " + D", hl.dsp.focus({ direction = "right" }))

    -- Move the focused window
    hl.bind(mainMod .. " + H", hl.dsp.window.move({ direction = "left" }))
    hl.bind(mainMod .. " + F", hl.dsp.window.move({ direction = "down" }))
    hl.bind(mainMod .. " + G", hl.dsp.window.move({ direction = "up" }))
    hl.bind(mainMod .. " + Q", hl.dsp.window.move({ direction = "right" }))

    -- Arrow keys for moving the focused window
    hl.bind(mainMod .. " + Left", hl.dsp.window.move({ direction = "left" }))
    hl.bind(mainMod .. " + Down", hl.dsp.window.move({ direction = "down" }))
    hl.bind(mainMod .. " + Up", hl.dsp.window.move({ direction = "up" }))
    hl.bind(mainMod .. " + Right", hl.dsp.window.move({ direction = "right" }))

    -- Enter fullscreen mode for the focused window
    hl.bind(mainMod .. " + L", hl.dsp.window.fullscreen())

    -- Sway's stacking container approximates pseudo-tiling in Hyprland
    hl.bind(mainMod .. " + U", hl.dsp.window.pseudo())
    -- Sway's tabbed container maps to a Hyprland group
    hl.bind(mainMod .. " + I", hl.dsp.group.toggle())
    -- Toggle the split direction of the dwindle layout
    hl.bind(mainMod .. " + A", hl.dsp.layout("togglesplit"))

    -- Toggle tiling / floating
    hl.bind(mainMod .. " + SHIFT + Space", hl.dsp.window.float())

    -- Focus the previously focused window (approximates focus mode_toggle)
    hl.bind(mainMod .. " + Space", hl.dsp.focus({ last = true }))

    -- Hyprland has no container tree; use the closest focus actions instead
    hl.bind(mainMod .. " + M", hl.dsp.focus({ last = true }))
    hl.bind(mainMod .. " + SHIFT + M", hl.dsp.window.cycle_next())

    -- Switch workspaces
    hl.bind(mainMod .. " + period", hl.dsp.focus({ workspace = "e+1" }))
    hl.bind(mainMod .. " + comma", hl.dsp.focus({ workspace = "e-1" }))

    for i = 1, 10 do
      local key = i % 10
      hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
      hl.bind(
        mainMod .. " + SHIFT + " .. key,
        hl.dsp.window.move({ workspace = i, follow = false })
      )
    end

    -- Move the focused window to the next/previous workspace
    hl.bind(
      mainMod .. " + SHIFT + period",
      hl.dsp.window.move({ workspace = "e+1", follow = false })
    )
    hl.bind(
      mainMod .. " + SHIFT + comma",
      hl.dsp.window.move({ workspace = "e-1", follow = false })
    )

    -- Reload the configuration file
    hl.bind(mainMod .. " + Y", hl.dsp.reload_config())

    -- Hyprland cannot restart in place; reload instead of restarting
    hl.bind(mainMod .. " + SHIFT + Y", hl.dsp.reload_config())

    -- Exit Hyprland
    hl.bind(
      mainMod .. " + X",
      hl.dsp.exec_cmd(
        "swaynag -t warning -m 'Do you really want to exit Hyprland?' "
          .. "-B 'Logout' 'hyprctl dispatch \"hl.dsp.exit()\"' "
          .. "-B 'Suspend' 'systemctl suspend' "
          .. "-B 'Poweroff' 'systemctl poweroff' "
          .. "-B 'Reboot' 'systemctl reboot'"
      )
    )
    hl.bind(mainMod .. " + SHIFT + X", hl.dsp.exit())

    -- Lock the screen
    hl.bind(mainMod .. " + Pause", hl.dsp.exec_cmd("swaylock"))

    -- Move and resize windows with the mouse, like sway's floating_modifier
    hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
    hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

    ---------------------------------
    ---- SUBMAPS (MODES) ----
    ---------------------------------

    -- Resize mode
    hl.define_submap("resize", function()
      hl.bind("D", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
      hl.bind("R", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })
      hl.bind("T", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
      hl.bind("N", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })

      hl.bind("Left", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
      hl.bind("Down", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })
      hl.bind("Up", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
      hl.bind("Right", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })

      hl.bind("Return", hl.dsp.submap("reset"))
      hl.bind("Escape", hl.dsp.submap("reset"))
    end)
    hl.bind(mainMod .. " + C", hl.dsp.submap("resize"))

    -- Start Programme mode
    hl.define_submap("Start Programme", function()
      hl.bind("F", hl.dsp.exec_cmd("firefox"))
      hl.bind("D", hl.dsp.exec_cmd("nautilus"))
      hl.bind("M", hl.dsp.exec_cmd("evolution"))
      hl.bind("V", hl.dsp.exec_cmd("gvim"))
      hl.bind("P", hl.dsp.exec_cmd("seahorse"))
      hl.bind("S", hl.dsp.exec_cmd("steam"))
      hl.bind("H", hl.dsp.exec_cmd("heroic"))
      hl.bind(
        "W",
        hl.dsp.exec_cmd("wire-desktop --password-store=gnome-libsecret")
      )

      hl.bind("Return", hl.dsp.submap("reset"))
      hl.bind("Escape", hl.dsp.submap("reset"))
    end)
    hl.bind(mainMod .. " + S", hl.dsp.submap("Start Programme"))

    -- Settings mode
    hl.define_submap("Einstellungen", function()
      -- Switch between PAL and NTSC
      hl.bind("P", function()
        for_all_monitors({ mode = "3840x2160@50", position = "auto", scale = "1" })
      end)
      hl.bind("N", function()
        for_all_monitors({ mode = "3840x2160@60", position = "auto", scale = "1" })
      end)

      -- Adaptive sync
      hl.bind("V", function()
        for_all_monitors({ vrr = 0 })
      end)
      hl.bind("SHIFT + V", function()
        for_all_monitors({ vrr = 1 })
      end)

      -- HDR
      hl.bind("H", function()
        for_all_monitors({ cm = "srgb" })
      end)
      hl.bind("SHIFT + H", function()
        for_all_monitors({ cm = "hdr" })
      end)

      -- Switch between NEO and Nodeadkeys
      hl.bind("E", hl.dsp.exec_cmd("hyprctl switchxkblayout all 1"))
      hl.bind("F", hl.dsp.exec_cmd("hyprctl switchxkblayout all 0"))

      hl.bind("Return", hl.dsp.submap("reset"))
      hl.bind("Escape", hl.dsp.submap("reset"))
    end)
    hl.bind(mainMod .. " + W", hl.dsp.submap("Einstellungen"))

    -- Toggle the bar
    hl.bind(mainMod .. " + J", hl.dsp.exec_cmd("killall -SIGUSR1 waybar"))

    ---------------------------------
    ---- AUTOSTART ----
    ---------------------------------

    hl.on("hyprland.start", function()
      hl.exec_cmd("${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1")
      hl.exec_cmd("dbus-update-activation-environment --systemd --all")
      hl.exec_cmd("swaync")
      hl.exec_cmd("swayidle -w before-sleep 'swaylock -f'")
      hl.exec_cmd("swaybg -c '#c9ecee'")
      hl.exec_cmd("waybar")
    end)

    ---------------------------------
    ---- WINDOW RULES ----
    ---------------------------------

    -- See "window_properties" of `hyprctl clients`
    hl.window_rule({ match = { title = "EA" }, float = true })
    hl.window_rule({ match = { class = "zoom" }, float = true })
    hl.window_rule({ match = { title = "Ubisoft Connect" }, float = true })
  '';
in
{
  programs.hyprland.enable = true;

  # Sway stays available in the display manager, but Hyprland is the default.
  services.displayManager.defaultSession = "hyprland";

  # Plugins and tools used by the Hyprland session. programs.sway's
  # extraPackages only puts these into sway's wrapper, not into PATH.
  environment.systemPackages = with pkgs; [
    alacritty
    conky
    fd
    polkit_gnome
    swaybg
    swayidle
    swaylock
    swaynotificationcenter
    waybar
    wofi
    wofi-emoji
  ];

  environment.etc."xdg/hypr/hyprland.lua".source = hyprlandConfig;

  # Make sure the system configuration wins over a stale
  # ~/.config/hypr/hyprland.lua, which Hyprland would otherwise prefer.
  environment.sessionVariables.HYPRLAND_CONFIG = "/etc/xdg/hypr/hyprland.lua";

  # Minimal bar replacing sway's i3bar; conky provides the status text.
  environment.etc."xdg/waybar/config.jsonc".text = builtins.toJSON {
    layer = "top";
    position = "top";
    height = 30;
    "modules-left" = [
      "hyprland/workspaces"
      "hyprland/window"
    ];
    "modules-right" = [ "custom/conky" ];
    "hyprland/workspaces" = {
      format = "{name}";
    };
    "hyprland/window" = {
      format = "{}";
      "max-length" = 60;
    };
    "custom/conky" = {
      exec = "conky --config=/etc/conky/conky-sway.conf | head -n1";
      interval = 5;
      format = "{}";
    };
  };

  environment.etc."xdg/waybar/style.css".text = ''
    * {
      border: none;
      border-radius: 0;
      font-family: "Source Code Pro", monospace;
      font-size: 11px;
      min-height: 0;
    }

    window#waybar {
      background: #c9ecee;
      color: #000000;
    }

    #workspaces button {
      padding: 0 6px;
      background: transparent;
      color: #000000;
    }

    #workspaces button.focused {
      background: #00000033;
    }

    #window,
    #custom-conky {
      padding: 0 10px;
    }
  '';
}
