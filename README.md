# Dotfiles

Desktop configuration for an Arch Linux laptop (HP, Intel Lunar Lake, 1920x1200
touchscreen, convertible) running **Hyprland** with a **BenQ RD280U** external
monitor. Everything uses the **Catppuccin Mocha** palette with a peach → pink
(`#fab387` → `#f38ba8`) accent.

This repository *is* `~/.config`. Files live where the programs read them, with
no symlinks or install step. The `.gitignore` is a whitelist: everything is ignored
except the directories listed in it.

```sh
cd ~/.config
git status
```

## What's in here

| Path | What it is |
|---|---|
| `hypr/` | Hyprland (Lua config, split into modules), hypridle, hyprlock, hyprpaper, helper scripts, wallpaper generator |
| `quickshell/` | The status bar (QML, runs as `qs`) |
| `waybar/` | Previous status bar, kept for rollback. Not started anymore |
| `kitty/` | Terminal: Catppuccin theme, 90% opacity, copy on select, right-click paste |
| `mako/` | Notifications: Catppuccin, 5 s timeout, critical alerts stay until dismissed |
| `rofi/` | App launcher (`Super+R`), Catppuccin theme |
| `nvim/` | LazyVim starter + Catppuccin Mocha colourscheme |
| `gtk-3.0/`, `gtk-4.0/` | Dark theme preference, Adwaita cursor at 24 px |
| `Thunar/`, `xfce4/` | File manager settings, custom actions, accelerators |
| `herdr/config.toml` | herdr config only (logs and sessions are ignored) |
| `mimeapps.list` | Default application handlers |

## Hyprland layout (`hypr/`)

`hyprland.lua` loads one module per concern:

| File | Purpose |
|---|---|
| `monitors.lua` | Laptop panel and BenQ placement and scale; workspaces 1–4 pinned to the BenQ |
| `programs.lua` | Default terminal (kitty), file manager (thunar), launcher (rofi), browser (firefox) |
| `autostart.lua` | Programs started with Hyprland |
| `binds.lua` | Keybindings |
| `input.lua` | Keyboard, touchpad, touchscreen gestures |
| `looks.lua` | Gaps, borders, rounding, shadows, animations |
| `env.lua` | Cursor and Qt environment variables |
| `rules.lua`, `permissions.lua` | Window rules, permission rules |
| `hypridle.conf` | Dim at 2.5 min, lock at 5 min, screen off at 5.5 min, suspend at 15 min on battery / 30 min on AC |
| `hyprlock.conf` | Lock screen: Catppuccin, photo background, Caps Lock warning |
| `hyprpaper.conf` | Wallpaper |
| `scripts/tablet-mode.sh` | Shows/hides the on-screen keyboard (wvkbd) when the hinge flips; feeds the bar's keyboard button |
| `wallpaper-src/` | Script that generates the "horizon ring" SVG wallpaper (no longer the active wallpaper) |

The config is **Lua**, not the old hyprlang format. Dispatchers from the
command line use Lua syntax, e.g. `hyprctl dispatch 'hl.dsp.focus({ workspace = "3" })'`.

### Monitors

- **BenQ RD280U** (3840x2560, 3:2): left, scale 4/3 → 2880x1920 logical. When
  it's plugged in, it's the primary display: workspaces 1–4 move to it, it takes
  focus, and `ddcutil` sets its brightness to 100.
