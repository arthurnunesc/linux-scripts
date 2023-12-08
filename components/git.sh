#!/usr/bin/env sh

printf "\t- configuring git variables...\n"

git config --global user.email "arthurnunesc@proton.me"
git config --global user.name "Arthur Nunes"
git config --global core.editor "nvim"

# Create Developer folder
if [ ! -d "$HOME/Developer" ]; then
  mkdir "$HOME"/Developer
fi