#!/bin/bash
set -e

# =====================================================
# Master Setup Script for Arch + Hyprland system
# -----------------------------------------------------
# - Enables multilib repo in pacman.conf
# - Installs repo + AUR packages (via install_packages.sh)
# - Ensures NetworkManager + SDDM are installed + enabled
# - Sets up dotfiles configs
# - Copies wallpapers
# - Fixes permissions on scripts
# =====================================================

# === Paths  ===
DOTFILES="$HOME/dotfiles"                # your dotfiles repo location
SCRIPTS="$HOME/.config/hypr/scripts"     # where scripts are stored
WALLPAPERS_SRC="$DOTFILES/wallpapers"    # wallpapers inside your dotfiles
WALLPAPERS_DST="$HOME/Pictures/Wallpapers"

# -----------------------------------------------------
# STEP 0: Enable multilib if not already
# -----------------------------------------------------
echo "[*] Checking for multilib in pacman.conf..."
if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
  echo "[*] Enabling multilib repository..."
  sudo sed -i '/#\[multilib\]/,/#Include/s/^#//' /etc/pacman.conf
  sudo pacman -Sy
fi

# -----------------------------------------------------
# STEP 1: Install packages
# -----------------------------------------------------
echo "[*] Running package installation script..."
bash "$SCRIPTS/install_packages.sh"

# -----------------------------------------------------
# STEP 2: Ensure NetworkManager
# -----------------------------------------------------
echo "[*] Installing & enabling NetworkManager..."
sudo pacman -S --needed --noconfirm networkmanager
sudo systemctl enable --now NetworkManager

# -----------------------------------------------------
# STEP 3: Ensure SDDM
# -----------------------------------------------------
echo "[*] Installing & enabling SDDM..."
sudo pacman -S --needed --noconfirm sddm
sudo systemctl enable sddm.service

# -----------------------------------------------------
# STEP 4: Deploy dotfiles configs
# -----------------------------------------------------
echo "[*] Copying configs into ~/.config/ ..."
mkdir -p "$HOME/.config"

cp -r "$DOTFILES/hyprland" "$HOME/.config/hypr"
cp -r "$DOTFILES/nvim"     "$HOME/.config/nvim"
cp -r "$DOTFILES/waybar"   "$HOME/.config/waybar"
cp -r "$DOTFILES/rofi"     "$HOME/.config/rofi"
cp -r "$DOTFILES/kitty"    "$HOME/.config/kitty"
cp -r "$DOTFILES/zsh/."    "$HOME"

# -----------------------------------------------------
# STEP 5: Wallpapers
# -----------------------------------------------------
echo "[*] Setting up wallpapers..."
mkdir -p "$WALLPAPERS_DST"
cp -r "$WALLPAPERS_SRC/"* "$WALLPAPERS_DST/"

# -----------------------------------------------------
# STEP 7: Zsh Plugins and Theme
# -----------------------------------------------------
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions \
    ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# -----------------------------------------------------
# STEP 8: Vim-Plug
# -----------------------------------------------------
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
# -----------------------------------------------------
# STEP 9: Fix script permissions
# -----------------------------------------------------
echo "[*] Making scripts executable..."
chmod +x "$SCRIPTS/"*.sh

# -----------------------------------------------------
# STEP 9: Final notes
# -----------------------------------------------------
echo "==================================================="
echo "[*] Setup complete!"
echo " - Multilib enabled"
echo " - NetworkManager installed & running"
echo " - SDDM installed & enabled"
echo " - Configs copied to ~/.config/"
echo " - Wallpapers in ~/Pictures/Wallpapers"
echo " - Scripts in $SCRIPTS made executable"
echo "==================================================="

