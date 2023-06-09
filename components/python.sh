#!/usr/bin/env sh

printf "\t- configuring python and installing pip packages...\n"

pip3_apps="pip setuptools tldr norminette ruff-lsp black pynvim black[jupyter] black[d]"

echo "$pip3_apps" | tr ' ' '\n' | while read -r pkg; do
  pip3 install -Uq "$pkg"
done

if [ ! -d "$HOME"/.local/venv/nvim ]; then
  mkdir -p "$HOME"/.local/venv && cd "$HOME"/.local/venv || return
  python3 -m venv nvim
  cd nvim || return
  . ./bin/activate
  pip3 install -Uq pynvim black
  cd || return
fi

# sh ./components/conda-auto-install.sh
