#!/usr/bin/env bash
set -e

# --- Configuración SSH para GitHub ---
SSH_DIR="$HOME/.ssh"
KNOWN_HOSTS="$SSH_DIR/known_hosts"
CONFIG_FILE="$SSH_DIR/config"

mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

# Generar clave si no existe
if [ ! -f "$SSH_DIR/id_ed25519" ]; then
  echo "Generando nueva clave SSH..."
  ssh-keygen -t ed25519 -C "vscode-devcontainer" -f "$SSH_DIR/id_ed25519" -N ""
fi

# Añadir GitHub a known_hosts
ssh-keyscan -t rsa github.com >> "$KNOWN_HOSTS" 2>/dev/null
chmod 644 "$KNOWN_HOSTS"

# Crear configuración SSH
cat > "$CONFIG_FILE" <<EOF
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519
  StrictHostKeyChecking accept-new
EOF

chmod 600 "$CONFIG_FILE"

# Mostrar la clave pública para añadir a GitHub
echo "Clave pública SSH para añadir en GitHub (Settings > SSH and GPG keys):"
cat "$SSH_DIR/id_ed25519.pub"

# --- Configuración Git global ---
git config --global user.name "vscode-dev"
git config --global user.email "vscode@example.com"
git config --global core.sshCommand "ssh -i $SSH_DIR/id_ed25519"
git config --global commit.template /workspaces/vscode/.devcontainer/.gitmessage.txt

echo "Configuración SSH y Git completada."
