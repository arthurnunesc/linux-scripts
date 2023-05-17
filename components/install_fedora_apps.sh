#!/usr/bin/env sh

### VARIABLES ###

dnf_pkgs_codecs_and_utils="git ssh curl wget ffmpeg fuse-exfat util-linux-user dnf-plugins-core fzf fd-find ripgrep gstreamer1-libav gstreamer1-plugin-openh264 alsa-lib-devel openssl-devel qt5-qtbase qt5-qtbase-gui qt5-qtsvg qt5-qtdeclarative qt5-qtquickcontrols"
dnf_pkgs_gnome_wayland_and_eyecandy="gnome-tweaks dconf-editor rsms-inter-fonts mozilla-fira-sans-fonts libratbag-ratbagd fira-code-fonts jetbrains-mono-fonts ulauncher wmctrl wl-clipboard"
dnf_pkgs_terminal="zsh dash kitty btop neofetch ranger vim-enhanced code"
dnf_pkgs_devops="ansible docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose docker-compose-plugin"
dnf_pkgs_langs="cmake make gcc gcc-c++ go rust cargo python3 python3-pip conda shellcheck devscripts-checkbashisms nodejs java-1.8.0-openjdk java-11-openjdk java-17-openjdk java-latest-openjdk"


### FUNCTIONS ###

update_remote_config() {
	if grep -Fxq "max_parallel_downloads=10" /etc/dnf/dnf.conf; then
	  printf "\t\tmax_parallel_downloads variable was already set to 10.\n"
	else
	  printf "\t\tchanging max_parallel_downloads variable to 10...\n"
	  echo "max_parallel_downloads=10" | sudo tee -a /etc/dnf/dnf.conf
	  printf "\t\tdone.\n"
	fi

	if grep -Fxq "fastestmirror=True" /etc/dnf/dnf.conf; then
	  printf "\t\tfastestmirror variable was already set to True.\n"
	else
	  printf "\t\tchanging fastestmirror variable to True...\n"
	  echo "fastestmirror=True" | sudo tee -a /etc/dnf/dnf.conf
	  printf "\t\tdone.\n"
	fi
}

update_and_upgrade() {
  sudo dnf update -yq > /dev/null 2>&1
  sudo dnf upgrade -yq --refresh > /dev/null 2>&1
}

only_update() {
  sudo dnf update -yq > /dev/null 2>&1
}

# Takes a string with dnf packages separated by spaces and installs them one by one
install_dnf_pkgs_from_string() {
  installed_dnf_apps=$(dnf list --installed | awk '{print $1}')

  echo "$1" | tr ' ' '\n' | while read -r app; do
    if ! echo "$installed_dnf_apps" | grep -q "$app"; then
      sudo dnf install -yq "$app" > /dev/null 2>&1
      printf "\t\tpackage \033[34m%s\033[0m was installed.\n" "$app"
    else
      printf "\t\tpackage \033[34m%s\033[0m is already installed.\n" "$app" 
    fi
  done
}


### EXECUTION ###

printf "\t- changing remote configurations to make downloads faster...\n"
update_remote_config

printf "\t- adding repos...\n"
# Add RPMFusion repos
sudo dnf install -yq https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm > /dev/null 2>&1

# Add VSCode repo
sudo rpm --quiet --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

# Remove previous Docker versions and add its repo
# sudo dnf remove -yq docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-selinux docker-engine-selinux docker-engine > /dev/null 2>&1
sudo dnf config-manager -yq --add-repo https://download.docker.com/linux/fedora/docker-ce.repo > /dev/null 2>&1

printf "\t- updating and upgrading everything...\n"
update_and_upgrade

printf "\n\t\033[36m[ dnf - start ]\033[0m\n"

printf "\t- installing codecs, utils and dependencies...\n"
install_dnf_pkgs_from_string "$dnf_pkgs_codecs_and_utils"
sudo dnf install -yq gstreamer1-plugins-good gstreamer1-plugins-base --exclude=gstreamer1-plugins-bad-free-devel
sudo dnf groupinstall -yq "Development Tools"
sudo dnf install -yq lame\* --exclude=lame-devel
sudo dnf group upgrade -yq --with-optional Multimedia
printf "\t- installing packages related to gnome, wayland and eyecandy...\n"
install_dnf_pkgs_from_string "$dnf_pkgs_gnome_wayland_and_eyecandy"
printf "\t- installing terminal related packages...\n"
install_dnf_pkgs_from_string "$dnf_pkgs_terminal"
printf "\t- installing devops tools...\n"
install_dnf_pkgs_from_string "$dnf_pkgs_devops"
printf "\t- installing languages envs and their packages managers...\n"
install_dnf_pkgs_from_string "$dnf_pkgs_langs"

printf "\t\033[35m[ dnf - end ]\033[0m\n"

