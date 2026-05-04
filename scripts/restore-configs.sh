#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP="$HOME/.config-restore-backup/$STAMP"

backup_target() {
  local target="$1"
  if [ -e "$target" ] || [ -L "$target" ]; then
    local relative="${target#$HOME/}"
    mkdir -p "$BACKUP/$(dirname "$relative")"
    mv "$target" "$BACKUP/$relative"
  fi
}

copy_file() {
  local source="$1"
  local target="$2"
  [ -f "$source" ] || return 0
  backup_target "$target"
  mkdir -p "$(dirname "$target")"
  cp "$source" "$target"
}

copy_dir() {
  local source="$1"
  local target="$2"
  [ -d "$source" ] || return 0
  backup_target "$target"
  mkdir -p "$(dirname "$target")"
  cp -R "$source" "$target"
}

for file in "$ROOT"/dotfiles/.* "$ROOT"/dotfiles/*; do
  [ -f "$file" ] || continue
  copy_file "$file" "$HOME/$(basename "$file")"
done

copy_file "$ROOT/config/starship.toml" "$HOME/.config/starship.toml"
copy_dir "$ROOT/config/nvim" "$HOME/.config/nvim"
copy_dir "$ROOT/config/fish" "$HOME/.config/fish"
copy_dir "$ROOT/config/git" "$HOME/.config/git"
copy_dir "$ROOT/config/zed" "$HOME/.config/zed"

copy_file "$ROOT/app-support/Code/User/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
copy_file "$ROOT/app-support/Code/User/keybindings.json" "$HOME/Library/Application Support/Code/User/keybindings.json"
copy_file "$ROOT/app-support/Ghostty/config" "$HOME/Library/Application Support/com.mitchellh.ghostty/config"

copy_file "$ROOT/ssh/config" "$HOME/.ssh/config"

echo "Config restore done."
echo "Backups, if any, are in: $BACKUP"
