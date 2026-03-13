#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Vendored tool names and the commands they provide
VENDORED_TOOLS=(bat eza fd rg fzf zoxide starship lazygit glab)

install_apt_packages() {
    if ! command -v apt-get &>/dev/null; then
        log_warn "apt not found, skipping system package install"
        return 1
    fi

    log_info "Installing packages via apt..."
    sudo apt-get update
    sudo apt-get install -y \
        git \
        curl \
        wget \
        unzip \
        build-essential \
        cmake \
        python3 \
        python3-pip \
        python3-venv \
        nodejs \
        npm \
        tmux \
        ripgrep \
        fd-find \
        fzf \
        bat \
        eza \
        zoxide \
        rsync \
        p7zip-full \
        unrar \
        bash-completion \
        bc
    log_success "apt packages installed"
}

install_vendored_bins() {
    log_info "Installing vendored binaries to ~/.local/bin ..."
    mkdir -p "$HOME/.local/bin"

    for tool in "${VENDORED_TOOLS[@]}"; do
        # Check if already available on PATH
        if command -v "$tool" &>/dev/null; then
            log_info "$tool already installed ($(command -v "$tool"))"
            continue
        fi

        # Special case: fd-find installs as fdfind on Debian/Ubuntu
        if [[ "$tool" == "fd" ]] && command -v fdfind &>/dev/null; then
            log_info "fd already installed as fdfind"
            continue
        fi

        # Special case: bat installs as batcat on Debian/Ubuntu
        if [[ "$tool" == "bat" ]] && command -v batcat &>/dev/null; then
            log_info "bat already installed as batcat, installing vendored version for consistent naming"
        fi

        local src="$CONFIG_DIR/bin/$tool"
        if [[ -f "$src" ]]; then
            cp "$src" "$HOME/.local/bin/$tool"
            chmod +x "$HOME/.local/bin/$tool"
            log_success "Installed $tool -> ~/.local/bin/$tool"
        else
            log_warn "Vendored binary not found: $src"
        fi
    done
}

install_neovim() {
    if command -v nvim &>/dev/null; then
        local version
        version=$(nvim --version | head -n1 | grep -oP 'v\K[0-9]+\.[0-9]+' || echo "0.0")
        if [[ "$(echo "$version >= 0.9" | bc -l 2>/dev/null || echo 0)" == "1" ]]; then
            log_info "neovim >= 0.9 already installed"
            return 0
        fi
    fi

    log_info "Installing neovim..."
    if command -v apt-get &>/dev/null; then
        sudo add-apt-repository -y ppa:neovim-ppa/unstable 2>/dev/null || true
        sudo apt-get update
        sudo apt-get install -y neovim
    else
        log_warn "Cannot install neovim without apt. Install manually."
    fi
}

install_go_task() {
    if command -v task &>/dev/null; then
        log_info "go-task already installed"
        return 0
    fi

    log_info "Installing go-task..."
    sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b "$HOME/.local/bin" 2>/dev/null || \
        log_warn "Failed to install go-task, you may need to install it manually"
}

make_symlink() {
    local source="$1"
    local target="$2"
    local label="$3"

    if [[ -L "$target" ]]; then
        local current_link
        current_link=$(readlink "$target")
        if [[ "$current_link" == "$source" ]]; then
            log_info "$label symlink already correct"
            return 0
        else
            log_warn "$label symlink points elsewhere: $current_link"
            rm "$target"
        fi
    elif [[ -e "$target" ]]; then
        log_warn "Backing up existing $label to $target.backup"
        mv "$target" "$target.backup.$(date +%Y%m%d%H%M%S)"
    fi

    mkdir -p "$(dirname "$target")"
    ln -s "$source" "$target"
    log_success "Created $label symlink: $target -> $source"
}

setup_symlinks() {
    log_info "Setting up symlinks..."

    make_symlink "$CONFIG_DIR/nvim"              "$HOME/.config/nvim"              "nvim"
    make_symlink "$CONFIG_DIR/.bashrc"           "$HOME/.bashrc"                   ".bashrc"
    make_symlink "$CONFIG_DIR/.zshrc"            "$HOME/.zshrc"                    ".zshrc"
    make_symlink "$CONFIG_DIR/.tmux.conf"        "$HOME/.tmux.conf"               ".tmux.conf"
    make_symlink "$CONFIG_DIR/wezterm/wezterm.lua" "$HOME/.wezterm.lua"           ".wezterm.lua"
    make_symlink "$CONFIG_DIR/lazygit/config.yml" "$HOME/.config/lazygit/config.yml" "lazygit"
}

