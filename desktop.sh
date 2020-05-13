#/bin/bash

# tweak
sudo apt-get install -y gnome-tweaks
sudo apt install -y gnome-shell-extensions
sudo apt install -y chrome-gnome-shell

# pomodoro
sudo apt-get install -y gnome-shell-pomodoro

# theme

# font
wget https://github.com/naver/d2codingfont/releases/download/VER1.21/D2Coding-1.2.zip ~/
unzip ~/D2Coding-1.2.zip -d ~/
#sudo gnome-font-viewer D2Coding.ttf

# rclone
sudo apt-get install -y rclone i3
rclone copy onedrive:workpsace ~/workspace
rclone copy onedrive:vimwiki ~/vimwiki
#echo "0 */1   * * *   root    /home/sh/environment/rclone.sh >/dev/null 2>&1" >> /etc/crontab

sudo crontab /home/sh/environment/crontab

##
echo "## touchpad non click setting"
echo "## Changeg terminal font"
echo "## install Chrome"
echo "## gnome extension"
echo "## set pomodoro script"
echo "## set keymap"
echo "## tmux source"
