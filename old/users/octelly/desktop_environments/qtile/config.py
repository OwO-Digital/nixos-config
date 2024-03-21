# ┏━┃ ━┏┛┛┃  ┏━┛  ┏━┛┏━┃┏━ ┏━┛┛┏━┛
# ┃ ┃  ┃ ┃┃  ┏━┛  ┃  ┃ ┃┃ ┃┏━┛┃┃ ┃
# ━━━┛ ┛ ┛━━┛━━┛  ━━┛━━┛┛ ┛┛  ┛━━┛

# IMPORTS {{{
from typing import List  # noqa: F401

from libqtile import bar, layout, widget, qtile, hook
from libqtile.config import Click, Drag, Group, Key, KeyChord, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

import existence_reminder

# from screeninfo import get_monitors  # how many monitors?
import os  # autostart path
import subprocess  # and exec

# }}}

# GLOBALS {{{
mod = "mod4"
terminal = guess_terminal("kitty")
# terminal = 'kitty'

rofi_action = lazy.spawn(
    "rofi -no-default-config -config ~/.config/awesome/rofi/config.rasi -switchers combi,drun,calc -show combi"
)
# }}}

# KEYBINDS (KEYBOARD) {{{

# note:
# A lot of the comments in this section
# reference my old AwesomeWM keybinds.
keys = [
    # Keybinds cheatsheet
    # (not implemented)
    # Switch between groups
    Key([mod], "Left", lazy.screen.prev_group()),
    Key([mod], "Right", lazy.screen.next_group()),
    # Switch between windows
    Key(["mod1"], "Tab", lazy.group.next_window()),
    Key(["mod1", "shift"], "Tab", lazy.group.prev_window()),
    # Focus urgent client
    # (never used)
    # Switch between screens
    # (not implemented)
    # Program shortcuts
    # FIXME: add the rest
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Key([mod], "f", lazy.spawn('nautilus -w'), desc="Launch file manager"),
    Key([mod], "f", lazy.spawn("dolphin --new-window"), desc="Launch file manager"),
    Key([mod], "r", rofi_action, desc="Spawn Rofi"),
    Key([], "XF86Search", rofi_action, desc="Spawn Rofi"),
    Key([mod], "period", lazy.spawn("rofimoji"), desc="Open emoji picker"),
    Key(
        ["control", "shift"],
        "Print",
        lazy.spawn("i3-maim-clpimg -s"),
        desc="Selection screenshot",
    ),
    Key(
        ["control"],
        "Print",
        lazy.spawn("i3-maim-clpimg -f"),
        desc="Fullscreen screenshot",
    ),
    Key(
        [mod],
        "l",
        lazy.spawn(os.path.expanduser("~") + "/.config/qtile/lock.zsh"),
        desc="Lock session",
    ),
    # HW control
    Key(
        [],
        "XF86MonBrightnessUp",
        lazy.spawn(
            'busctl call org.clightd.clightd /org/clightd/clightd/Backlight org.clightd.clightd.Backlight RaiseAll "d(bdu)s" 0.025 0 0 0 ""'
        ),
        desc="Brightness up",
    ),
    Key(
        [],
        "XF86MonBrightnessDown",
        lazy.spawn(
            'busctl call org.clightd.clightd /org/clightd/clightd/Backlight org.clightd.clightd.Backlight LowerAll "d(bdu)s" 0.025 0 0 0 ""'
        ),
        desc="Brightness down",
    ),
    Key([], "XF86AudioMute", lazy.spawn("pamixer -t"), desc="Brightness down"),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("pamixer -i 5"), desc="Brightness down"),
    Key([], "XF86AudioLowerVolume", lazy.spawn("pamixer -d 5"), desc="Brightness down"),
    Key(
        [],
        "XF86AudioMicMute",
        lazy.spawn("pamixer --default-source -t"),
        desc="Brightness down",
    ),
    # QTile control
    Key([mod, "control"], "r", lazy.restart(), desc="Restart Qtile"),
    Key(
        ["mod1", "control"],
        "r",
        lazy.spawn(os.path.expanduser("~") + "/.config/qtile/restart_picom.zsh"),
        desc="Restart Picom",
    ),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    # Window width change
    KeyChord(
        [mod],
        "grave",
        [
            # SHIFT
            Key([], "Down", lazy.layout.down(), desc="Shift down"),
            Key([], "Up", lazy.layout.up(), desc="Shift up"),
            Key([], "Left", lazy.layout.left(), desc="Shift left"),
            Key([], "Right", lazy.layout.right(), desc="Shift right"),
            # SHUFFLE
            Key(["shift"], "Down", lazy.layout.shuffle_down(), desc="Shuffle down"),
            Key(["shift"], "Up", lazy.layout.shuffle_up(), desc="Shuffle up"),
            Key(["shift"], "Left", lazy.layout.shuffle_left(), desc="Shuffle left"),
            Key(["shift"], "Right", lazy.layout.shuffle_right(), desc="Shuffle right"),
            # FLIP
            Key(["mod1"], "Down", lazy.layout.flip_down(), desc="Flip down"),
            Key(["mod1"], "Up", lazy.layout.flip_up(), desc="Flip up"),
            Key(["mod1"], "Left", lazy.layout.flip_left(), desc="Flip left"),
            Key(["mod1"], "Right", lazy.layout.flip_right(), desc="Flip right"),
            # GROW
            Key(["control"], "Down", lazy.layout.grow_down(), desc="Grow down"),
            Key(["control"], "Up", lazy.layout.grow_up(), desc="Grow up"),
            Key(["control"], "Left", lazy.layout.grow_left(), desc="Grow left"),
            Key(["control"], "Right", lazy.layout.grow_right(), desc="Grow right"),
            # SPECIAL
            Key([], "BackSpace", lazy.layout.normalize(), desc="Normalize"),
            Key([], "Return", lazy.layout.toggle_split(), desc="Toggle split"),
            Key([], "q", lazy.window.kill(), desc="Kill focused window"),
        ],
        mode="window",
    ),
    # Keyboard layouts
    Key(
        [mod],
        "space",
        lazy.widget["keyboardlayout"].next_keyboard(),
        desc="Next keyboard layout.",
    ),
    # Unminimise client
    # (might not be needed)
    # Media keys
    # (might not be needed)
    # Toggle between different layouts as defined below
    # FIXME: will need to be changed eventually
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    # "clientkeys"
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "shift"], "t", lazy.window.toggle_floating(), desc="Pain"),
    # FIXME: "clientkeys" from AwesomeWM
]
# }}}

