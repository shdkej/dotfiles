#/bin/bash

# tweak
sudo apt-get install gnome-tweaks
sudo apt install gnome-shell-extensions
sudo apt install chrome-gnome-shell

# pomodoro
sudo apt-get install gnome-shell-pomodoro

# theme

# font
wget https://github.com/naver/d2codingfont/releases/download/VER1.21/D2Coding-1.2.zip
unzip D2Coding-1.2.zip
sudo gnome-font-viewer D2Coding.ttf

# rclone
#echo "0 */1   * * *   root    /home/sh/environment/rclone.sh >/dev/null 2>&1" >> /etc/crontab

##
echo "## touchpad non click setting"
echo "## Changeg terminal font"
echo "## install Chrome"
echo "## gnome extension"
echo "## set pomodoro script"
echo "## set keymap"
