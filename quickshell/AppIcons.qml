pragma Singleton
import Quickshell

Singleton {
    // Match application IDs (Wayland) or window classes (XWayland).
    // Add another rule here when you want a distinctive icon for a new app.
    function forApp(appId: string): string {
        const app = appId.toLowerCase();
        if (/firefox|librewolf|floorp|zen/.test(app)) return "\uf269";
        if (/chrom|brave|vivaldi|edge/.test(app)) return "\uf268";
        if (/kitty|alacritty|foot|wezterm|ghostty|konsole|terminal/.test(app)) return "\uf120";
        if (/code|codium/.test(app)) return "\ue70c";
        if (/neovim|nvim|vim/.test(app)) return "\ue62b";
        if (/thunar|nautilus|dolphin|nemo|pcmanfm/.test(app)) return "\uf07b";
        if (/discord|vesktop/.test(app)) return "\uf1ff";
        if (/spotify/.test(app)) return "\uf1bc";
        if (/vlc|mpv/.test(app)) return "\uf144";
        if (/gimp|krita|inkscape/.test(app)) return "\uf1fc";
        if (/evince|okular|zathura/.test(app)) return "\uf1c1";
        if (/steam/.test(app)) return "\uf1b6";
        return "\uf2d0"; // Generic window for unrecognized applications.
    }
}
