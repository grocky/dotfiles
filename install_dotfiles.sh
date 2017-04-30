#!/usr/bin/env bash

DOTFILE_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/dotfiles
BACKUP_SUFFIX='.backup'

function help() {
    command_name=$(basename $0)
    printf "usage: %s [-u]\n\t-u\tUninstall the dotfiles and restor any backups.\n" "${command_name}"
    description="\nSymlink dotfiles from this repo to your home directory (%s).\nIf the dotfiles already exist in your home directory they will be backed up with a %s extension.\n"
    printf "${description}" "${HOME}" "${BACKUP_SUFFIX}"
}

function main() {
    command='install'

    while getopts hu FLAG; do
      case $FLAG in
        u)
          command='uninstall'
          ;;
        h)
          help
          ;;
        \?)
          echo -e \\n"Option $OPTARG not allowed."
          help
          ;;
      esac
    done
    
    pushd ${HOME} > /dev/null
    for dotfile in $(find ${DOTFILE_DIR} -maxdepth 1 | grep -v '^\.\|dotfiles$'); do
        $command "${dotfile}"
    done
    popd > /dev/null
}

function install() {
    dotfile=${1}
    dotfile_name=".$(basename ${dotfile})"
    if [ ! -L ${dotfile_name} ]; then
        [ -e ${dotfile_name} ] && [ ! -e ${dotfile_name}${BACKUP_SUFFIX} ] && mv ${dotfile_name} "${dotfile_name}${BACKUP_SUFFIX}" && echo "Backed up ${dotfile_name} to ${dotfile_name}${BACKUP_SUFFIX}";
        ln -s ${dotfile} ${dotfile_name} && echo "linked ${dotfile_name}";
    fi
}

function uninstall() {
    dotfile=${1}
    dotfile_name=".$(basename ${dotfile})"
    if [ -L ${dotfile_name} ]; then
        [ -e ${dotfile_name} ] && rm ${dotfile_name} && echo "Uninstalled ${dotfile_name}"
        [ -e "${dotfile_name}${BACKUP_SUFFIX}" ] && mv "${dotfile_name}${BACKUP_SUFFIX}" ${dotfile_name} && echo "Restored ${dotfile_name} from previous version"
    fi
}

main "${@}"