setup_themes() {
    log_info "Setting up themes..."

    # Tmux plugins (git submodules — symlink each into ~/.tmux/plugins/)
    mkdir -p "$HOME/.tmux/plugins"
    for plugin_dir in "$CONFIG_DIR/tmux/plugins/"*/; do
        local plugin_name
        plugin_name=$(basename "$plugin_dir")
        make_symlink "$plugin_dir" "$HOME/.tmux/plugins/$plugin_name" "tmux-plugin:$plugin_name"
    done

    # Bat theme
    mkdir -p "$HOME/.config/bat/themes"
    cp "$CONFIG_DIR/bat/themes/"*.tmTheme "$HOME/.config/bat/themes/"

    # Build bat cache using whichever bat is available
    local bat_cmd=""
    if command -v bat &>/dev/null; then
        bat_cmd="bat"
    elif [[ -x "$HOME/.local/bin/bat" ]]; then
        bat_cmd="$HOME/.local/bin/bat"
    elif [[ -x "$CONFIG_DIR/bin/bat" ]]; then
        bat_cmd="$CONFIG_DIR/bin/bat"
    fi

    if [[ -n "$bat_cmd" ]]; then
        "$bat_cmd" cache --build 2>/dev/null && \
            log_success "Built bat theme cache (Catppuccin Mocha)" || \
            log_warn "Failed to build bat cache"
    else
        log_warn "bat not found, skipping theme cache build"
    fi

    # Delta syntax theme
    git config --global delta.syntax-theme "Catppuccin Mocha"
    log_success "Set delta syntax-theme to Catppuccin Mocha"
}

main() {
    log_info "Starting dotfiles installation..."
    log_info "Config directory: $CONFIG_DIR"

    # Init submodules (tmux plugins)
    log_info "Initializing git submodules..."
    git -C "$CONFIG_DIR" submodule update --init --recursive

    # Try apt first, then fall back to vendored binaries
    install_apt_packages || log_warn "apt install skipped or failed, will rely on vendored binaries"
    install_vendored_bins
    install_neovim
    install_go_task
    setup_symlinks
    setup_themes

    # Install neovim plugins
    log_info "Installing neovim plugins (this may take a moment)..."
    if command -v nvim &>/dev/null; then
        nvim --headless "+Lazy! sync" +qa 2>/dev/null || \
            log_warn "Could not auto-install nvim plugins. Run 'nvim' to install them interactively."
    fi

    echo ""
    log_success "Installation complete!"
    echo ""
    log_info "Summary:"
    echo "  - Core tools installed (git, curl, tmux, build tools, etc.)"
    echo "  - Shell tools: bat, eza, fd, rg, fzf, zoxide, starship, lazygit, glab"
    echo "  - Neovim with LazyVim configuration"
    echo "  - Catppuccin Mocha theme (bat, tmux, delta)"
    echo ""
    log_info "Symlinks created:"
    echo "  - $CONFIG_DIR/nvim           -> ~/.config/nvim"
    echo "  - $CONFIG_DIR/.bashrc        -> ~/.bashrc"
    echo "  - $CONFIG_DIR/.zshrc         -> ~/.zshrc"
    echo "  - $CONFIG_DIR/.tmux.conf     -> ~/.tmux.conf"
    echo "  - $CONFIG_DIR/wezterm        -> ~/.wezterm.lua"
    echo "  - $CONFIG_DIR/lazygit        -> ~/.config/lazygit/config.yml"
    echo ""
    log_info "Themes installed:"
    echo "  - Tmux: catppuccin/tmux (submodules symlinked to ~/.tmux/plugins/)"
    echo "  - Bat:  Catppuccin Mocha"
    echo "  - Delta: Catppuccin Mocha"
    echo ""
    log_info "Next steps:"
    echo "  1. Restart your terminal or run: source ~/.bashrc"
    echo "  2. Open nvim to complete plugin installation"
    echo "  3. In tmux, press prefix + I to initialize plugins"
    echo ""
}

main "$@"
