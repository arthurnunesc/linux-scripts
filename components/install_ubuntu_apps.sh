#!/usr/bin/env sh

### VARIABLES ###

apt_pkgs_codecs_and_utils="git wget gpg apt-transport-https"
apt_pkgs_gnome_wayland_and_eyecandy="gnome-tweaks dconf-editor ulauncher wl-clipboard wmctrl"
apt_pkgs_terminal="zsh kitty btop neofetch ranger vim code"
apt_pkgs_devops="ansible docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin"
apt_pkgs_langs="python3 python3-pip rust cargo"
apt_pkgs_deps=""
apt_paco_deps="gcc clang libpq-dev libbsd-dev libncurses-dev valgrind python3-venv python3-wheel python3-dev python-dev"


### FUNCTIONS ###

update_and_upgrade() {
  sudo apt full-upgrade -yqq > /dev/null 2>&1
}

only_update() {
  sudo apt update -yqq > /dev/null 2>&1
}

# Takes a string with apt packages separated by spaces and installs them one by one
install_apt_pkgs_from_string() {
  installed_apt_apps=$(apt list --installed | awk '{print $1}')

  echo "$1" | tr ' ' '\n' | while read -r app; do
    if ! echo "$installed_apt_apps" | grep -q "$app"; then
      sudo apt install -yq "$app" > /dev/null 2>&1
      printf "\t\tpackage \033[34m%s\033[0m was installed.\n" "$app"
    else
      printf "\t\tpackage \033[34m%s\033[0m is already installed.\n" "$app" 
    fi
  done
}


### EXECUTION ###

printf "\t- adding repos...\n"
# Add VSCode repo
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg

# Add ULauncher ppa
sudo add-apt-repository ppa:agornostal/ulauncher

# Remove previous Docker versions and add its repo
sudo apt-get remove docker docker-engine docker.io containerd runc
install_apt_pkgs_from_string "ca-certificates curl gnupg"
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

printf "\t- updating and upgrading everything...\n"
update_and_upgrade

printf "\n\t\033[36m[ apt - start ]\033[0m\n"

printf "\t- installing codecs, utils and dependencies...\n"
install_apt_pkgs_from_string "$apt_pkgs_codecs_and_utils"
printf "\t- installing packages related to gnome, wayland and eyecandy...\n"
install_apt_pkgs_from_string "$apt_pkgs_gnome_wayland_and_eyecandy"
printf "\t- installing terminal related packages...\n"
install_apt_pkgs_from_string "$apt_pkgs_terminal"
printf "\t- installing devops tools...\n"
install_apt_pkgs_from_string "$apt_pkgs_devops"
printf "\t- installing languages envs and their packages managers...\n"
install_apt_pkgs_from_string "$apt_pkgs_langs"
printf "\t- installing dependencies...\n"
install_apt_pkgs_from_string "$apt_pkgs_deps"
install_apt_pkgs_from_string "$apt_paco_deps"

printf "\t\033[35m[ apt - end ]\033[0m\n"

