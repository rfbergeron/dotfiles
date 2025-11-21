#!/bin/sh

# unbind '<Super>p' (switch monitor) so that it can be used for play/pause
# note that some (bad) motherboards may send this sequence when a monitor is
# connected or disconnected, since this keybinding also exists on Windows. this
# is why, I presume, this keyboard shortcut is not exposed in any of Gnome's
# graphical configuration tools.
gsettings set org.gnome.mutter.keybindings switch-monitor "['XF86Display']"

# unbind '<Super>v' (toggle message tray) so that it can be used for mute/unmute
gsettings set org.gnome.shell.keybindings toggle-message-tray "['<Super>m']"

# custom keybinding to launch a terminal
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Terminal'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'xdg-terminal-exec'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Super>Return'

if gsettings get org.gnome.shell.extensions.caffeine toggle-shortcut >/dev/null 2>&1; then
	gsettings set org.gnome.shell.extensions.caffeine toggle-shortcut "['<Super>z']"
fi

# unset legacy and IBM Common User Access keybindings
gsettings set org.gnome.desktop.wm.keybindings begin-move "[]"
gsettings set org.gnome.desktop.wm.keybindings begin-resize "[]"
gsettings set org.gnome.desktop.wm.keybindings cycle-group "[]"
gsettings set org.gnome.desktop.wm.keybindings cycle-group-backward "[]"
gsettings set org.gnome.desktop.wm.keybindings cycle-panels "[]"
gsettings set org.gnome.desktop.wm.keybindings cycle-panels-backward "[]"
gsettings set org.gnome.desktop.wm.keybindings cycle-windows "[]"
gsettings set org.gnome.desktop.wm.keybindings cycle-windows-backward "[]"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-down "[]"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-up "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-panels "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-panels-backward "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-down "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-up "[]"
gsettings set org.gnome.desktop.wm.keybindings toggle-maximized "[]"

gsettings set org.gnome.shell.keybindings shift-overview-down "[]"
gsettings set org.gnome.shell.keybindings shift-overview-up "[]"

# change useful legacy and CUA keybindings to use the Super key
gsettings set org.gnome.desktop.wm.keybindings activate-window-menu "['<Super>Menu']"
gsettings set org.gnome.desktop.wm.keybindings close "['<Super>w']"
gsettings set org.gnome.desktop.wm.keybindings panel-run-dialog "['<Super>r']"
gsettings set org.gnome.desktop.wm.keybindings switch-applications \
	"['<Super>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward \
	"['<Super><Shift>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-group \
	"['<Super>Above_Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-group-backward \
	"['<Super><Shift>Above_Tab']"

gsettings set org.gnome.shell.keybindings show-screen-recording-ui \
	"['<Super><Shift>r']"
gsettings set org.gnome.shell.keybindings show-screenshot-ui \
	"['<Super><Shift>s']"
gsettings set org.gnome.shell.keybindings screenshot \
	"[]"
gsettings set org.gnome.shell.keybindings screenshot-window \
	"[]"

gsettings set org.gnome.settings-daemon.plugins.media-keys logout \
	"['<Super><Shift>l']"
gsettings set org.gnome.settings-daemon.plugins.media-keys home \
	"['<Super><Shift>h']"
gsettings set org.gnome.settings-daemon.plugins.media-keys eject \
	"['<Super>e']"
gsettings set org.gnome.settings-daemon.plugins.media-keys www \
	"['<Super><Shift>w']"

# use numpad for window and workspace controls
gsettings set org.gnome.desktop.wm.keybindings maximize \
	"[]"
gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-down \
	"['<Super><Shift>Down','<Super><Shift>KP_Down']"
gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-left \
	"['<Super><Shift>Left','<Super><Shift>KP_Left']"
gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-right \
	"['<Super><Shift>Right','<Super><Shift>KP_Right']"
gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-up \
	"['<Super><Shift>Up','<Super><Shift>KP_Up']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-1 \
	"['<Super><Shift>Home','<Super><Shift>KP_Home']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-last \
	"['<Super><Shift>End','<Super><Shift>KP_End']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-left \
	"['<Super><Shift>Page_Up','<Super><Shift>KP_Page_Up']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-right \
	"['<Super><Shift>Page_Down','<Super><Shift>KP_Page_Down']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 \
	"['<Super>Home','<Super>KP_Home']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-last \
	"['<Super>End','<Super>KP_End']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left \
	"['<Super>Page_Up','<Super>KP_Page_Up']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right \
	"['<Super>Page_Down','<Super>KP_Page_Down']"
gsettings set org.gnome.desktop.wm.keybindings toggle-maximized \
	"['<Super>Up','<Super>KP_Up']"
gsettings set org.gnome.mutter.keybindings toggle-tiled-left \
	"['<Super>Left','<Super>KP_Left']"
gsettings set org.gnome.mutter.keybindings toggle-tiled-right \
	"['<Super>Right','<Super>KP_Right']"
gsettings set org.gnome.desktop.wm.keybindings unmaximize \
	"['<Super>Down','<Super>KP_Down']"

# miscellaneous
gsettings set org.gnome.settings-daemon.plugins.media-keys mic-mute \
	"['<Super><Shift>v']"
gsettings set org.gnome.settings-daemon.plugins.media-keys next \
	"['<Super><Shift>n']"
gsettings set org.gnome.settings-daemon.plugins.media-keys play "['<Super>p']"
gsettings set org.gnome.settings-daemon.plugins.media-keys previous \
	"['<Super><Shift>p']"
gsettings set org.gnome.settings-daemon.plugins.media-keys volume-mute \
	"['<Super>v']"

gsettings set org.gnome.desktop.wm.keybindings show-desktop "['<Super>d']"
gsettings set org.gnome.desktop.wm.keybindings toggle-fullscreen "['<Super>f']"
