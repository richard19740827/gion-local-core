#!/bin/sh
# Validate the compact Gion Local Core launcher without task-runner dependencies.
# POSIX shell only; hard requirements are git/python3/curl. Docker Compose checks
# run when Docker is installed and warn when this environment cannot run them.

PASS_COUNT=0
FAIL_COUNT=0
WARN_COUNT=0
FAIL_MESSAGES=""
WARN_MESSAGES=""

pass() {
    PASS_COUNT=$((PASS_COUNT + 1))
    printf 'PASS: %s\n' "$1"
}

fail() {
    FAIL_COUNT=$((FAIL_COUNT + 1))
    printf 'FAIL: %s\n' "$1"
    FAIL_MESSAGES="${FAIL_MESSAGES}
- $1"
}

warn() {
    WARN_COUNT=$((WARN_COUNT + 1))
    printf 'WARN: %s\n' "$1"
    WARN_MESSAGES="${WARN_MESSAGES}
- $1"
}

have_cmd() {
    command -v "$1" >/dev/null 2>&1
}

check_clean_tree() {
    if ! have_cmd git; then
        warn "git is not available; skipping working tree cleanliness check"
        return
    fi

    if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
        warn "git working tree has local changes; this is expected before committing"
    else
        pass "git working tree is clean"
    fi
}

check_required_files() {
    missing=""
    for path in \
        README.md \
        SPEC.md \
        VALUES.md \
        start.sh \
        bootstrap.py \
        docker-compose.yml \
        .env.example \
        validate.sh \
        smoke.sh \
        .gitignore
    do
        if [ ! -f "$path" ]; then
            missing="$missing $path"
        fi
    done

    if [ -n "$missing" ]; then
        fail "required compact-root files are missing:$missing"
    else
        pass "all required compact-root files exist"
    fi
}

check_removed_redundant_paths() {
    redundant=""
    for path in scripts docs archive requirements.txt CHANGELOG.md; do
        if [ -e "$path" ]; then
            redundant="$redundant $path"
        fi
    done

    if [ -n "$redundant" ]; then
        fail "redundant or unused paths should stay removed:$redundant"
    else
        pass "redundant scripts/docs/archive/requirements/changelog paths are absent"
    fi
}

check_required_commands() {
    if have_cmd python3; then
        pass "python3 is available"
    else
        fail "python3 is required"
    fi

    if have_cmd curl; then
        pass "curl is available"
    else
        fail "curl is required"
    fi

    if have_cmd docker && docker compose version >/dev/null 2>&1; then
        pass "docker compose is available"
    else
        warn "docker compose is not available; compose render and smoke runtime checks are environment-limited"
    fi
}

check_python_syntax() {
    if ! have_cmd python3; then
        fail "cannot check Python syntax because python3 is missing"
        return
    fi

    files=""
    for path in server.py bootstrap.py mcp_server.py api/*.py; do
        if [ -f "$path" ]; then
            files="$files $path"
        fi
    done

    if [ -z "$files" ]; then
        fail "no Python files found for syntax check"
        return
    fi

    # shellcheck disable=SC2086 # intentional word splitting over repository file list
    if python3 - $files <<'PYEOF'
import sys

ok = True
for filename in sys.argv[1:]:
    try:
        with open(filename, "rb") as handle:
            source = handle.read()
        compile(source, filename, "exec")
    except SyntaxError as exc:
        ok = False
        print(f"{filename}:{exc.lineno}:{exc.offset}: {exc.msg}", file=sys.stderr)
    except OSError as exc:
        ok = False
        print(f"{filename}: {exc}", file=sys.stderr)

raise SystemExit(0 if ok else 1)
PYEOF
    then
        pass "Python syntax check passed"
    else
        fail "Python syntax check failed"
    fi
}

check_compose_render() {
    if ! have_cmd docker || ! docker compose version >/dev/null 2>&1; then
        warn "cannot render compose YAML because docker compose is unavailable in this environment"
        return
    fi

    if [ ! -f docker-compose.yml ]; then
        fail "docker-compose.yml is missing"
        return
    fi

    if docker compose -f docker-compose.yml config >/dev/null; then
        pass "docker-compose.yml renders successfully"
    else
        fail "docker-compose.yml does not render"
    fi
}

check_duplicate_env() {
    if [ ! -f docker-compose.yml ]; then
        fail "cannot check duplicate env because docker-compose.yml is missing"
        return
    fi

    duplicates=$(
        awk '
            /^[[:space:]]*#/ { next }
            /^[^[:space:]][^:]*:/ {
                if ($1 == "services:") {
                    in_services = 1
                } else if (in_services) {
                    in_services = 0
                    service = ""
                    in_env = 0
                }
                next
            }
            in_services && /^  [^[:space:]#][^:]*:/ {
                line = $0
                sub(/^  /, "", line)
                sub(/:.*/, "", line)
                service = line
                in_env = 0
                next
            }
            service != "" && /^    [^[:space:]#][^:]*:/ {
                line = $0
                sub(/^    /, "", line)
                key = line
                sub(/:.*/, "", key)
                if (key == "environment") {
                    in_env = 1
                } else {
                    in_env = 0
                }
                next
            }
            service != "" && in_env && /^      -[[:space:]]*[A-Za-z_][A-Za-z0-9_]*=/ {
                line = $0
                sub(/^      -[[:space:]]*/, "", line)
                key = line
                sub(/=.*/, "", key)
                id = service ":" key
                if (seen[id] == 1) {
                    print id
                }
                seen[id] = 1
            }
        ' docker-compose.yml | sort -u
    )

    if [ -n "$duplicates" ]; then
        fail "docker-compose.yml has duplicate environment variables: $(printf '%s' "$duplicates" | tr '\n' ' ')"
    else
        pass "docker-compose.yml has no duplicate environment variables"
    fi
}

