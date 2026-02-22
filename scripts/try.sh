#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
KEEP_PROFILE=0

if [[ "${1:-}" == "--keep" ]]; then
    KEEP_PROFILE=1
    shift
fi

if ! command -v nvim >/dev/null 2>&1; then
    echo "nvim is not installed or not on PATH."
    exit 1
fi

PROFILE_DIR="$(mktemp -d "${TMPDIR:-/tmp}/nvim-try.XXXXXX")"
export XDG_CONFIG_HOME="${PROFILE_DIR}/config"
export XDG_DATA_HOME="${PROFILE_DIR}/data"
export XDG_STATE_HOME="${PROFILE_DIR}/state"
export XDG_CACHE_HOME="${PROFILE_DIR}/cache"

mkdir -p "${XDG_CONFIG_HOME}" "${XDG_DATA_HOME}" "${XDG_STATE_HOME}" "${XDG_CACHE_HOME}"
ln -s "${ROOT_DIR}" "${XDG_CONFIG_HOME}/nvim"

cleanup() {
    if [[ ${KEEP_PROFILE} -eq 0 ]]; then
        rm -rf "${PROFILE_DIR}"
    else
        echo "Kept temp profile at: ${PROFILE_DIR}"
    fi
}
trap cleanup EXIT

exec nvim "$@"
