#!/usr/bin/env bash
# Symlink shared AI agent instructions from ./agents into the locations each agent reads.

AGENTS_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/agents
BACKUP_SUFFIX='.backup'

function help() {
    printf "usage: %s [-u]\n\t-u\tUninstall the agent instructions and restore any backups.\n" "$(basename "$0")"
    printf "\nSymlink %s into:\n" "${AGENTS_DIR}"
    printf "  ~/AGENTS.md, ~/.agents/rules/, ~/.codex/AGENTS.md,\n"
    printf "  and CLAUDE.md + rules/ in ~/.claude and every existing ~/.claude-* config dir.\n"
    printf "Existing files are backed up with a %s extension.\n" "${BACKUP_SUFFIX}"
}

# Prints "<source> <link>" pairs, one per line.
function links() {
    echo "${AGENTS_DIR}/AGENTS.md ${HOME}/AGENTS.md"
    echo "${AGENTS_DIR}/AGENTS.md ${HOME}/.codex/AGENTS.md"

    local rule claude_dir
    for rule in "${AGENTS_DIR}"/rules/*.md; do
        echo "${rule} ${HOME}/.agents/rules/$(basename "${rule}")"
    done

    for claude_dir in "${HOME}/.claude" "${HOME}"/.claude-*/; do
        claude_dir=${claude_dir%/}
        [ -d "${claude_dir}" ] || [ "${claude_dir}" == "${HOME}/.claude" ] || continue
        echo "${AGENTS_DIR}/CLAUDE.md ${claude_dir}/CLAUDE.md"
        for rule in "${AGENTS_DIR}"/rules/*.md; do
            echo "${rule} ${claude_dir}/rules/$(basename "${rule}")"
        done
    done
}

function install() {
    local source=$1 link=$2
    if [ -L "${link}" ] && [ "$(readlink "${link}")" == "${source}" ]; then
        return
    fi
    mkdir -p "$(dirname "${link}")"
    if [ -e "${link}" ] || [ -L "${link}" ]; then
        if [ -e "${link}${BACKUP_SUFFIX}" ]; then
            echo "skipping ${link}: exists and ${link}${BACKUP_SUFFIX} already taken" >&2
            return 1
        fi
        mv "${link}" "${link}${BACKUP_SUFFIX}" && echo "Backed up ${link} to ${link}${BACKUP_SUFFIX}"
    fi
    ln -s "${source}" "${link}" && echo "linked ${link}"
}

function uninstall() {
    local source=$1 link=$2
    [ -L "${link}" ] && [ "$(readlink "${link}")" == "${source}" ] || return 0
    rm "${link}" && echo "Uninstalled ${link}"
    if [ -e "${link}${BACKUP_SUFFIX}" ]; then
        mv "${link}${BACKUP_SUFFIX}" "${link}" && echo "Restored ${link} from previous version"
    fi
}

function main() {
    local command='install'
    while getopts hu FLAG; do
        case $FLAG in
            u) command='uninstall' ;;
            h) help; exit 0 ;;
            \?) help; exit 1 ;;
        esac
    done

    local status=0 source link
    while read -r source link; do
        ${command} "${source}" "${link}" || status=1
    done < <(links)
    return ${status}
}

main "${@}"