check_placeholder_password() {
    matches=$(
        awk '
            /^[[:space:]]*#/ { next }
            /HERMES_WEBUI_PASSWORD[[:space:]]*=[[:space:]]*(your-secret-password|change-me|changeme|password|secret|example|placeholder)/ {
                print FILENAME ":" FNR
            }
        ' docker-compose.yml .env.example .env.docker.example 2>/dev/null
    )

    if [ -n "$matches" ]; then
        fail "placeholder HERMES_WEBUI_PASSWORD is enabled: $(printf '%s' "$matches" | tr '\n' ' ')"
    else
        pass "no enabled placeholder HERMES_WEBUI_PASSWORD found"
    fi
}

check_no_root_compose_variants() {
    variants=""

    for path in docker-compose.*.yml docker-compose.*.yaml compose.*.yml compose.*.yaml; do
        case "$path" in
            'docker-compose.*.yml'|'docker-compose.*.yaml'|'compose.*.yml'|'compose.*.yaml')
                continue
                ;;
            docker-compose.yml|compose.yml)
                continue
                ;;
        esac

        if [ -f "$path" ]; then
            variants="${variants} ${path}"
        fi
    done

    if [ -n "$variants" ]; then
        fail "root contains compose variants:${variants}"
    else
        pass "root contains only the canonical compose file"
    fi
}

check_start_uses_bootstrap() {
    if [ ! -f start.sh ]; then
        fail "start.sh is missing"
        return
    fi

    direct_server=$(
        awk '
            /^[[:space:]]*#/ { next }
            /(^|[[:space:]])exec[[:space:]].*server\.py/ { print FNR }
            /(^|[[:space:]])python3?[[:space:]].*server\.py/ { print FNR }
        ' start.sh
    )

    if [ -n "$direct_server" ]; then
        fail "start.sh directly executes server.py at line(s): $(printf '%s' "$direct_server" | tr '\n' ' ')"
        return
    fi

    if awk 'BEGIN { found = 0 } /^[[:space:]]*#/ { next } /bootstrap\.py/ { found = 1 } END { exit found ? 0 : 1 }' start.sh; then
        pass "start.sh launches through bootstrap.py"
    else
        fail "start.sh does not launch through bootstrap.py"
    fi
}

check_repo_path_documentation() {
    if awk '
        /git clone .*hermes-webui/ { bad = 1; print FILENAME ":" FNR }
        END { exit bad ? 0 : 1 }
    ' README.md SPEC.md VALUES.md 2>/dev/null; then
        fail "documentation still tells users to clone hermes-webui instead of gion-local-core"
    else
        pass "documentation names gion-local-core as the launcher/config repo"
    fi

    if awk '
        /HERMES_WEBUI_SOURCE_DIR/ { found = 1 }
        END { exit found ? 0 : 1 }
    ' .env.example README.md SPEC.md; then
        pass "host-side WebUI source override is documented"
    else
        fail "HERMES_WEBUI_SOURCE_DIR is not documented for host-side start.sh use"
    fi
}

check_single_root_entrypoints() {
    for path in validate.sh smoke.sh; do
        if [ ! -x "$path" ]; then
            fail "$path is missing or not executable"
        elif awk 'BEGIN { bad = 0 } /^[[:space:]]*#/ { next } /exec[[:space:]].*scripts\// { bad = 1 } END { exit bad ? 0 : 1 }' "$path"; then
            fail "$path still delegates to removed scripts/ implementation"
        else
            pass "$path is a root-level implementation"
        fi
    done
}

print_summary() {
    printf '\nValidation summary\n'
    printf '==================\n'
    printf 'PASS: %s\n' "$PASS_COUNT"
    printf 'WARN: %s\n' "$WARN_COUNT"
    printf 'FAIL: %s\n' "$FAIL_COUNT"

    if [ "$WARN_COUNT" -gt 0 ]; then
        printf '\nWarnings:%s\n' "$WARN_MESSAGES"
    fi

    if [ "$FAIL_COUNT" -gt 0 ]; then
        printf '\nFailures:%s\n' "$FAIL_MESSAGES"
        printf '\nFAIL\n'
        return 1
    fi

    printf '\nPASS\n'
    return 0
}

check_clean_tree
check_required_files
check_removed_redundant_paths
check_required_commands
check_python_syntax
check_compose_render
check_duplicate_env
check_placeholder_password
check_no_root_compose_variants
check_start_uses_bootstrap
check_repo_path_documentation
check_single_root_entrypoints

print_summary
