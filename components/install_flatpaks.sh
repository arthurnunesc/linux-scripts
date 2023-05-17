#!/usr/bin/env sh

### VARIABLES ###

flatpak_apps="md.obsidian.Obsidian com.obsproject.Studio com.spotify.Client com.slack.Slack io.github.spacingbat3.webcord com.belmoussaoui.Obfuscate org.gnome.Extensions org.gnome.SoundRecorder org.gnome.Shotwell com.github.tchx84.Flatseal com.transmissionbt.Transmission nl.hjdskes.gcolor3"

### FUNCTIONS ###

update_flatpaks() {
  flatpak update -y --noninteractive > /dev/null 2>&1
}

# Takes a string with FlatHub inverse domains separated by spaces and installs the
install_flatpak_apps_from_string() {
  installed_flatpak_apps=$(flatpak list)

  echo "$1" | tr ' ' '\n' | while read -r app; do
    if ! echo "$installed_flatpak_apps" | grep -q "$app"; then
      flatpak install flathub -y --noninteractive "$app" > /dev/null 2>&1
      printf "\t\tpackage \033[34m%s\033[0m was installed.\n" "$app"
    else
      printf "\t\tpackage \033[34m%s\033[0m is already installed.\n" "$app" 
    fi
  done
}

### EXECUTION ###

update_everything() {
  sudo dnf update -yq > /dev/null 2>&1
  sudo dnf upgrade -yq --refresh > /dev/null 2>&1
  flatpak update -y --noninteractive > /dev/null 2>&1
}

printf "\n\t\033[36m[ flatpak - start ]\033[0m\n"
printf "\t - installing flatpak apps...\n"
install_flatpak_apps_from_string "$flatpak_apps"
printf "\t\033[35m[ flatpak - end ]\033[0m\n"