- **Laptop eDP-1** (1920x1200): right of the BenQ, bottom edges aligned, at
  scale 1.0 (1.25 and 1.5 were too large on a 16" panel).
- Scales must divide the resolution evenly. 1.4 isn't valid on the BenQ.

## Status bar (`quickshell/`)

A [Quickshell](https://quickshell.org) bar replaced Waybar. It is a floating,
rounded bar at the top of every monitor that mirrors the old Waybar layout:

- **Left:** workspaces 1–4 always, plus any other workspace on that monitor.
  The focused monitor's active workspace gets the peach → pink gradient, and the
  other monitor's active workspace a faint highlight. Click to switch, scroll to
  cycle.
- **Centre:** clock (`HH:MM`). Click toggles the date, hover shows a month calendar.
- **Right:** on-screen-keyboard button (tablet mode only), system tray, idle
  inhibitor, network, volume, backlight, battery.

| File | Purpose |
|---|---|
| `shell.qml` | Entry point; one `Bar` per screen |
| `Bar.qml` | Window, layout, idle inhibitor |
| `Theme.qml` | Colours, font, sizes (singleton) |
| `Globals.qml` | State shared across monitors: idle inhibit, keyboard button, `osk` IPC handler (singleton) |
| `Module.qml`, `BarText.qml`, `Tooltip.qml` | Shared building blocks |
| `modules/*.qml` | One file per bar item |

Interactions: volume click → pavucontrol, right-click → mute, scroll → ±5 %
(max 100 %). Backlight scroll → brightnessctl ±5 %. Network click →
nm-connection-editor. Tray: left click activates, middle click
secondary-activates, right click opens the menu.

Useful commands: `qs log` (errors), `qs ipc call osk refresh`.
Restart: `pkill -x qs; hyprctl dispatch 'hl.dsp.exec_cmd("qs")'`.

**Roll back to Waybar:** in `hypr/autostart.lua`, change `hl.exec_cmd("qs")`
to `hl.exec_cmd("waybar")`. Then add `pkill -RTMIN+8 -x waybar` back into
`refresh_bar()` in `hypr/scripts/tablet-mode.sh`.

## Keybindings

`Super` is the main modifier.

| Keys | Action |
|---|---|
| `Super+Q` | Terminal (kitty) |
| `Super+C` | Close window |
| `Super+M` | Exit Hyprland (hyprshutdown if installed) |
| `Super+E` | File manager (Thunar) |
| `Super+B` | Browser (Firefox) |
| `Super+R` | App launcher (rofi) |
| `Super+V` | Toggle floating |
| `Super+P` / `Super+J` | Pseudo-tile / toggle split (dwindle) |
| `Super+F` / `Super+Shift+F` | Maximise / true fullscreen |
| `Super+Arrows` | Move focus |
| `Super+1..0` / `Super+Shift+1..0` | Switch to / move window to workspace |
| `Super+S` / `Super+Shift+S` | Toggle / move to the scratchpad workspace |
| `Super+Scroll` | Cycle workspaces |
| `Super+LMB` / `Super+RMB` drag | Move / resize window |
| `Super+Shift+V` | Clipboard history (cliphist + rofi) |
| `Print` / `Shift+Print` | Screenshot region / whole screen to `~/Pictures/Screenshots` |
| `Ctrl+1..8`, `Ctrl+9` (in Firefox) | Go to tab 1–8 / last tab. Other apps receive the normal Ctrl+N |
| Media, volume, brightness keys | Work on the lock screen too |
| Hinge flip (Intel HID switch) | Show / hide the on-screen keyboard |

## Packages this setup expects

`hyprland`, `hypridle`, `hyprlock`, `hyprpaper`, `hyprpolkitagent`,
`quickshell`, `kitty`, `rofi`, `mako`, `thunar`, `firefox`,
`network-manager-applet` (`nm-applet`, `nm-connection-editor`), `pavucontrol`,
`wireplumber`, `brightnessctl`, `upower`, `cliphist`, `wl-clipboard`, `grim`,
`slurp`, `ddcutil` (with the `i2c-dev` module), `wvkbd`, `neovim`,
`ttf-jetbrains-mono-nerd`, `sof-firmware` (laptop audio), `linux-firmware-cirrus`
(speaker amplifiers).

## Known issues / to do

- **Quickshell vs Qt version:** the Arch `quickshell 0.3.1` package was built
  against Qt 6.11.2, but the system has Qt 6.12.0. Quickshell warns that this
  may cause crashes. Update when Arch ships a rebuilt package, or build
  `quickshell-git` from the AUR if it crashes.
- **Laptop audio:** `sof-firmware` was missing, so the only audio output was
  "Dummy Output". Fix: `sudo pacman -S sof-firmware`, then reboot.
- **Bar features not yet tested by hand:** tooltips and the calendar, tray
  right-click menus, clicking and scrolling the modules, the keyboard button
  in tablet mode.
- The `hyprsunset` package is still installed but unused
  (`sudo pacman -Rns hyprsunset`).
- No remote yet. Pushing to GitHub needs a repository to be created first.

## Changelog

Newest first. Every change to this repo gets an entry here (see `AGENTS.md`).

### 2026-10-10

- **Dotfiles repo created.** `~/.config` is now a git repository with a
  whitelist `.gitignore`. The previous `hypr/` repo's history was imported
  under the `hypr/` prefix. The old `.git` folders from `hypr/` and `nvim/`
  (the latter an unmodified LazyVim starter clone) were moved to
  `~/.local/share/dotfiles-old-git/`. Added this README, `AGENTS.md` and
  `CLAUDE.md`.
- **Firefox tab shortcuts.** `Ctrl+1`–`Ctrl+8` go to that tab and `Ctrl+9` to
  the last tab. Firefox on Linux only supports `Alt+N`, so a Hyprland bind
  sends `Alt+N` when Firefox is focused and passes `Ctrl+N` through everywhere
  else (`hypr/binds.lua`).
- **Removed hyprsunset (night light).** It tinted the screen to 4500 K from
  20:00 to 07:00. Removed from autostart, along with the `Super+N` toggle,
  `hyprsunset.conf` and `scripts/nightlight-toggle.sh`.

### 2026-10-09

- **Waybar replaced with a Quickshell bar** (`quickshell/`, see above). Same
  layout, colours and floating style as the Waybar config, with these changes:
  - It reads system state directly (Hyprland IPC, PipeWire, UPower,
    NetworkManager, StatusNotifier tray) instead of polling scripts.
  - Each monitor's workspace list matches what's actually on that monitor.
  - The keyboard button updates over IPC instead of a 2-second poll.
- `hypr/autostart.lua` starts `qs` instead of `waybar`.
- `hypr/scripts/tablet-mode.sh` refreshes the bar with
  `qs ipc call osk refresh` instead of signalling Waybar.
- Diagnosed the "Dummy Output" volume tooltip: laptop audio needs
  `sof-firmware` (see Known issues).

### Before 2026-10-09 (summarised from the old `hypr/` repo and uncommitted work)

- **Catppuccin Mocha everywhere:** Hyprland borders (peach → pink gradient,
  `#45475a` inactive), hyprlock, waybar, mako, rofi, kitty, nvim, and the
  wallpaper generator. Gaps reduced to 2/8, rounding to 4.
- **Wallpaper:** generated "horizon ring" SVG, later replaced by a photo
  (Martin Martz on Unsplash) for both hyprpaper and hyprlock.
- **hyprlock:** Catppuccin input field and a Caps Lock warning.
- **hypridle:** dim → lock → screen off → suspend, with a shorter suspend
  timeout on battery. Locks before sleep, and the screen comes back on after
  resume.
- **Monitors:** BenQ RD280U at scale 4/3 left of the laptop, laptop at 1.0,
  workspaces 1–4 pinned to and moved onto the BenQ on hotplug, DDC/CI
  brightness set to 100.
- **Input:** touchpad natural scroll, three-finger swipe between workspaces,
  touchscreen edge swipe between workspaces.
- **Tablet mode:** on-screen keyboard (wvkbd, Catppuccin colours) shown when
  the hinge flips, with a toggle button in the bar.
- **Binds:** browser, maximise/fullscreen, clipboard history, screenshots,
  media keys, persistent workspaces 1–4.
- **Desktop basics:** dark GTK theme, Adwaita cursor, Qt on Wayland,
  hyprpolkitagent, nm-applet, cliphist, the default wallpaper and logo turned off.
- Config split from the generated single file into Lua modules.
