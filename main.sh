#!/bin/bash

# Setup your config

password="password"
timezone="Europe/Madrid"

# If you want setup davfs mount uncomment the following lines and set the variables
# davfs_url="https://example.com"
# davfs_user="example_user"
# davfs_password="example_password"
# davfs_mount_point="/mnt/example"

# Variables

dir=$(pwd)
user=$(whoami)

# Initial Setup and installs

sudo timedatectl set-timezone $timezone
sudo add-apt-repository ppa:phoerious/keepassxc
sudo apt install wget gpg apt-transport-https -y
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg


sudo apt update
sudo apt-get install make gcc libxcb-xinerama0-dev libxcb-icccm4-dev libxcb-randr0-dev libxcb-util0-dev libxcb-ewmh-dev libxcb-keysyms1-dev libxcb-shape0-dev polybar bspwm sxhkd rofi feh python3-pip net-tools gnome-terminal lm-sensors xclip jq wireguard resolvconf curl bat snapd  code davfs2 keepassxc torbrowser-launcher -y
sudo systemctl enable snapd.socket && sudo systemctl start snapd.socket
sudo ln -s /var/lib/snapd/snap /snap

# Create Directories

mkdir /home/$user/Credentials /home/$user/Projects /home/$user/Machines /home/$user/Software /home/$user/Downloads /home/$user/Pictures /home/$user/Videos /home/$user/Music /home/$user/Documents /home/$user/.ssh
sudo chown -R $user:$user /home/$user/Credentials /home/$user/Projects /home/$user/Machines /home/$user/Software /home/$user/Downloads /home/$user/Pictures /home/$user/Videos /home/$user/Music /home/$user/Documents /home/$user/.ssh
mkdir -p /home/$user/.config/{bspwm,sxhkd,polybar}
mkdir /home/$user/.config/bspwm/scripts/
mkdir /home/$user/.config/polybar/modules/
sudo mkdir -p /usr/share/pictures
sudo mkdir -p $davfs_mount_point

# Download 

cd /home/$user/Downloads
git clone https://github.com/baskerville/bspwm.git
git clone https://github.com/baskerville/sxhkd.git
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Hack.zip
git clone https://github.com/lr-tech/rofi-themes-collection.git

# Install

cd bspwm && make && sudo make install
cd ../sxhkd && make && sudo make install
cd /home/$user/Downloads
sudo unzip Hack.zip -d /usr/share/fonts/
cd rofi-themes-collection
mkdir -p ~/.local/share/rofi/themes/
cp themes/rounded-common.rasi ~/.local/share/rofi/themes/
cp themes/rounded-blue-dark.rasi ~/.local/share/rofi/themes/
cd /home/$user/Downloads

# Configs

cp $dir/config/bspwmrc /home/$user/.config/bspwm/
cp $dir/config/sxhkdrc /home/$user/.config/sxhkd/
cp $dir/config/config.ini /home/$user/.config/polybar/
cp $dir/config/launch.sh /home/$user/.config/polybar/
cp -r $dir/modules/ /home/$user/.config/polybar/
cp $dir/config/bspwm_resize /home/$user/.config/bspwm/scripts/bspwm_resize
cp $dir/images/wallpaper.png /home/$user/Pictures/wallpaper.png
sudo cp $dir/images/wallpaper.png /usr/share/pictures/wallpaper.png
sudo cp $dir/utils/set_target /usr/bin/set_target
sudo cp $dir/utils/keepass /usr/bin/keepass
sudo cp $dir/utils/torbrowser /usr/bin/torbrowser
sudo cp $dir/utils/mount_dav /usr/bin/mount_dav
cp /etc/X11/xinit/xinitrc /home/$user/.xinitrc
echo "exec bspwm" >> /home/$user/.xinitrc

# Permisisions

chmod u+x /home/$user/.config/bspwm/bspwmrc
chmod u+x /home/$user/.config/polybar/launch.sh
chmod u+x /home/$user/.config/bspwm/scripts/bspwm_resize
chmod +x /home/$user/.config/polybar/modules/*.sh
sudo chmod +x /usr/bin/set_target
sudo chmod +x /usr/bin/keepass
sudo chmod +x /usr/bin/torbrowser
sudo chmod +x /usr/bin/mount_dav

# Snaps installation

# Security

if [[ $password != "password" ]]; then
    echo "$password" > /home/$user/Credentials/kee.pas
    mkdir -p /home/$user/Credentials/.tmp /home/$user/Credentials/.keys
    openssl genpkey -algorithm RSA -out /home/$user/Credentials/.keys/private_key.pem
    openssl rsa -pubout -in /home/$user/Credentials/.keys/private_key.pem -out /home/$user/Credentials/.keys/public_key.pem
    openssl pkeyutl -encrypt -pubin -inkey /home/$user/Credentials/.keys/public_key.pem -in /home/$user/Credentials/kee.pas -out /home/$user/Credentials/kee.enc && rm /home/$user/Credentials/kee.pas
else
    echo "You need to set a password"
fi

# Clean

sudo rm -r /home/$user/Downloads/bspwm /home/$user/Downloads/sxhkd /home/$user/Downloads/rofi-themes-collection /home/$user/Downloads/Hack.zip

# Additional config

mount_dav $davfs_url $davfs_user $davfs_password $davfs_mount_point
set_target localhost