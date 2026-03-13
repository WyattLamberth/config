# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# History settings
HISTCONTROL=ignoreboth
shopt -s histappend
#HISTSIZE=1000
#HISTFILESIZE=2000
shopt -s checkwinsize

# Make less more friendly for non-text input files
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Set chroot prompt variable
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# Enable color support
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# Load bash completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Load local environment if it exists
if [ -f "$HOME/.local/bin/env" ]; then
  . "$HOME/.local/bin/env"
fi

# Load bash aliases
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# Load Cargo environment
if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi

#########################################
# CUSTOM CONFIGURATION
#########################################

# Environment Variables
export DOCKER_BUILDKIT=1
export PYTHONPATH="/usr/local/lib/python3.12/dist-packages/"
# Add directories to PATH (avoiding duplicates)
for dir in "$HOME/.local/bin" "/usr/local/go/bin"; do
  if [[ ":$PATH:" != *":$dir:"* ]]; then
    export PATH="$dir:$PATH"
  fi
done

# Tool Initializations
command -v zoxide >/dev/null && eval "$(zoxide init bash)"
command -v starship >/dev/null && eval "$(starship init bash)"

# FZF Configuration
if command -v fzf >/dev/null; then
  export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border \
    --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
    --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
    --color=selected-bg:#45475a \
    --color=border:#313244,label:#cdd6f4"

  # Load FZF key bindings and completion (check multiple locations)
  for fzf_script in /usr/share/fzf/key-bindings.bash /usr/share/doc/fzf/examples/key-bindings.bash; do
    [ -f "$fzf_script" ] && source "$fzf_script" && break
  done

  for fzf_completion in /usr/share/fzf/completion.bash /usr/share/doc/fzf/examples/completion.bash; do
    [ -f "$fzf_completion" ] && source "$fzf_completion" && break
  done
fi

# Aliases
alias source-venv='source .venv/bin/activate'
alias wm='work-mount'
alias t='task'
alias reload='source ~/.bashrc'
alias find='fd-find'

# Tool-specific aliases (only if tools are installed)
command -v bat >/dev/null && alias cat='bat' || { command -v batcat >/dev/null && alias cat='batcat'; }
command -v eza >/dev/null && {
  alias ls='eza -l --icons --git --no-permissions --no-user --no-filesize'
  alias ll='eza --long --header --icons --git'
  alias la='eza --all --icons --git'
  alias lt='eza --tree --level=2 --icons --git'
} || {
  alias ls='ls --color=auto'
  alias ll='ls -alF'
  alias la='ls -A'
}

command -v rg >/dev/null && alias grep='rg' || {
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
}

command -v fdfind >/dev/null && alias find='fdfind'
command -v zoxide >/dev/null && alias cd='z'

alias bert='ssh -L3399:127.0.0.1:3389 sklk@192.168.48.14'
alias ems='ssh -vvv -L 4443:10.64.3.31:443 sklk@192.168.48.11'
alias node1='ssh sklk@192.168.48.11'
alias node2='ssh sklk@192.168.48.12'
alias node3='ssh sklk@192.168.48.13'
alias claude='claude --dangerously-skip-permissions'
alias fast-copy='rsync -av --no-compress --progress -e "ssh -c aes128-gcm@openssh.com"'

####### claude code observability
export CLAUDE_CODE_ENABLE_TELEMETRY=1

# Configure exporters
export OTEL_METRICS_EXPORTER=otlp
export OTEL_LOGS_EXPORTER=otlp

# Set OTLP endpoint
export OTEL_EXPORTER_OTLP_PROTOCOL=grpc
export OTEL_EXPORTER_OTLP_ENDPOINT=http://10.64.3.238:4317

# Source - https://stackoverflow.com/a
# Posted by fotinakis, modified by community. See post 'Timeline' for change history
# Retrieved 2025-12-09, License - CC BY-SA 4.0

# Eternal bash history.
# ---------------------
# Undocumented feature which sets the size to "unlimited".
# http://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "
# Change the file location because certain bash sessions truncate .bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
export HISTFILE=~/.bash_eternal_history
# Force prompt to write history after every command.
# http://superuser.com/questions/20900/bash-history-loss
PROMPT_COMMAND="printf '\033]7;file://%s%s\033\\' \"\$HOSTNAME\" \"\$PWD\"; history -a; $PROMPT_COMMAND"
export OLLAMA_PLACEHOLDER="unused"

export EDITOR="nvim"

alias claude="/home/wyatt.lamberth/.claude/local/claude"

# opencode
export PATH=/home/wyatt.lamberth/.opencode/bin:$PATH
