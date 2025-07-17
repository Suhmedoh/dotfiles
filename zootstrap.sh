#!/bin/sh

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Helper Functions ---

# Prints a message with a green color
log_info() {
  # ANSI Color Codes
  GREEN='\033[0;32m'
  NC='\033[0m' # No Color
  echo -e "${GREEN}[INFO]${NC} $1"
}

# prep stuff
mkdir -p ~/.local/bin

# Set up shell-specific aliases and configuration
setup_shell_config() {
  log_info "Setting up shell configuration..."
  local current_shell
  current_shell=$(basename "$SHELL")
  local alias_file
  local rc_file

  case "$current_shell" in
    bash)
      rc_file="$HOME/.bashrc"
      alias_file="$HOME/.bash_aliases"
      ;;
    zsh)
      rc_file="$HOME/.zshrc"
      alias_file="$HOME/.zsh_aliases"
      ;;
    *)
      echo "Unsupported shell: $current_shell. Please configure aliases manually."
      return 1
      ;;
  esac

  log_info "Detected shell: $current_shell. Configuring $rc_file and $alias_file."

  # 1. Ensure the alias file exists
  touch "$alias_file"

  # 2. Ensure the RC file sources the alias file
  local source_line="[ -f \"$alias_file\" ] && source \"$alias_file\""
  add_line_if_not_exists "$source_line" "$rc_file"

  # 3. Add some aliases to the alias file
  add_line_if_not_exists "alias ll='ls -alF'" "$alias_file"
  add_line_if_not_exists "alias g=git" "$alias_file"
  add_line_if_not_exists "alias tmr='tmux split-window'" "$alias_file"
  add_line_if_not_exists "alias vim='nvim'" "$alias_file"
  add_line_if_not_exists "alias vi='nvim'" "$alias_file"
  add_line_if_not_exists "alias cat='bat'" "$alias_file"
  add_line_if_not_exists "alias ls='exa'" "$alias_file"
  
}

# Adds a line to a file if it doesn't already exist.
#
# @param $1 The line of text to add.
# @param $2 The path to the file.
add_line_if_not_exists() {
  local line_to_add="$1"
  local file_path="$2"

  if [ -z "$line_to_add" ] || [ -z "$file_path" ]; then
    echo "Usage: add_line_if_not_exists <line> <file>"
    return 1
  fi

  # Use grep with -q (quiet), -F (fixed string), and -x (exact match)
  if ! grep -qFx "$line_to_add" "$file_path"; then
    log_info "Adding '$line_to_add' to $file_path"

    # Append the line to the file
    echo "$line_to_add" >> "$file_path"
  else
    log_info "'$line_to_add' already exists in $file_path. Skipping."
  fi
}

# --- Main Logic Functions ---

# Install packages using the system's package manager
install_packages() {
  log_info "Installing essential packages..."
  local packages=("git" "tmux" "curl" "htop" "neovim" "bat" "fzf" ")
  
  if command -v apt-get &> /dev/null; then
    sudo apt-get update
    sudo apt-get install -y "${packages[@]}"
  elif command -v dnf &> /dev/null; then
    sudo dnf install -y "${packages[@]}"
  elif command -v pacman &> /dev/null; then
    sudo pacman -Syu --noconfirm "${packages[@]}"
  else
    echo "Unsupported package manager. Please install packages manually: ${packages[*]}"
    return 1
  fi
}


# download the useful tools

# install bat
sudoapt install bat


main() {
  log_info "Starting bootstrap process..."
  
  install_packages
  clone_repos
  setup_shell_config
  log_info("green")
  log_info "Bootstrap complete! Please restart your shell or run 'source ~/.bashrc' (or ~/.zshrc)."
}

# Run the main function
main
