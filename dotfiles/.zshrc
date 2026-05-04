# Basic terminal configuration
export TERM=xterm-256color

# Basic zsh configuration
autoload -Uz compinit
compinit

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# Enable prompt expansion
setopt PROMPT_SUBST


# NVM configuration
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# Aliases
alias dc='docker-compose'
alias ls='colorls --dark --sort-dirs --report'
alias lc='colorls --tree --dark'
alias cat='bat --style=plain'
alias ll='colorls -l --dark --sort-dirs --report'
alias la='colorls -la --dark --sort-dirs --report'
alias clear='command clear'  # Use the default clear command

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/michal/.lmstudio/bin"

# Source local environment if it exists
if [ -f "$HOME/.local/bin/env" ]; then
  . "$HOME/.local/bin/env"
fi

# ~/.zshrc

# Source plugins manually if you have them installed
if [ -f "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

if [ -f "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

eval "$(starship init zsh)"
# Android SDK
export ANDROID_HOME=/Users/michal/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

# Android SDK
export ANDROID_HOME=/Users/michal/Library/Android/sdk
export ANDROID_SDK_ROOT=/Users/michal/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH="$HOME/.local/bin:$PATH"
alias cursor="cursor-agent"
alias container-shell='container run --remove --interactive --tty --entrypoint=/bin/bash --volume /Users/michal:/mnt --name Mac-wZJnU7 --workdir /mnt'
alias kali='container run --remove --interactive --tty --entrypoint=/bin/bash --volume ~/Desktop/kali:/shared --name "$(hostname -s)-kali-$(mktemp -u XXXXXX)" --workdir /shared my-kali'
alias z='__zoxide_z'
eval "$(zoxide init zsh --cmd z)"
alias lullify='tmux new-session -s lullify -c ~/Desktop/lullify \; send-keys "claude" C-m \; split-window -h -c ~/Desktop/lullify/mobile \; send-keys "npx expo start --clear" C-m \; split-window -v -c ~/Desktop/lullify \; send-keys "ssh ubuntu@176.31.247.228" C-m \; select-pane -t 0 \; split-window -v -c ~/Desktop/lullify/api \; send-keys "dc up -d --build" C-m \; select-pane -t 0 \; resize-pane -y 66% \; select-pane -t 0'
alias dzoby='tmux new-session -s dzoby -c ~/Desktop/dzoby \; split-window -h -c ~/Desktop/dzoby \; split-window -v -t 0 -c ~/Desktop/dzoby \; split-window -v -t 2 -c ~/Desktop/dzoby \; split-window -v -t 3 -c ~/Desktop/dzoby \; send-keys -t 0 "claude" C-m \; send-keys -t 1 "gemini" C-m \; send-keys -t 2 "docker compose up -d --build && docker compose logs -f" C-m \; send-keys -t 3 "sleep 10 && npx prisma studio" C-m \; select-pane -t 4'

# Disable Ctrl+s for forward search (needed for tmux)
bindkey -r '^S'

# Disable flow control (Ctrl+s/Ctrl+q)
stty -ixon

# Added by Antigravity
export PATH="/Users/michal/.antigravity/antigravity/bin:$PATH"
alias dzoby-ssh='ssh ubuntu@54.37.139.42'

export PATH="/Users/michal/.pixi/bin:$PATH"

