# ~/.zshrc - Zsh configuration with starship, bat, zoxide, and eza

# ============================================================================
# Eternal Zsh History Configuration
# ============================================================================
# Unlimited history - undocumented feature that sets size to "unlimited"
# Similar to bash eternal history setup
export HISTSIZE=10000000000
export SAVEHIST=10000000000

# Use a separate eternal history file to avoid truncation issues
export HISTFILE=~/.zsh_eternal_history

# Add timestamp format to history entries
# This will show timestamps in format: [YYYY-MM-DD HH:MM:SS]
setopt EXTENDED_HISTORY        # Write the history file in the ':start:elapsed;command' format

# History options for better management
setopt SHARE_HISTORY           # Share history between all sessions
setopt HIST_IGNORE_ALL_DUPS    # Delete old recorded entry if new entry is a duplicate
setopt HIST_FIND_NO_DUPS       # Don't display duplicates when searching
setopt HIST_REDUCE_BLANKS      # Remove superfluous blanks before recording entry
setopt HIST_VERIFY             # Don't execute immediately upon history expansion
setopt INC_APPEND_HISTORY      # Write to history file immediately, not when shell exits

# Note: Each command is written immediately after it's run.
# If you accidentally paste a password, you cannot just kill the process to avoid
# the history write - you'll need to remove it manually from the history file.

# ============================================================================
# Basic Zsh Options
# ============================================================================
setopt AUTO_CD              # cd by typing directory name if it's not a command
setopt AUTO_PUSHD          # Make cd push old directory onto directory stack
setopt PUSHD_IGNORE_DUPS   # Don't push multiple copies of same directory
setopt CORRECT             # Spell correction for commands
setopt INTERACTIVE_COMMENTS # Allow comments in interactive shell

# ============================================================================
# Completion System
# ============================================================================
autoload -Uz compinit
compinit

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Use menu selection for completion
zstyle ':completion:*' menu select

# Better completion for kill command
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always

# ============================================================================
# Starship Prompt
# ============================================================================
eval "$(starship init zsh)"

# ============================================================================
# Zoxide - Smart cd replacement
# ============================================================================
eval "$(zoxide init zsh)"

# ============================================================================
# Eza - Modern ls replacement
# ============================================================================
# Basic aliases
alias ls='eza --icons'
alias ll='eza -l --icons --git'
alias la='eza -la --icons --git'
alias lt='eza --tree --icons --level=2'
alias l='eza -lbF --git --icons'

# More detailed eza aliases
alias llt='eza -l --icons --git --tree --level=2'
alias llta='eza -la --icons --git --tree --level=2'

# ============================================================================
# Bat - Better cat with syntax highlighting
# ============================================================================
alias cat='bat'
alias catp='bat --style=plain'  # bat without line numbers and git info
alias bathelp='bat --list-themes'

# Set bat theme (you can change this to your preference)
export BAT_THEME="Monokai Extended"

# ============================================================================
# Additional Useful Aliases
# ============================================================================
# Navigation shortcuts using zoxide
alias cd='z'

# Git aliases (if you use git)
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'

# Directory aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Safety aliases
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# System aliases
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h'
alias free='free -h'

# ============================================================================
# Environment Variables
# ============================================================================
# Set default editor (change to your preference)
export EDITOR='vim'
export VISUAL='vim'

# Add local bin to PATH if it exists
if [ -d "$HOME/.local/bin" ]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# ============================================================================
# Functions
# ============================================================================
# Make directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract various archive formats
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# ============================================================================
# Key Bindings
# ============================================================================
# Use vim key bindings (optional - comment out if you prefer emacs mode)
# bindkey -v

# Use Ctrl+R for history search (works in both emacs and vi mode)
bindkey '^R' history-incremental-search-backward

# ============================================================================
# Welcome Message (optional)
# ============================================================================
# Uncomment to show system info on terminal start
# echo "Welcome to $(hostname)!"
# echo "Uptime: $(uptime -p)"
