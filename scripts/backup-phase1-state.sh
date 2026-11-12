#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT/terraform/local"
if ! terraform state list >/dev/null 2>&1; then
  echo 'ERROR: Terraform state unavailable; do not proceed with migration.' >&2
  exit 1
fi
mkdir -p "$ROOT/backups"
name="$ROOT/backups/phase1-state-$(date +%Y%m%d-%H%M%S).tfstate"
terraform state pull > "$name"
chmod 600 "$name"
echo "Saved private state backup: $name"
echo 'Never commit or share this file; it may contain sensitive values.'
