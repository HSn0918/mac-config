#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

info()    { printf "\033[34m[INFO]\033[0m  %s\n" "$*"; }
success() { printf "\033[32m[OK]\033[0m    %s\n" "$*"; }
warn()    { printf "\033[33m[WARN]\033[0m  %s\n" "$*"; }
error()   { printf "\033[31m[ERR]\033[0m   %s\n" "$*"; exit 1; }

# ── Homebrew ──────────────────────────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
success "Homebrew ready"

# ── Ghostty ───────────────────────────────────────────────────────────────────
if [ ! -d "/Applications/Ghostty.app" ]; then
  info "Downloading Ghostty..."
  GHOSTTY_URL="https://release.files.ghostty.org/1.3.1/Ghostty.dmg"
  TMP_DMG="/tmp/Ghostty.dmg"
  curl -L -o "$TMP_DMG" "$GHOSTTY_URL"
  info "Mounting Ghostty.dmg..."
  hdiutil attach "$TMP_DMG" -mountpoint /Volumes/Ghostty -quiet
  cp -R /Volumes/Ghostty/Ghostty.app /Applications/
  hdiutil detach /Volumes/Ghostty -quiet
  rm "$TMP_DMG"
  success "Ghostty installed"
else
  info "Ghostty already installed"
fi

# ── Fish + CLI tools ──────────────────────────────────────────────────────────
PACKAGES=(fish starship eza fd ripgrep fzf autojump neovim nvm)
for pkg in "${PACKAGES[@]}"; do
  if ! brew list "$pkg" &>/dev/null; then
    info "Installing $pkg..."
    brew install "$pkg"
  else
    info "$pkg already installed"
  fi
done
success "Packages ready"

# ── Fish config ───────────────────────────────────────────────────────────────
FISH_DIR="$HOME/.config/fish"
mkdir -p "$FISH_DIR/conf.d" "$FISH_DIR/functions" "$FISH_DIR/completions"
cp "$REPO_DIR/fish/config.fish" "$FISH_DIR/config.fish"
success "Fish config installed"

# ── Starship config ───────────────────────────────────────────────────────────
mkdir -p "$HOME/.config"
cp "$REPO_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
success "Starship config installed"

# ── Ghostty config ────────────────────────────────────────────────────────────
GHOSTTY_CFG_DIR="$HOME/Library/Application Support/com.mitchellh.ghostty"
mkdir -p "$GHOSTTY_CFG_DIR"
cp "$REPO_DIR/ghostty/config.ghostty" "$GHOSTTY_CFG_DIR/config.ghostty"
success "Ghostty config installed (Catppuccin Mocha + Flamingo)"

# ── Set fish as default shell ─────────────────────────────────────────────────
FISH_PATH="$(brew --prefix)/bin/fish"
if ! grep -qF "$FISH_PATH" /etc/shells; then
  info "Adding fish to /etc/shells (requires sudo)..."
  echo "$FISH_PATH" | sudo tee -a /etc/shells
fi
if [[ "$SHELL" != "$FISH_PATH" ]]; then
  info "Setting fish as default shell..."
  chsh -s "$FISH_PATH"
  success "Default shell → fish"
else
  info "fish is already the default shell"
fi

# ── Register Ghostty for terminal URL schemes ─────────────────────────────────
if [ -d "/Applications/Ghostty.app" ]; then
  info "Registering Ghostty for terminal URL schemes..."
  /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister \
    -f /Applications/Ghostty.app 2>/dev/null || true

  python3 - <<'PYEOF'
import subprocess, plistlib

result = subprocess.run(
    ["defaults", "export", "com.apple.LaunchServices/com.apple.launchservices.secure", "-"],
    capture_output=True
)
data = plistlib.loads(result.stdout)
handlers = data.get("LSHandlers", [])

schemes = {"x-man-page", "ssh", "telnet"}
handlers = [h for h in handlers if h.get("LSHandlerURLScheme") not in schemes]
for scheme in schemes:
    handlers.append({
        "LSHandlerURLScheme": scheme,
        "LSHandlerRoleAll": "com.mitchellh.ghostty",
        "LSHandlerPreferredVersions": {"LSHandlerRoleAll": "-"},
    })
data["LSHandlers"] = handlers

tmp = "/tmp/ls_handlers.plist"
with open(tmp, "wb") as f:
    plistlib.dump(data, f)
subprocess.run(
    ["defaults", "import", "com.apple.LaunchServices/com.apple.launchservices.secure", tmp],
    check=True
)
PYEOF

  success "Ghostty registered for ssh/telnet/x-man-page"
  warn "Open Ghostty → Settings → 'Make Ghostty Default Terminal' to finish"
fi

# ── VSCode config ─────────────────────────────────────────────────────────────
VSCODE_CFG_DIR="$HOME/Library/Application Support/Code/User"
if [ -d "$VSCODE_CFG_DIR" ]; then
  cp "$REPO_DIR/vscode/settings.json" "$VSCODE_CFG_DIR/settings.json"
  success "VSCode config installed (default terminal → fish)"
else
  warn "VSCode not found, skipping"
fi

echo ""
success "All done! Open Ghostty and enjoy 🎉"
echo "  Tip: restart your shell or run: exec fish"
