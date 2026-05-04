# Terminal
export TERM=xterm-256color

# Zsh
autoload -Uz compinit
compinit

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt PROMPT_SUBST

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# Python / local tools
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.pixi/bin:$PATH"
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# LM Studio CLI
export PATH="$PATH:$HOME/.lmstudio/bin"

# General aliases
alias dc='docker compose'
alias ls='eza --group-directories-first'
alias lc='eza --tree --group-directories-first'
alias cat='bat --style=plain'
alias ll='eza -l --group-directories-first'
alias la='eza -la --group-directories-first'
alias clear='command clear'

# Zsh plugins
[ -f "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && source "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
[ -f "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && source "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

eval "$(starship init zsh)"
eval "$(zoxide init zsh --cmd z)"

# Avoid Ctrl+s terminal flow-control conflicts with tmux.
bindkey -r '^S'
stty -ixon
