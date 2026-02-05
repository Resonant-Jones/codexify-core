#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

print() {
  printf '%s\n' "$*"
}

printerr() {
  printf '%s\n' "$*" >&2
}

usage() {
  cat <<'EOF'
Usage:
  doctor.sh                 # detect repo + frontend root, print guidance
  doctor.sh rg <pattern>    # run rg within detected frontend root
  doctor.sh devtools        # print DevTools sourcemap hint

Notes:
  - Run from anywhere inside the repo; doctor will also try to locate the repo via this script's path.
EOF
}

detect_frontend_root() {
  local dir="$1"

  if [ -d "$dir/frontend/src" ]; then
    print "frontend"
    return 0
  fi

  if [ -d "$dir/ui/src" ]; then
    print "ui"
    return 0
  fi

  if [ -d "$dir/web/src" ]; then
    print "web"
    return 0
  fi

  if [ -d "$dir/app/src" ]; then
    print "app"
    return 0
  fi

  local path
  local parent
  for path in "$dir"/*/src; do
    [ -d "$path" ] || continue
    parent="${path%/src}"
    if [ -f "$parent/package.json" ]; then
      print "${parent#"$dir"/}"
      return 0
    fi
  done

  return 1
}

is_repo_root() {
  local dir="$1"

  if [ ! -f "$dir/README.md" ]; then
    return 1
  fi

  if ! grep -q "Codexify" "$dir/README.md" 2>/dev/null; then
    return 1
  fi

  if [ ! -f "$dir/docker-compose.yml" ] && [ ! -f "$dir/compose.yml" ]; then
    return 1
  fi

  if [ ! -d "$dir/backend" ] && [ ! -d "$dir/guardian" ]; then
    return 1
  fi

  if ! detect_frontend_root "$dir" >/dev/null 2>&1; then
    return 1
  fi

  return 0
}

find_repo_root_from_pwd() {
  local dir="$1"
  while [ -n "$dir" ] && [ "$dir" != "/" ]; do
    if is_repo_root "$dir"; then
      print "$dir"
      return 0
    fi
    dir="$(cd "$dir/.." && pwd)"
  done
  return 1
}

find_repo_root_from_script() {
  # scripts/dev/doctor.sh -> repo root is two levels up
  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  local candidate
  candidate="$(cd "$script_dir/../.." && pwd)"
  if is_repo_root "$candidate"; then
    print "$candidate"
    return 0
  fi
  return 1
}

current_dir="$(pwd)"
cmd="${1:-}";

if [ "$cmd" = "-h" ] || [ "$cmd" = "--help" ]; then
  usage
  exit 0
fi

repo_root=""
if repo_root="$(find_repo_root_from_pwd "$current_dir" 2>/dev/null)"; then
  :
elif repo_root="$(find_repo_root_from_script 2>/dev/null)"; then
  :
fi

if [ -n "$repo_root" ]; then
  frontend_root="$(detect_frontend_root "$repo_root")"

  case "$cmd" in
    "")
      print "Codexify repo root detected: $repo_root"
      print "Frontend root: ${frontend_root}/"
      print ""
      print "rg commands to locate utils.js:306 source:"
      print "  rg --fixed-strings \"[guardian] failed to load threads\" \"$frontend_root\""
      print "  rg --fixed-strings \"[documents] failed to load backend documents\" \"$frontend_root\""
      print "  rg --fixed-strings \"[codex] failed to load entries\" \"$frontend_root\""
      print "  rg \"Object\\.keys\\(\" \"$frontend_root\""
      print ""
      print "DevTools reminder: Sources -> Cmd+P -> utils.js -> line 306 (sourcemapped origin)."
      exit 0
      ;;
    rg)
      shift || true
      if [ $# -lt 1 ]; then
        printerr "error: doctor.sh rg requires a pattern"
        printerr "Try: doctor.sh rg 'Object\\.keys\\('"
        exit 2
      fi
      (cd "$repo_root" && rg "$@" "$frontend_root")
      exit $?
      ;;
    devtools)
      print "DevTools reminder: Sources -> Cmd+P -> utils.js -> line 306 (sourcemapped origin)."
      exit 0
      ;;
    *)
      printerr "error: unknown command: $cmd"
      usage
      exit 2
      ;;
  esac
fi

printerr "error: could not locate Codexify repo root."
printerr "current directory: $current_dir"
printerr ""
printerr "Tried:"
printerr "  - walking up from current directory"
printerr "  - deriving from this script path"
printerr ""
printerr "Likely repo locations (checked in order):"

suggested_dir=""
script_hint=""
if script_hint="$(find_repo_root_from_script 2>/dev/null)"; then
  suggested_dir="$script_hint"
fi

for candidate in "$suggested_dir" "$HOME/Codexify" "$HOME/code/Codexify" "$HOME/Projects/Codexify"; do
  [ -n "$candidate" ] || continue
  printerr "  $candidate"
  if [ -z "$suggested_dir" ] && is_repo_root "$candidate"; then
    suggested_dir="$candidate"
  fi
done

printerr ""
if [ -n "$suggested_dir" ]; then
  printerr "Likely repo directory: $suggested_dir"
  printerr "Try:"
  printerr "  cd \"$suggested_dir\""
  printerr "  bash scripts/dev/doctor.sh"
else
  printerr "No likely repo directory found."
  printerr "If your repo lives elsewhere, cd into it and re-run:"
  printerr "  bash scripts/dev/doctor.sh"
fi

exit 2
