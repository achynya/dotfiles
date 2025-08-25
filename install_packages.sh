#!/bin/bash
set -e

# ------------------------------
# Arch Install Script
# Installs repo + AUR packages
# Bootstraps yay if missing
# ------------------------------

# === System & Base ===
repo_system=(
  base base-devel linux linux-firmware
  efibootmgr grub os-prober
  zram-generator sof-firmware intel-ucode
)

# === Desktop & UI ===
repo_desktop=(
  hyprland waybar rofi sddm swaybg dunst slurp grim feh
  blueman bluez bluez-utils bluez-deprecated-tools
  brightnessctl networkmanager network-manager-applet nm-connection-editor
  wireplumber pipewire pipewire-alsa pipewire-pulse pipewire-jack pavucontrol
  wl-clipboard xclip xsel
)

# === Fonts ===
repo_fonts=(
  ttf-firacode-nerd ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols
)

# === Terminal & CLI Tools ===
repo_cli=(
  zsh vim neovim tmux htop btop calc jq wget fastfetch git github-cli
)

# === File Managers & Utils ===
repo_utils=(
  thunar thunar-volman gvfs gvfs-mtp gvfs-gphoto2 copyq
  dosfstools mtools mousepad libreoffice-fresh
)

# === Dev & Programming ===
repo_dev=(
  code zed postgresql python-pillow jre-openjdk
)

# === Multimedia & Communication ===
repo_apps=(
  firefox telegram-desktop spotify-launcher steam prismlauncher
)

# === Creative Tools (added by request) ===
repo_creative=(
  gimp kdenlive audacity krita inkscape blender
)

# === AUR packages ===
aur_pkgs=(
  balena-etcher onlyoffice-bin yay
)

# === Helper functions ===
install_repos() {
  echo "[*] Installing repo packages..."
  sudo pacman -Syu --needed --noconfirm \
    "${repo_system[@]}" \
    "${repo_desktop[@]}" \
    "${repo_fonts[@]}" \
    "${repo_cli[@]}" \
    "${repo_utils[@]}" \
    "${repo_dev[@]}" \
    "${repo_apps[@]}" \
    "${repo_creative[@]}"
}

install_yay() {
  echo "[*] Bootstrapping yay from source..."
  sudo pacman -S --needed --noconfirm git base-devel
  tmpdir=$(mktemp -d)
  pushd "$tmpdir"
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
  popd
  rm -rf "$tmpdir"
}

install_aur() {
  echo "[*] Installing AUR packages..."
  if command -v yay >/dev/null 2>&1; then
    yay -S --needed --noconfirm "${aur_pkgs[@]}"
  else
    install_yay
    yay -S --needed --noconfirm "${aur_pkgs[@]}"
  fi
}

# === Main ===
install_repos
install_aur

echo "[*] All done!"

