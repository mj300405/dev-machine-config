# Celowo pominiete

Te pliki i katalogi byly obecne na komputerze, ale nie zostaly skopiowane do repo, bo zwykle zawieraja sekrety, historie, cache, lokalne bazy albo dane sesji:

- `~/.ssh/id_*`, `~/.ssh/known_hosts*`, `~/.ssh/agent/`
- `~/.docker/config.json`, `~/.docker/.token_seed`, `~/.docker/contexts/`
- `~/.config/gh/hosts.yml`
- `~/.codex/auth.json`, `~/.codex/history.jsonl`, `~/.codex/*.sqlite*`, `~/.codex/sessions/`
- `~/.claude.json`, `~/.claude/`
- `~/.gemini/`
- `~/.continue/`
- `~/.cursor/extensions/`, `~/Library/Application Support/Cursor/User/globalStorage/`, `workspaceStorage/`, `History/`
- `~/Library/Application Support/Code/User/globalStorage/`, `workspaceStorage/`, `History/`, `mcp.json`
- `~/.config/zed/prompts/`
- shell histories: `.zsh_history`, `.bash_history`, `.python_history`

Jezeli naprawde potrzebujesz ktoregos z tych elementow, przenies go osobnym, prywatnym i szyfrowanym kanalem. Nie mieszaj go z repo dotfiles.
