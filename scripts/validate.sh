#!/bin/sh
set -eu

PASS_COUNT=0
FAIL_COUNT=0

pass() {
  PASS_COUNT=$((PASS_COUNT + 1))
  printf 'PASS: %s\n' "$1"
}

fail() {
  FAIL_COUNT=$((FAIL_COUNT + 1))
  printf 'FAIL: %s\n' "$1"
}

have_cmd() {
  command -v "$1" >/dev/null 2>&1
}

check_required_files() {
  missing=""
  for path in \
    README.md \
    SPEC.md \
    VALUES.md \
    start.sh \
    bootstrap.py \
    requirements.txt \
    docker-compose.yml \
    .env.example \
    validate.sh \
    smoke.sh \
    .gitignore \
    archive/README.md \
    archive/docker/README.md \
    archive/docker/docker-compose.two-container.yml \
    archive/docker/docker-compose.three-container.yml \
    docs/gion-local-core-v26.md
  do
    if [ ! -f "$path" ]; then
      missing="$missing $path"
    fi
  done

  if [ -n "$missing" ]; then
    fail "required files are missing:$missing"
  else
    pass "all required files exist"
  fi
}

check_python_syntax() {
  if ! have_cmd python3; then
    fail "python3 is required"
    return
  fi

  if python3 -m py_compile bootstrap.py; then
    pass "Python syntax check passed"
  else
    fail "Python syntax check failed"
  fi
}

check_compose_render() {
  if ! have_cmd docker || ! docker compose version >/dev/null 2>&1; then
    fail "docker compose is required"
    return
  fi

  if docker compose -f docker-compose.yml config >/dev/null; then
    pass "docker-compose.yml renders successfully"
  else
    fail "docker-compose.yml does not render"
  fi
}

check_archive_boundary() {
  root_variants=$(find . -maxdepth 1 -name 'docker-compose.*.yml' -print | sort | tr '\n' ' ')
  if [ -n "$root_variants" ]; then
    fail "root contains non-canonical compose variants: $root_variants"
  else
    pass "root contains only canonical docker-compose.yml"
  fi
}

check_wrappers() {
  if [ -x validate.sh ] && [ -x smoke.sh ]; then
    pass "root wrappers are executable"
  else
    fail "root wrappers must be executable"
  fi
}

check_required_files
check_python_syntax
check_compose_render
check_archive_boundary
check_wrappers

printf '\nValidation summary\n'
printf '==================\n'
printf 'PASS: %s\n' "$PASS_COUNT"
printf 'FAIL: %s\n' "$FAIL_COUNT"

if [ "$FAIL_COUNT" -gt 0 ]; then
  printf '\nFAIL\n'
  exit 1
fi

printf '\nPASS\n'
