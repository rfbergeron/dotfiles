#!/bin/bash

pkill -u $UID -fx "/bin/bash /home/robert/.config/i3/scripts/battery_check.sh" &>/dev/null
while pgrep -u $UID -fx "/bin/bash /home/robert/.config/i3/scripts/battery_check.sh" >/dev/null; do sleep 1; done
nohup ~/.config/i3/scripts/battery_check.sh &>/dev/null &

pkill -u $UID -fx "/bin/bash /home/robert/.config/i3/scripts/network_check.sh" &>/dev/null;
while pgrep -u $UID -fx "/bin/bash /home/robert/.config/i3/scripts/network_check.sh" >/dev/null; do sleep 1; done
nohup ~/.config/i3/scripts/network_check.sh &>/dev/null &
