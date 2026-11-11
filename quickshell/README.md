# Disputa panel

A small Hyprland panel inspired by Raphael’s *Disputa del Sacramento*: warm charcoal, ivory, gold, fresco red, and blue. The palette is an interpretation, not a color sample. No image assets are required; typography uses JetBrainsMono Nerd Font for text and symbol support.

Run from this directory with `quickshell -p .`. For Hyprland startup, retain your existing command, or use:

```ini
exec-once = quickshell -p /home/tomohiro/dotfiles/quickshell
```

## Reading the configuration

Start with `shell.qml`, which creates `Bar`. `Bar.qml` uses `Variants` to create a transparent `PanelWindow` for every screen and reserves 44 pixels above tiled windows. Each workspace, the audio visualizer, and the clock have their own rounded pill background with space above and below. The visualizer is centered on the screen and shrinks on narrow screens to avoid the side widgets.

`Workspaces` receives a monitor through a required property. Its repeater follows Hyprland’s workspace model, showing normal workspaces belonging to that monitor. Clicking activates a workspace. Gold marks active workspaces, red marks urgency, and blue marks hover. Named workspaces retain their names and follow Hyprland’s ID ordering; special workspaces are hidden.

`AudioService.qml` shares one CAVA process across screens. The visualizer displays 24 simultaneous frequency bands (50 Hz–16 kHz), with bass on the left and treble on the right, at 30 frames per second. Bars grow equally above and below the pill's centerline. CAVA captures the default output through PipeWire and sends raw spectrum frames to QML. Install `cava` with PipeWire input support and keep `cava.conf` beside the QML files. Edit that file to change frequency cutoffs, sensitivity, or frame rate; keep its bar count and raw output format in sync with `AudioService.qml`. The visualizer becomes flat during silence or mute and restarts capture when the default output changes. Volume and device controls still use Quickshell's native PipeWire service.

Click the visualizer to open the audio panel. Output and input sections list audio devices, each with a volume slider (0–100%), mute toggle, and default-device button. Volume changes made elsewhere stay synchronized. Device selection requests the preferred default through PipeWire; the session manager determines routing. Device lists update when devices are connected or removed.

The Players section lists MPRIS players with track details and Previous, Play/Pause, and Next controls. Unsupported actions are disabled. Music playback commands use MPRIS, while device and volume controls use PipeWire. Players must expose MPRIS for playback controls to appear. Click outside the popup, press Escape, or use its close button to dismiss it.

`Time.qml` and `Theme.qml` are singletons: one shared object of each type serves all panels. The clock updates once a minute. QML bindings reevaluate when properties they read change; there is no polling script to maintain.

## Customization

Click the clock to open the calendar below it. Use the arrows to browse months and Today to return to the current month. Today is highlighted in gold. Click outside the calendar or press Escape to close it. The popup manages its own input grab so its buttons receive hover and click events. Each monitor has its own calendar, which opens on the current month.

Edit `Theme.qml` to change colors, font, padding, or panel height. Edit the format string in `Time.qml` to change the date and time display. Qt’s `HH:mm` is 24-hour time; `hh:mm AP` uses AM/PM. Add future widgets as small components beside the three existing ones.

## Checking changes

Run `qmllint -I /usr/lib/qt6/qml *.qml`. Quickshell normally reloads when its configuration changes; inspect its terminal output for errors.

In a live Hyprland session, check workspace creation, switching and monitor moves; visualizer response to audio, silence, mute, and default-output changes; input/output sliders and defaults; device connection/removal; music playback controls; calendar navigation; and monitor attachment/removal. Also check empty device/player lists and external volume changes. Extremely narrow screens with many workspaces may still exceed the available width.

Workspace buttons also show one Nerd Font glyph per distinct icon among their open windows. Icons follow workspace membership and application IDs; repeated windows sharing an icon appear only once. `AppIcons.js` holds the editable app-ID/window-class matching rules. Unrecognized applications share a generic window glyph.
