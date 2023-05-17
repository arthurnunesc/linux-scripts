#!/usr/bin/env sh

### VARIABLES ###


### FUNCTIONS ###


### EXECUTION ###

printf "\n\t\033[36m[ manual installations - start ]\033[0m\n"
# Installing chezmoi on user binaries folder
if [ -f "$HOME/.local/bin/chezmoi" ]; then
  printf "\t\tpackage \033[34mchezmoi\033[0m is already installed.\n"
else
  printf "\t\tinstalling \033[34mchezmoi\033[0m\n.\n"
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME"/.local/bin
fi

# Install neovim as an appimage
if [ -f "$HOME/.local/bin/nvim.appimage" ]; then
  printf "\t\tpackage \033[34mneovim\033[0m is already installed.\n"
else
  printf "\t\tinstalling \033[34mneovim\033[0m\n...\n"
  wget -q https://github.com/neovim/neovim/releases/download/stable/nvim.appimage -O "$HOME"/.local/bin/nvim.appimage
fi
printf "\t\033[35m[ manual installations - end ]\033[0m\n"
