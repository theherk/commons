Information about theme configurations.

# Colors

- [an old hope](https://github.com/mohkale/an-old-hope-theme)
- [dracula](https://draculatheme.com/)
- [kaolin themes - bubblegum](https://github.com/ogdenwebb/emacs-kaolin-themes) and [kaolin-inspired](https://github.com/alternateved/kaolin-inspired)
- [night owl](https://github.com/sdras/night-owl-vscode-theme)
- [onelight](https://github.com/atom/one-light-syntax)
- [tokyonight](https://github.com/enkia/tokyo-night-vscode-theme)

## Switching

The following places require updates to theme:

- emacs: .config/doom/config.org
- firefox
- gitui: .config/gitui/theme.ron
- helix: .config/helix/config.toml
- slack
- wezterm: .config/wezterm/wezterm.lua

Aside from firefox and slack, a simple light / dark toggle can be done with:

    light-dark-toggle.sh

On MacOS you can toggle the system theme and run this file by importing the shortcut file provided herein, /light-dark-toggle.shortcut, and clicking the light-dark-toggle shortcut in the menu bar.

### firefox themes

- [dracula](https://addons.mozilla.org/en-US/firefox/addon/dracula-dark/)
- [kaolin bubblegum](https://color.firefox.com/?theme=XQAAAAIOAQAAAAAAAABBKYhm849SCia2CaaEGccwS-xMDPr0sKyHm0LFtsAuOs5Hgc59MzILXCVRpjcIcxKwXf-yc__PKRtJvTLuqCwxEvSIG5G-JU2nV8QMryjBVOlGDzRqLdB29oIFwqvIfpV4XWTC1uKCh3ILvcnJhfHuMoyL5sRfBa2iZxDB_ya6eVp-KaVwghWkUDYPaLkOR63d33whjJPzYrpf2sh9d2ppdtku_Z76zswg)
- [matte black orange (for an old hope)](https://addons.mozilla.org/en-US/firefox/addon/matte-black-orange/)
- [night owl](https://addons.mozilla.org/en-US/firefox/addon/night-owl-theme/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search)
- [onelight](https://color.firefox.com/?theme=XQAAAAJYAQAAAAAAAABBqYhm849SCia48_6EGccwS-xMDPsqui0WXAF6EJDWcx9sS_Bi3Mg0XfKVOpjLZbrt6cUGi1jsiVZ6ZGU23ffeKNdpwwjgYMgW0oKsEDc7Cv07-jfqgvFCbZPMWLqUeUYM-R5VeXc1bEnt673_ihe18VLZcWDVqBVOIardk0mbhg6ADhg11U_PbEzLv3issg9Pf5qxW-CdwKwykF-kMnpHWuqal-oprPfiw0z9csiaoKVWrw-jAJDejZVvTlkCcbwmpd2IoKoLXTv4G__u42w)

#### Refined Github

It is nice to improve the bar with this custom css when in light mode. It can be done in the plugin preferences.

```css
.Header {
  background-color: #9E9E9E;
}

.header-search-wrapper {
  background-color: #9E9E9E;
}
```

### slack themes

- an old hope

```
#1C1D21,#44475A,#45474F,#4FB4D8,#B55510,#CBCDD2,#78BD65,#EB3D54,#1C1D21,#E5CD52
```

- DNGreenie

```
#295459,#121016,#193639,#F7F7F7,#386B75,#BEC1C5,#53E4FF,#E384AD,#295459,#BEC1C5
#324141,#121016,#3E5858,#F3F3F3,#253131,#C5C5C5,#6ACE89,#F7768E,#324141,#C5C5C5
```

- kaolin bubblegum

```
#14171E,#E84C58,#272C3A,#41B0F3,#272C3A,#E4E4E8,#A2C5C5,#EED891,#14171E,#C79AF4
```

- night owl

```
#011627,#1D3B53,#1D3B53,#82AAFF,#1D3B53,#D6DEEB,#ADDB67,#7E57C2,#0A151F,#D6DEEB
```

- onelight

```
#FAFAFA,#EDEDED,#A6C5EF,#B500A9,#EDEDED,#282C34,#24A443,#DC003F,#E3E3E3,#0061FF
```

- tokyonight

```
#1E2336,#121016,#282E44,#B6BFE5,#282E44,#8C94B8,#8DCE59,#8366AF,#1E2336,#8C94B8
```

### themer

- [kaolin bubblegum](https://themer.dev/?colors.dark.shade0=%2314171e&colors.dark.shade7=%23e4e4e8&colors.dark.accent0=%23e84c58&colors.dark.accent1=%23c79af4&colors.dark.accent2=%23eed891&colors.dark.accent3=%2363e8c1&colors.dark.accent5=%2341b0f3&colors.dark.accent4=%236bd9db&colors.dark.accent6=%2341b0f3&colors.dark.accent7=%23c79af4)
- [night owl](https://themer.dev/?colors.dark.shade0=%23011627&colors.dark.shade7=%23d6deeb&colors.dark.accent0=%23ef5350&colors.dark.accent1=%23c792ea&colors.dark.accent2=%23c5e478&colors.dark.accent3=%2322da6e&colors.dark.accent4=%23c792ea&colors.dark.accent5=%2382aaff&colors.dark.accent6=%2321c7a8&colors.dark.accent7=%23c792ea&activeColorSet=dark&calculateIntermediaryShades.dark=true&calculateIntermediaryShades.light=true)

## Vitamin C Custom CSS

```css
/* #ui */

.D>.LH {
    background: #1a1b26;
    color: #2ac3de;
    border-color: #bb9af7;
    scale: 1.33;
}

/* #omni */

#bar {
    background: #1a1b26;
    border-color: #bb9af7;
}

#input {
    background: #24283b;
    border-color: #bb9af7;
}

.item {
    background: #1a1b26;
}

.top {
    color: #9aa5ce;
}

.bottom {
    color: #a9b1d6;
}

.history {
    fill: #e0af68;
}
```

# Fonts

- [victor mono](https://rubjo.github.io/victor-mono/)
- [ubuntu](https://design.ubuntu.com/font/)

## Switching

The following places require updates to font:

- emacs: ~/.config/doom/config.org
- wezterm: ~/.config/wezterm/wezterm.lua

* Miscellany

Firefox is a bit more pleasant for me in MacOS fullscreen with the tabs below the address bar. To do that, add this to your profile's userChrome.css.

`~/Library/Application\ Support/Firefox/Profiles/<profile>/chrome/userChrome.css`

```css
/* Source file https://github.com/MrOtherGuy/firefox-csshacks/tree/master/chrome/tabs_on_bottom.css made available under Mozilla Public License v. 2.0
See the above repository for updates as well as full license text. */

/* Modify to change window drag space width */
/*
Use tabs_on_bottom_menubar_on_top_patch.css if you
have menubar permanently enabled and want it on top
 */

/* IMPORTANT */
/*
Get window_control_placeholder_support.css
Window controls will be all wrong without it.
Additionally on Linux, you may need to get:
linux_gtk_window_control_patch.css
*/

#toolbar-menubar[autohide="true"] > .titlebar-buttonbox-container,
#TabsToolbar > .titlebar-buttonbox-container{
  position: fixed;
  display: block;
  top: 0px;
  right:0;
  height: 40px;
}
/* Mac specific. You should set that font-smoothing pref to true if you are on any platform where window controls are on left */
@supports -moz-bool-pref("layout.css.osx-font-smoothing.enabled"){
  .titlebar-buttonbox-container{ left:0; right: unset !important; }
}

:root[uidensity="compact"] #TabsToolbar > .titlebar-buttonbox-container{ height: 32px }

#toolbar-menubar[inactive] > .titlebar-buttonbox-container{ opacity: 0 }

.titlebar-buttonbox-container > .titlebar-buttonbox{ height: 100%; }

#titlebar{
  -moz-box-ordinal-group: 2;
  -moz-appearance: none !important;
  --tabs-navbar-shadow-size: 0px;
}
/* Re-order window and tab notification boxes */
#navigator-toolbox > div{ display: contents }
.global-notificationbox,
#tab-notification-deck{ -moz-box-ordinal-group: 2 }

#TabsToolbar .titlebar-spacer{ display: none; }
/* Also hide the toolbox bottom border which isn't at bottom with this setup */
#navigator-toolbox::after{ display: none !important; }

@media (-moz-gtk-csd-close-button){ .titlebar-button{ -moz-box-orient: vertical } }

/* At Activated Menubar */
:root:not([chromehidden~="menubar"], [sizemode="fullscreen"]) #toolbar-menubar:not([autohide="true"]) + #TabsToolbar > .titlebar-buttonbox-container {
  display: block !important;
}
#toolbar-menubar:not([autohide="true"]) > .titlebar-buttonbox-container {
  visibility: hidden;
}

/* These exist only for compatibility with autohide-tabstoolbar.css */
toolbox#navigator-toolbox > toolbar#nav-bar.browser-toolbar{ animation: none; }
#navigator-toolbox:hover #TabsToolbar{ animation: slidein ease-out 48ms 1 }
#TabsToolbar > .titlebar-buttonbox-container{ visibility: visible }
#navigator-toolbox:not(:-moz-lwtheme){ background-color: -moz-dialog }

/* Uncomment the following if you want bookmarks toolbar to be below tabs */
/*
#PersonalToolbar{ -moz-box-ordinal-group: 2 }
*/
```
