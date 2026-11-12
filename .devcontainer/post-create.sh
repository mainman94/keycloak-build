#!/usr/bin/env bash
# Provision the dev container: install mise, let it install the toolchain
# pinned in mise.toml, then set up the git hook.
set -euo pipefail

echo "==> installing mise"
curl -fsSL https://mise.run | sh
export PATH="$HOME/.local/bin:$PATH"

for shell in bash zsh; do
  rc="$HOME/.${shell}rc"
  [ -f "$rc" ] || continue
  grep -q "mise activate" "$rc" || echo "eval \"\$(mise activate $shell)\"" >> "$rc"
done

cd "$(dirname "${BASH_SOURCE[0]}")/.."
mise trust
mise install

echo "==> installing the git hook"
mise exec -- prek install
mise exec -- prek prepare-hooks

echo "keycloak-build dev container ready: make help"