# BUTTONBINDS (MOUSE) {{{
# Drag floating layouts.
mouse = [
    # Switch between groups
    Click([mod], "Button4", lazy.screen.prev_group()),
    Click([mod], "Button5", lazy.screen.next_group()),
    # FIXME: below are some default binds, customise them
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]
# }}}

# LAYOUTS {{{
layouts = [
    layout.Columns(
        border_focus_stack="#d75f5f",
        margin=5,
        border_normal="#2d2a2e",
        border_focus="#f85e84",
        border_width=2,
    ),
    layout.Max(margin=5),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(
    #     border_focus_stack='#d75f5f',
    #     margin=5,
    #
    #     border_normal="#2d2a2e",
    #     border_focus="#f85e84",
    #
    #     border_width=2,
    # ),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]
# }}}

# TOP BAR {{{
widget_defaults = dict(
    font="FiraCode Nerd Font Mono",
    fontsize=13,
    padding=2,
)
extension_defaults = widget_defaults.copy()


class MousePosition(widget.base.InLoopPollText):
    def poll(self):
        return str(qtile.mouse_position)


screens = [
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(
                    active="#e3e1e4",
                    inactive="#49464e",
                    this_current_screen_border="#f85e84",
                    this_screen_border="#f85e84",
                    highlight_method="line",
                    highlight_color="1a181a",
                    rounded=False,
                ),
                widget.TaskList(
                    border="#49464e", padding=1, highlight_method="block", rounded=False
                ),
                widget.Chord(
                    chords_colors={
                        "launch": ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: " -- %s -- " % name.upper(),
                ),
                widget.GenPollText(
                    func=lambda: str(existence_reminder.tick()),
                    markup=False,
                    update_interval=1,
                ),
                # widget.TextBox("", name="default", foreground="#78dce8", padding=0, fontsize=24),
                widget.TextBox(
                    "", name="default", foreground="#78dce8", padding=0, fontsize=24
                ),
                widget.TextBox(
                    "ahoj Kati :)",
                    name="default",
                    background="#78dce8",
                    foreground="1a181a",
                ),
                # ^ the background HEX code is with a hashtag,
                #   but the foreg. HEX code is without one
                #
                #   normally, I would fix this, but Emi's OCD got
                #   triggered because of this and I think that's
                #   very cute <3
                widget.TextBox(
                    "",
                    name="default",
                    background="#78dce8",
                    foreground="#f85e84",
                    padding=0,
                    fontsize=24,
                ),
                widget.TextBox("emi 🥺", name="default", background="#f85e84"),
                # widget.TextBox("", name="default", foreground="#f85e84", padding=0, fontsize=24),
                widget.TextBox(
                    "",
                    name="default",
                    background="#f85e84",
                    foreground="#e3e1e4",
                    padding=0,
                    fontsize=24,
                ),
                widget.KeyboardLayout(
                    fmt=" {}",
                    configured_keyboards=["us", "cz(qwerty)"],
                    background="#e3e1e4",
                    foreground="#1a181a",
                ),
                widget.TextBox(
                    "",
                    name="default",
                    background="#e3e1e4",
                    foreground="#49464e",
                    padding=0,
                    fontsize=24,
                ),
                widget.Systray(background="#49464e"),
                widget.TextBox(
                    "",
                    name="default",
                    background="#49464e",
                    foreground="#9ecd6f",
                    padding=0,
                    fontsize=24,
                ),
                widget.Battery(
                    format="{percent:2.0%}batt",
                    battery=1,
                    background="#9ecd6f",
                    foreground="#1a181a",
                    low_foreground="#f85e84",
                ),
                widget.Battery(
                    format="{percent:2.0%}batt",
                    battery=0,
                    background="#9ecd6f",
                    foreground="#1a181a",
                    low_foreground="#f85e84",
                ),
                widget.TextBox(
                    "",
                    name="default",
                    background="#9ecd6f",
                    foreground="#e5c463",
                    padding=0,
                    fontsize=24,
                ),
                widget.Clock(
                    format="%H:%M:%S|%A %d.%m.|%b %Y",
                    background="#e5c463",
                    foreground="#1a181a",
                ),
                widget.TextBox(
                    "",
                    name="default",
                    background="#e5c463",
                    foreground="#1a181a",
                    padding=0,
                    fontsize=24,
                ),
                widget.CurrentLayoutIcon(
                    # padding=0,
                    # scale=False,
                    background="#1a181a",
                    foreground="#e3e1e4",
                ),
                # MousePosition(),  # test thing
            ],
            size=24,
            opacity=0.9,
            background="#2d2a2e",
            margin=5,
        ),
    )
    for _ in range(1)  # for _ in range(len(get_monitors()))
]
# }}}

# GROUPS {{{
groups = [Group(i) for i in "123456789"]

# for screen in range(len(screens)):
#     for group in '123456789':
#         groups.append(
#             Group(
#                 name="{screen}-{group}".format(
#                     screen=screen,
#                     group=group
#                 ),
#                 screen_affinity=screen,
#                 label=group
#             )
#         )

for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )
# }}}

# MISC {{{

# @subscribe.client_mouse_enter
# def change_screen_focus(c):
#     qtile.focus_screen(c.group.screen.index)

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
follow_mouse_focus = False
bring_front_click = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ],
    border_normal="#2d2a2e",
    border_focus="#f85e84",
    border_width=2,
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"

# }}}


# AUTOSTART RUNNER {{{
@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser("~")
    subprocess.call([home + "/.config/qtile/autostart.zsh"])


# }}}
