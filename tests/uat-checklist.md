# User Acceptance Test Checklist

Run the interactive VM: `nix run .#user-test-vm`

Login: user `michael`, password `testpassword`

## Desktop Environment

- [ ] Niri compositor loads, desktop is visible
- [ ] Waybar visible at top: workspaces, clock, battery, cpu/memory
- [ ] Tokyo Night dark theme throughout (dark backgrounds, blue/purple accents)
- [ ] Cursor is Bibata-Modern-Classic

## Terminal

- [ ] Open wezterm: `Mod+Return`
- [ ] Fish shell active with starship prompt, no greeting message
- [ ] Vi mode works: press `Escape`, use `h/j/k/l` movement
- [ ] `cat` runs `bat` (alias): `cat /etc/hostname`
- [ ] Ctrl+A leader key: `Ctrl+A` then `\` splits horizontal, `Ctrl+A` then `-` splits vertical
- [ ] Ctrl+H/J/K/L navigates between panes
- [ ] Open ghostty (from another terminal): verify same font (JetBrainsMono) and Tokyo Night theme

## Desktop Applications

- [ ] Rofi launcher: `Mod+Space` — Tokyo Night themed, search works
- [ ] Notifications: run `notify-send "Test notification"` — appears top-right, disappears after ~3s
- [ ] Screen lock: `Super+X` — hyprlock shows with password input, fingerprint prompt visible
- [ ] File manager: run `dolphin` — opens with correct MIME associations

## Window Management

- [ ] `Mod+H/J/K/L` — focus navigation between windows
- [ ] `Mod+F` — maximize/unfullscreen toggle
- [ ] `Mod+Shift+H/L` — move columns left/right
- [ ] `Mod+W` — toggle tabbed column mode
- [ ] `Mod+1-9` — switch workspaces
- [ ] `Mod+Shift+1-9` — move window to workspace

## Firefox

- [ ] Open firefox: `Mod+Shift+Return`
- [ ] Vertical tabs visible on left sidebar
- [ ] Navigate to `about:preferences#privacy` — "Strict" tracking protection selected
- [ ] Navigate to `about:config`, search `network.trr.mode` — value is `3` (DoH only)
- [ ] uBlock Origin icon visible in toolbar

## Settings Verification

- [ ] GTK apps use Tokyonight-Dark theme (check in dolphin or settings)
- [ ] Font is JetBrainsMono Nerd Font in terminal and waybar
- [ ] Brightness keys work: `Mod+BrightnessUp/Down`
- [ ] Volume keys work: `Mod+AudioRaiseVolume/LowerVolume`
