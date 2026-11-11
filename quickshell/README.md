# Disputa panel

A small Hyprland panel inspired by Raphael’s *Disputa del Sacramento*: warm charcoal, ivory, gold, fresco red, and blue. The palette is an interpretation, not a color sample. No image assets are required; typography uses JetBrainsMono Nerd Font for text and symbol support.

Run from this directory with `quickshell -p .`. For Hyprland startup, retain your existing command, or use:

```ini
exec-once = quickshell -p /home/tomohiro/dotfiles/quickshell
```

## Reading the configuration

Start with `shell.qml`, which creates `Bar`. `Bar.qml` uses `Variants` to create a transparent `PanelWindow` for every screen and reserves 44 pixels above tiled windows. Each workspace, the window title, and the clock have their own rounded pill background with space above and below. The title pill fits its text, shrinks for long titles, and hides when there is no title.

`Workspaces` receives a monitor through a required property. Its repeater follows Hyprland’s workspace model, showing normal workspaces belonging to that monitor. Clicking activates a workspace. Gold marks active workspaces, red marks urgency, and blue marks hover. Named workspaces retain their names and follow Hyprland’s ID ordering; special workspaces are hidden.

`WindowTitle` receives the same monitor. A binding reads the active window’s title only on the focused monitor. Plain-text rendering keeps markup in application titles harmless; elision keeps long titles from displacing the clock.

`Time.qml` and `Theme.qml` are singletons: one shared object of each type serves all panels. The clock updates once a minute. QML bindings reevaluate when properties they read change; there is no polling script to maintain.

## Customization

Click the clock to open the calendar below it. Use the arrows to browse months and Today to return to the current month. Today is highlighted in gold. Click outside the calendar or press Escape to close it. The popup manages its own input grab so its buttons receive hover and click events. Each monitor has its own calendar, which opens on the current month.

Edit `Theme.qml` to change colors, font, padding, or panel height. Edit the format string in `Time.qml` to change the date and time display. Qt’s `HH:mm` is 24-hour time; `hh:mm AP` uses AM/PM. Add future widgets as small components beside the three existing ones.

## Checking changes

Run `qmllint -I /usr/lib/qt6/qml *.qml`. Quickshell normally reloads when its configuration changes; inspect its terminal output for errors.

In a live Hyprland session, check workspace creation, switching and monitor moves; long and changing window titles; an empty desktop; clock updates; and monitor attachment/removal. The middle title region shrinks before the side widgets. Extremely narrow screens with many workspaces may still exceed the available width.

Workspace buttons also show one Nerd Font glyph per distinct icon among their open windows. Icons follow workspace membership and application IDs; repeated windows sharing an icon appear only once. `AppIcons.js` holds the editable app-ID/window-class matching rules. Unrecognized applications share a generic window glyph.
