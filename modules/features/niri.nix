{ self, inputs, ... }: {

  flake.nixosModules.niri = { pkgs, ... }: {
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.alexNiri;
    };
  };

  perSystem =
    {
      pkgs,
      lib,
      self',
      ...
    }:
    {
      packages.alexNiri = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;
        settings = {
          spawn-at-startup = [
            (lib.getExe self'.packages.alexNoctalia)
          ];
          layout.gaps = 5;
          input = {
            keyboard = {
              xkb.layout = "us";
            };

            touchpad =
              let
                # A node with nothing after it: `close-window;` → close-window = flag;
                flag = _: { };
              in
              {
                tap = flag;
                dwt = flag;
                natural-scroll = flag;
              };
          };

          binds =
            let
              # A node with nothing after it: `close-window;` → close-window = flag;
              flag = _: { };
              # Properties on the bind node itself:
              #   Mod+Q repeat=false { close-window; }
              #   → "Mod+Q" = withProps { repeat = false; } { close-window = flag; };
              withProps = props: content: _: { inherit props content; };
            in
            {
              # Keys are modifiers joined by +, then an XKB key name (find names with `wev`).
              # "Mod" is Super on a TTY and Alt when running as a winit window.
              # Most actions can also be run with `niri msg action do-something`.

              # Mod-Shift-/ (usually Mod-?) shows a list of important hotkeys.
              "Mod+Shift+Slash".show-hotkey-overlay = flag;

              # Programs: terminal, app launcher, screen locker.
              "Mod+Return".spawn-sh = lib.getExe pkgs.kitty;
              "Mod+T" = withProps { hotkey-overlay-title = "Open a Terminal: kitty"; } { spawn = "kitty"; };
              "Mod+D" = withProps { hotkey-overlay-title = "Run an Application: noctalia"; } {
                spawn = [
                  (lib.getExe self'.packages.alexNoctalia)
                  "msg"
                  "panel-toggle"
                  "launcher"
                ];
              };
              "Super+Alt+L" = withProps { hotkey-overlay-title = "Lock the Screen: swaylock"; } {
                spawn = "swaylock";
              };

              # spawn-sh passes one string verbatim to `sh -c` (pipes, multiple commands, etc.).
              # Toggle the screen reader (orca).
              "Super+Alt+S" =
                withProps
                  {
                    allow-when-locked = true;
                    hotkey-overlay-title = null;
                  }
                  {
                    spawn-sh = "pkill orca || exec orca";
                  };

              # Volume keys for PipeWire & WirePlumber; allow-when-locked makes them work on the lock screen.
              # "-l 1.0" limits the volume to 100%.
              XF86AudioRaiseVolume = withProps { allow-when-locked = true; } {
                spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0";
              };
              XF86AudioLowerVolume = withProps { allow-when-locked = true; } {
                spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
              };
              XF86AudioMute = withProps { allow-when-locked = true; } {
                spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
              };
              XF86AudioMicMute = withProps { allow-when-locked = true; } {
                spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
              };

              # Media keys via playerctl (any MPRIS-enabled player).
              XF86AudioPlay = withProps { allow-when-locked = true; } { spawn-sh = "playerctl play-pause"; };
              XF86AudioPause = withProps { allow-when-locked = true; } { spawn-sh = "playerctl play-pause"; };
              XF86AudioStop = withProps { allow-when-locked = true; } { spawn-sh = "playerctl stop"; };
              XF86AudioPrev = withProps { allow-when-locked = true; } { spawn-sh = "playerctl previous"; };
              XF86AudioNext = withProps { allow-when-locked = true; } { spawn-sh = "playerctl next"; };

              # Brightness keys. A list passes each element as a separate argument (no shell).
              XF86MonBrightnessUp = withProps { allow-when-locked = true; } {
                spawn = [
                  "brightnessctl"
                  "--class=backlight"
                  "set"
                  "+10%"
                ];
              };
              XF86MonBrightnessDown = withProps { allow-when-locked = true; } {
                spawn = [
                  "brightnessctl"
                  "--class=backlight"
                  "set"
                  "10%-"
                ];
              };

              # Some laptops have a key for toggling the touchpad.
              # XF86TouchpadToggle = withProps { repeat = false; } { toggle-touchpad = flag; };

              # Open/close the Overview. Release bind: press and release Mod by itself.
              # Mod.release.toggle-overview = flag;

              # Press and release actions on one bind (e.g. push-to-talk).
              # "Alt+Shift" = {
              #   press.spawn = [ "notify-send" "Enable push-to-talk!" ];
              #   release.spawn = [ "notify-send" "Disable push-to-talk!" ];
              # };

              "Mod+Q" = withProps { repeat = false; } { close-window = flag; };
              "Alt+F4" = withProps { repeat = false; } { close-window = flag; };

              "Mod+Left".focus-column-left = flag;
              "Mod+Down".focus-window-down = flag;
              "Mod+Up".focus-window-up = flag;
              "Mod+Right".focus-column-right = flag;
              "Mod+H".focus-column-left = flag;
              "Mod+J".focus-window-down = flag;
              "Mod+K".focus-window-up = flag;
              "Mod+L".focus-column-right = flag;

              "Mod+Ctrl+Left".move-column-left = flag;
              "Mod+Ctrl+Down".move-window-down = flag;
              "Mod+Ctrl+Up".move-window-up = flag;
              "Mod+Ctrl+Right".move-column-right = flag;
              "Mod+Ctrl+H".move-column-left = flag;
              "Mod+Ctrl+J".move-window-down = flag;
              "Mod+Ctrl+K".move-window-up = flag;
              "Mod+Ctrl+L".move-column-right = flag;

              # Alternatives that move across workspaces at the first/last window in a column.
              # "Mod+J".focus-window-or-workspace-down = flag;
              # "Mod+K".focus-window-or-workspace-up = flag;
              # "Mod+Ctrl+J".move-window-down-or-to-workspace-down = flag;
              # "Mod+Ctrl+K".move-window-up-or-to-workspace-up = flag;

              "Mod+Home".focus-column-first = flag;
              "Mod+End".focus-column-last = flag;
              "Mod+Ctrl+Home".move-column-to-first = flag;
              "Mod+Ctrl+End".move-column-to-last = flag;

              "Mod+Shift+Left".focus-monitor-left = flag;
              "Mod+Shift+Down".focus-monitor-down = flag;
              "Mod+Shift+Up".focus-monitor-up = flag;
              "Mod+Shift+Right".focus-monitor-right = flag;
              "Mod+Shift+H".focus-monitor-left = flag;
              "Mod+Shift+J".focus-monitor-down = flag;
              "Mod+Shift+K".focus-monitor-up = flag;
              "Mod+Shift+L".focus-monitor-right = flag;

              "Mod+Shift+Ctrl+Left".move-column-to-monitor-left = flag;
              "Mod+Shift+Ctrl+Down".move-column-to-monitor-down = flag;
              "Mod+Shift+Ctrl+Up".move-column-to-monitor-up = flag;
              "Mod+Shift+Ctrl+Right".move-column-to-monitor-right = flag;
              "Mod+Shift+Ctrl+H".move-column-to-monitor-left = flag;
              "Mod+Shift+Ctrl+J".move-column-to-monitor-down = flag;
              "Mod+Shift+Ctrl+K".move-column-to-monitor-up = flag;
              "Mod+Shift+Ctrl+L".move-column-to-monitor-right = flag;

              # Or move just a single window / a whole workspace:
              # "Mod+Shift+Ctrl+Left".move-window-to-monitor-left = flag;
              # "Mod+Shift+Ctrl+Left".move-workspace-to-monitor-left = flag;

              "Mod+Page_Down".focus-workspace-down = flag;
              "Mod+Page_Up".focus-workspace-up = flag;
              "Mod+U".focus-workspace-down = flag;
              "Mod+I".focus-workspace-up = flag;
              "Mod+Ctrl+Page_Down".move-column-to-workspace-down = flag;
              "Mod+Ctrl+Page_Up".move-column-to-workspace-up = flag;
              "Mod+Ctrl+U".move-column-to-workspace-down = flag;
              "Mod+Ctrl+I".move-column-to-workspace-up = flag;

              # Or move just a single window:
              # "Mod+Ctrl+Page_Down".move-window-to-workspace-down = flag;

              "Mod+Shift+Page_Down".move-workspace-down = flag;
              "Mod+Shift+Page_Up".move-workspace-up = flag;
              "Mod+Shift+U".move-workspace-down = flag;
              "Mod+Shift+I".move-workspace-up = flag;

              # Mouse wheel ticks (follow natural-scroll); cooldown-ms rate-limits the bind.
              "Mod+WheelScrollDown" = withProps { cooldown-ms = 150; } { focus-workspace-down = flag; };
              "Mod+WheelScrollUp" = withProps { cooldown-ms = 150; } { focus-workspace-up = flag; };
              "Mod+Ctrl+WheelScrollDown" = withProps { cooldown-ms = 150; } {
                move-column-to-workspace-down = flag;
              };
              "Mod+Ctrl+WheelScrollUp" = withProps { cooldown-ms = 150; } { move-column-to-workspace-up = flag; };

              "Mod+WheelScrollRight".focus-column-right = flag;
              "Mod+WheelScrollLeft".focus-column-left = flag;
              "Mod+Ctrl+WheelScrollRight".move-column-right = flag;
              "Mod+Ctrl+WheelScrollLeft".move-column-left = flag;

              # Shift+scroll scrolls horizontally, like in most applications.
              "Mod+Shift+WheelScrollDown".focus-column-right = flag;
              "Mod+Shift+WheelScrollUp".focus-column-left = flag;
              "Mod+Ctrl+Shift+WheelScrollDown".move-column-right = flag;
              "Mod+Ctrl+Shift+WheelScrollUp".move-column-left = flag;

              # Touchpad scroll "ticks" (inverted because of natural-scroll).
              # "Mod+TouchpadScrollDown".spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.02+";
              # "Mod+TouchpadScrollUp".spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.02-";

              # Workspaces by index ("best effort": an index past the last workspace
              # refers to the bottommost, empty one).
              "Mod+1".focus-workspace = 1;
              "Mod+2".focus-workspace = 2;
              "Mod+3".focus-workspace = 3;
              "Mod+4".focus-workspace = 4;
              "Mod+5".focus-workspace = 5;
              "Mod+6".focus-workspace = 6;
              "Mod+7".focus-workspace = 7;
              "Mod+8".focus-workspace = 8;
              "Mod+9".focus-workspace = 9;
              "Mod+Ctrl+1".move-column-to-workspace = 1;
              "Mod+Ctrl+2".move-column-to-workspace = 2;
              "Mod+Ctrl+3".move-column-to-workspace = 3;
              "Mod+Ctrl+4".move-column-to-workspace = 4;
              "Mod+Ctrl+5".move-column-to-workspace = 5;
              "Mod+Ctrl+6".move-column-to-workspace = 6;
              "Mod+Ctrl+7".move-column-to-workspace = 7;
              "Mod+Ctrl+8".move-column-to-workspace = 8;
              "Mod+Ctrl+9".move-column-to-workspace = 9;

              # Or move just a single window:
              # "Mod+Ctrl+1".move-window-to-workspace = 1;

              # Switch between the current and the previous workspace.
              # "Mod+Tab".focus-workspace-previous = flag;

              # Move the focused window in and out of a column.
              "Mod+BracketLeft".consume-or-expel-window-left = flag;
              "Mod+BracketRight".consume-or-expel-window-right = flag;

              # Consume one window from the right into the bottom of the focused column.
              "Mod+Comma".consume-window-into-column = flag;
              # Expel the bottom window from the focused column to the right.
              "Mod+Period".expel-window-from-column = flag;

              # Cycle through preset-column-widths (and in reverse).
              "Mod+R".switch-preset-column-width = flag;
              "Mod+Shift+R".switch-preset-column-width-back = flag;

              "Mod+Ctrl+Shift+R".switch-preset-window-height = flag;
              "Mod+Ctrl+R".reset-window-height = flag;

              "Mod+F".maximize-column = flag;
              "Mod+Shift+F".fullscreen-window = flag;

              # Expand the window to the screen edges, without gaps and borders.
              "Mod+M".maximize-window-to-edges = flag;

              # Make the column fill the space not taken by other fully visible columns.
              "Mod+Ctrl+F".expand-column-to-available-width = flag;

              "Mod+C".center-column = flag;

              # Center all fully visible columns on screen.
              "Mod+Ctrl+C".center-visible-columns = flag;

              # Finer width adjustments: "1000", "-5"/"+5" (logical px), "25%", "-10%"/"+10%".
              "Mod+Minus".set-column-width = "-10%";
              "Mod+Equal".set-column-width = "+10%";

              # Finer height adjustments when in a column with other windows.
              "Mod+Shift+Minus".set-window-height = "-10%";
              "Mod+Shift+Equal".set-window-height = "+10%";

              # Move the focused window between the floating and the tiling layout.
              "Mod+V".toggle-window-floating = flag;
              "Mod+Shift+V".switch-focus-between-floating-and-tiling = flag;

              # Show the windows in this column as vertical tabs.
              "Mod+W".toggle-column-tabbed-display = flag;

              # Layout switching. Don't combine with a matching xkb layout-switch option.
              # "Mod+Space".switch-layout = "next";
              # "Mod+Shift+Space".switch-layout = "prev";

              Print.screenshot = flag;
              "Ctrl+Print".screenshot-screen = flag;
              "Alt+Print".screenshot-window = flag;

              # Escape hatch so a buggy app can't hold your keyboard shortcuts hostage.
              # allow-inhibiting=false makes niri always process this bind.
              "Mod+Escape" = withProps { allow-inhibiting = false; } {
                toggle-keyboard-shortcuts-inhibit = flag;
              };

              # The quit action shows a confirmation dialog.
              "Mod+Shift+E".quit = flag;
              "Ctrl+Alt+Delete".quit = flag;

              # Power off the monitors; any input turns them back on.
              "Mod+Shift+P".power-off-monitors = flag;
              "Mod+Shift+S".spawn = [
                "systemctl"
                "suspend"
              ];
            };

          extraConfig = ''
            include optional=true "/home/alexm/.config/niri/noctalia.kdl"
          '';
        };

      };
    };
}
