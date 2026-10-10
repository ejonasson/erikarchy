# Agent instructions for these dotfiles

This repository is `~/.config` on a live Arch Linux + Hyprland machine. Edits
take effect on the running desktop as soon as they're saved, so treat changes
as changes to the user's real session.

## Always update the README

**Every change you make here must be summarised in `README.md` in the same
commit.**

1. Add a bullet under `## Changelog` in a section headed with today's date
   (`### YYYY-MM-DD`, newest first). Create the section if it doesn't exist.
   Say what changed, why, and which files changed.
2. If the change affects anything described in the reference sections above
   the changelog, update those sections too: what's in the repo, the Hyprland
   module table, monitors, the status bar, keybindings, expected packages, and
   known issues. The README has to describe the current setup, not just its
   history.
3. When you fix or work around a known issue, remove it from
   `## Known issues / to do`. When you find a new one, add it.

If you only investigated something and changed no files (for example,
diagnosing a hardware problem), add a changelog line when the finding is
worth remembering, such as a missing package.

## Repository layout and git

- The work tree is `~/.config` itself. There are no symlinks and no install
  step.
- `.gitignore` is a **whitelist** (`/*`, then `!/<dir>/`). A new config
  directory is ignored until you add a `!/<name>/` line. Never un-ignore
  app state, caches, logs, cookies or credentials (`pulse/`, `dconf/`,
  `mozilla/`, `herdr/` logs and sessions, and so on).
- There must be no nested `.git` directories. The old `hypr/` and `nvim/`
  repos were moved to `~/.local/share/dotfiles-old-git/`.
- Commit identity is set in the repo config (`ejonasson <ejonasson@gmail.com>`).
- Commit only when the user asks. There is no remote yet, so don't push or
  create one unless asked.
- Before deleting a file, check whether it's tracked; mention it in the
  changelog if so.

## Things that behave unusually here

### Hyprland uses the Lua config (0.55+), not hyprlang

- Config is in `hypr/*.lua`; `hypr/hyprland.lua` `require`s each module.
  There is no `hyprland.conf`.
- API stubs: `/usr/share/hypr/stubs/hl.meta.lua`. Dispatcher docs:
  <https://wiki.hypr.land/Configuring/Basics/Dispatchers/>.
- Dispatchers on the command line take Lua expressions:
  `hyprctl dispatch 'hl.dsp.focus({ workspace = "3" })'`. Old syntax like
  `hyprctl dispatch workspace 3` doesn't work.
- A bind can call a Lua function. To dispatch from inside it, use
  `hl.dispatch(hl.dsp....)`. The Firefox `Ctrl+N` → `Alt+N` binds in
  `binds.lua` are an example.
- After editing, run `hyprctl reload` and then `hyprctl configerrors`. Empty
  output means no errors.
- `hypridle.conf`, `hyprlock.conf` and `hyprpaper.conf` are still in their
  own non-Lua formats.

### Quickshell bar (`quickshell/`)

- Quickshell hot-reloads on save. Check `qs log` for errors after every
  edit.
- Restart it through Hyprland so it's parented like at login:
  `pkill -x qs; hyprctl dispatch 'hl.dsp.exec_cmd("qs")'`.
  **Don't** use `pkill -f 'qs -p'` or similar: the pattern matches your own
  shell's command line and kills it.
- Shared singletons are in the root (`Theme.qml`, `Globals.qml`) and are
  imported with `import qs`. Modules in `modules/` are imported with
  `import qs.modules`.
- Don't name a QML type after a QtQuick built-in. A singleton called
  `State` silently resolved to QtQuick's `State` and every property read
  returned `undefined`. That's why the singleton is called `Globals`.
- Check the API against the installed version's type files in
  `/usr/lib/qt6/qml/Quickshell/**/*.qmltypes` rather than relying on memory.
  Quickshell's API changes between releases.
- `hypr/scripts/tablet-mode.sh` notifies the bar with
  `qs ipc call osk refresh`, which the `IpcHandler` in `Globals.qml` handles.
  Keep the two in sync.
- sysfs (backlight) doesn't send file-change notifications, so
  `Backlight.qml` polls once a second.

### The machine

- Two monitors: `eDP-1` (laptop, scale 1, at 2880x720) and the BenQ `DP-1`
  (scale 4/3, at 0x0). Screenshots with `grim -g "x,y WxH"` use logical
  coordinates. Use them to check visual changes.
- Convertible laptop: tablet-mode hinge events come in as
  `switch:on/off:Intel HID switches` binds.
- Theme is **Catppuccin Mocha** with peach `#fab387` → pink `#f38ba8` accents
  and the "JetBrainsMono Nerd Font" (Propo variant in the bar). Keep new UI
  consistent with that. The bar's colours are in `quickshell/Theme.qml`.

### Permissions and side effects

- `sudo` needs a password you don't have. Give the user package commands to
  run themselves (they can type `! <command>` in Claude Code).
- Don't move the cursor, click, switch workspaces or send keys to the user's
  windows to test something without asking. Say what you couldn't test.
- Keep backups of files you delete or heavily rewrite outside the repo
  (for example, a scratch directory) until the user has confirmed the
  change.
- Match the existing style: short comments that explain *why*, Lua modules
  by concern, one QML file per bar item.
