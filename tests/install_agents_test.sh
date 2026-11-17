#!/usr/bin/env bash
# Exercises install_agents.sh against a throwaway $HOME.
set -u

REPO_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
INSTALLER="${REPO_DIR}/install_agents.sh"
AGENTS_DIR="${REPO_DIR}/agents"
failures=0

function fail() {
    echo "FAIL: $1"
    failures=$((failures + 1))
}

function assert_link() {
    local link=$1 target=$2
    if [ ! -L "${link}" ]; then
        fail "${link} is not a symlink"
    elif [ "$(readlink "${link}")" != "${target}" ]; then
        fail "${link} points to $(readlink "${link}"), want ${target}"
    fi
}

function assert_absent() {
    [ -e "${1}" ] || [ -L "${1}" ] && fail "${1} should not exist"
}

function assert_content() {
    local file=$1 want=$2
    [ "$(cat "${file}" 2>/dev/null)" == "${want}" ] || fail "${file} content is '$(cat "${file}" 2>/dev/null)', want '${want}'"
}

function new_home() {
    local home
    home=$(mktemp -d)
    mkdir -p "${home}/.claude" "${home}/.claude-personal" "${home}/.agents/skills"
    echo "old claude md" > "${home}/.claude-personal/CLAUDE.md"
    echo "${home}"
}

function test_install_links_everything() {
    local home
    home=$(new_home)
    HOME="${home}" "${INSTALLER}" > /dev/null

    assert_link "${home}/AGENTS.md" "${AGENTS_DIR}/AGENTS.md"
    assert_link "${home}/.agents/rules/go.md" "${AGENTS_DIR}/rules/go.md"
    assert_link "${home}/.codex/AGENTS.md" "${AGENTS_DIR}/AGENTS.md"
    for dir in .claude .claude-personal; do
        assert_link "${home}/${dir}/CLAUDE.md" "${AGENTS_DIR}/CLAUDE.md"
        assert_link "${home}/${dir}/rules/go.md" "${AGENTS_DIR}/rules/go.md"
    done
    [ -d "${home}/.agents/skills" ] || fail "existing ~/.agents/skills was disturbed"
    assert_content "${home}/.claude-personal/CLAUDE.md.backup" "old claude md"
    rm -rf "${home}"
}

function test_install_is_idempotent() {
    local home
    home=$(new_home)
    HOME="${home}" "${INSTALLER}" > /dev/null
    HOME="${home}" "${INSTALLER}" > /dev/null || fail "second install exited non-zero"

    assert_link "${home}/AGENTS.md" "${AGENTS_DIR}/AGENTS.md"
    assert_content "${home}/.claude-personal/CLAUDE.md.backup" "old claude md"
    rm -rf "${home}"
}

function test_uninstall_restores_backups() {
    local home
    home=$(new_home)
    HOME="${home}" "${INSTALLER}" > /dev/null
    HOME="${home}" "${INSTALLER}" -u > /dev/null

    assert_absent "${home}/AGENTS.md"
    assert_absent "${home}/.agents/rules/go.md"
    assert_absent "${home}/.codex/AGENTS.md"
    assert_absent "${home}/.claude/CLAUDE.md"
    assert_content "${home}/.claude-personal/CLAUDE.md" "old claude md"
    assert_absent "${home}/.claude-personal/CLAUDE.md.backup"
    rm -rf "${home}"
}

test_install_links_everything
test_install_is_idempotent
test_uninstall_restores_backups

if [ "${failures}" -gt 0 ]; then
    echo "${failures} assertion(s) failed"
    exit 1
fi
echo "ok"
