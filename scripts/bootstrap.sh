#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is missing. Install it first from https://brew.sh, then rerun this script."
  exit 1
fi

echo "Installing Homebrew bundle..."
brew bundle --file="$ROOT/Brewfile"

if [ -d /opt/homebrew/opt/nvm ]; then
  mkdir -p "$HOME/.nvm"
fi

if command -v code >/dev/null 2>&1 && [ -f "$ROOT/vscode-extensions.txt" ]; then
  echo "Installing VS Code extensions..."
  while IFS= read -r extension; do
    [ -z "$extension" ] && continue
    code --install-extension "$extension" --force
  done < "$ROOT/vscode-extensions.txt"
fi

if command -v cursor >/dev/null 2>&1 && [ -f "$ROOT/cursor-extensions.txt" ]; then
  echo "Installing Cursor extensions..."
  while IFS= read -r extension; do
    [ -z "$extension" ] && continue
    cursor --install-extension "$extension" --force
  done < "$ROOT/cursor-extensions.txt"
fi

if command -v npm >/dev/null 2>&1 && command -v jq >/dev/null 2>&1 && [ -f "$ROOT/npm-global.json" ]; then
  echo "Installing global npm packages..."
  jq -r '.dependencies // {} | keys[]' "$ROOT/npm-global.json" | while IFS= read -r package; do
    [ -z "$package" ] && continue
    npm install -g "$package"
  done
fi

if command -v pyenv >/dev/null 2>&1 && [ -f "$ROOT/pyenv-versions.txt" ]; then
  echo "Installing pyenv Python versions..."
  awk '{print $1}' "$ROOT/pyenv-versions.txt" | sed 's/^\*//' | while IFS= read -r version; do
    [ -z "$version" ] && continue
    [ "$version" = "system" ] && continue
    pyenv install -s "$version"
  done
fi

echo "Bootstrap done. Run scripts/restore-configs.sh to copy config files."
