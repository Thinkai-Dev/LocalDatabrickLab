#!/usr/bin/env bash
set -euo pipefail
check() {
  local label="$1"; shift
  if "$@" >/dev/null 2>&1; then echo "PASS $label"; else echo "FAIL $label"; return 1; fi
}
check "Git" git --version
check "Python 3" python3 --version
check "Terraform" terraform version
check "AWS CLI" aws --version
check "Docker CLI" docker --version
check "Docker Compose" docker compose version
check "Docker engine" docker info
check "Docker hello-world" docker run --rm hello-world
printf '\nToolchain and Docker are ready.\n'
