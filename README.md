# Dev machine config

Prywatny backup konfiguracji developerskiej z tego Maca. Repo zawiera konfiguracje narzedzi, listy pakietow i skrypty, ktore pomagaja odtworzyc setup na nowym komputerze.

Nie wrzucaj tego repo publicznie bez przegladu: czesc plikow zawiera prywatne sciezki, aliasy projektowe i konfiguracje hostow SSH. Tokeny, credentiale, prywatne klucze SSH i historie narzedzi AI zostaly celowo pominiete.

## Zawartosc

- `Brewfile` - pakiety Homebrew, caski i rozszerzenia VS Code wykryte przez `brew bundle dump`.
- `brew-leaves.txt` - reczna lista top-level formulae z Homebrew.
- `vscode-extensions.txt` - rozszerzenia VS Code.
- `cursor-extensions.txt` - rozszerzenia Cursor.
- `npm-global.json` i `npm-global.txt` - globalne paczki npm.
- `pyenv-versions.txt` - wersje Pythona w `pyenv`.
- `rust-toolchains.txt` - toolchainy Rust.
- `dotfiles/` - shell, git, tmux, Powerlevel10k, fzf.
- `config/` - `~/.config`, m.in. Neovim, Starship, Fish, Git, Zed.
- `app-support/` - ustawienia VS Code, Cursor i Ghostty.
- `hammerspoon/` - konfiguracja Hammerspoon.
- `docker/daemon.json` - daemon Docker bez credentiali.
- `ssh/config` - tylko `~/.ssh/config`, bez kluczy i `known_hosts`.
- `ai/codex/config.toml` - ustawienia Codex bez `auth.json`, historii i cache.

## Szybkie uzycie na nowym Macu

1. Sklonuj albo skopiuj to repo na nowy komputer.
2. Przejrzyj `dotfiles/.zshrc` i `ssh/config`, bo zawieraja aliasy oraz sciezki specyficzne dla obecnej maszyny.
3. Uruchom instalacje narzedzi:

```sh
./scripts/bootstrap.sh
```

4. Przywroc konfiguracje plikow:

```sh
./scripts/restore-configs.sh
```

Skrypt przywracania robi backup nadpisywanych plikow do `~/.config-restore-backup/<timestamp>/`.

## Rzeczy do zrobienia recznie

- Zaloguj sie ponownie do GitHub CLI: `gh auth login`.
- Wygeneruj lub przenies klucze SSH poza repo i ustaw uprawnienia `chmod 600 ~/.ssh/id_*`.
- Zaloguj Docker Desktop, OrbStack, VS Code/Cursor Sync, Codex, Claude, Gemini, Continue i inne narzedzia AI.
- Zainstaluj SDK Androida przez Android Studio i sprawdz `ANDROID_HOME`.
- Sprawdz, czy prywatne aliasy projektowe z `dotfiles/.zshrc` nadal maja sens.

## Aktualizacja backupu na tym komputerze

Po zmianach w konfiguracji mozesz odswiezyc inventory:

```sh
brew bundle dump --file=Brewfile --force
brew leaves > brew-leaves.txt
code --list-extensions > vscode-extensions.txt
cursor --list-extensions > cursor-extensions.txt
npm ls -g --depth=0 --json > npm-global.json
npm ls -g --depth=0 > npm-global.txt
pyenv versions > pyenv-versions.txt
rustup toolchain list > rust-toolchains.txt
```

Potem skopiuj zmienione pliki konfiguracyjne do odpowiednich katalogow repo i przejrzyj `git diff`.
