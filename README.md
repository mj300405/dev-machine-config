# AI engineering machine config

Lekki, prywatny setup pod nowy komputer sluzbowy. Repo celowo trzyma tylko konfiguracje, ktore maja sens przenosic miedzy pracami: ustawienia IDE/terminala, neutralne aliasy, podstawowe CLI oraz Python/AI tooling.

Nie ma tu prywatnego globalnego usera Gita, Cursor, Hammerspoon, Codex configu, projektowych aliasow ani duzych aplikacji ze starego fullstackowego setupu.

## Zawartosc

- `Brewfile` - minimalny Homebrew bundle: shell/CLI, VS Code, Ghostty, Neovim, Python tooling, Ollama/opencode, OrbStack.
- `vscode-extensions.txt` - okrojony zestaw rozszerzen VS Code pod Python/AI/notebooki i podstawowe formatowanie.
- `npm-global.json` i `npm-global.txt` - globalne paczki npm, zostawione jako inventory.
- `pyenv-versions.txt` - tylko Python `3.14.4`.
- `rust-toolchains.txt` - Rust inventory, bez automatycznej instalacji w skrypcie.
- `dotfiles/` - shell, tmux, Powerlevel10k, fzf; bez `.gitconfig`.
- `config/` - Neovim, Starship, Fish, Git ignore, Zed.
- `app-support/` - ustawienia VS Code i Ghostty.
- `ssh/config` - tylko neutralny SSH config, bez kluczy.

## Szybkie uzycie na nowym Macu

1. Sklonuj albo skopiuj repo.
2. Przejrzyj `dotfiles/.zshrc` i usun aliasy, ktore nie pasuja do firmowego standardu.
3. Zainstaluj narzedzia:

```sh
./scripts/bootstrap.sh
```

4. Przywroc konfiguracje:

```sh
./scripts/restore-configs.sh
```

Skrypt przywracania robi backup nadpisywanych plikow do `~/.config-restore-backup/<timestamp>/`.

## Rzeczy do zrobienia recznie

- Ustaw sluzbowego usera Git:

```sh
git config --global user.name "Twoje Imie"
git config --global user.email "twoj.email@firma.com"
```

- Zaloguj GitHub CLI: `gh auth login`.
- Wygeneruj lub przenies klucze SSH poza repo i ustaw `chmod 600 ~/.ssh/id_*`.
- Zaloguj VS Code Sync, Claude/Cline, Ollama registry albo inne narzedzia wymagane w nowej pracy.
- Doinstaluj rzeczy projektowe dopiero wtedy, gdy beda potrzebne.

## Aktualizacja

Po zmianach odswiez inventory:

```sh
brew bundle dump --file=Brewfile --force
brew leaves > brew-leaves.txt
code --list-extensions > vscode-extensions.txt
npm ls -g --depth=0 --json > npm-global.json
npm ls -g --depth=0 > npm-global.txt
pyenv versions > pyenv-versions.txt
rustup toolchain list > rust-toolchains.txt
```

Przed commitem zawsze przejrzyj `git diff`, szczegolnie pod katem prywatnych sciezek, hostow i tokenow.
