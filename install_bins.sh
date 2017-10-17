#!/usr/bin/env bash

BIN_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/bins
BACKUP_SUFFIX='.backup'

function help() {
    command_name=$(basename $0)
    printf "usage: %s [-u]\n\t-u\tUninstall the bins and restor any backups.\n" "${command_name}"
    description="\nSymlink bins from this repo to your home directory (%s).\nIf the bins already exist in your home directory they will be backed up with a %s extension.\n"
    printf "${description}" "${HOME}/bin" "${BACKUP_SUFFIX}"
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

    if [ ! -d "${HOME}/bin" ]; then
        mkdir ${HOME}/bin
    fi
    
    pushd ${HOME}/bin > /dev/null

    for bin in $(find ${BIN_DIR} -maxdepth 1 | grep -v '^\.\|bins$'); do
        $command "${bin}"
    done
    popd > /dev/null
}

function install() {
    bin=${1}
    bin_name="$(basename ${bin})"
    if [ ! -L ${bin_name} ]; then
        [ -e ${bin_name} ] && [ ! -e ${bin_name}${BACKUP_SUFFIX} ] && mv ${bin_name} "${bin_name}${BACKUP_SUFFIX}" && echo "Backed up ${bin_name} to ${bin_name}${BACKUP_SUFFIX}";
        ln -s ${bin} ${bin_name} && echo "linked ${bin_name}";
    fi
}

function uninstall() {
    bin=${1}
    bin_name="$(basename ${bin})"
    if [ -L ${bin_name} ]; then
        [ -e ${bin_name} ] && rm ${bin_name} && echo "Uninstalled ${bin_name}"
        [ -e "${bin_name}${BACKUP_SUFFIX}" ] && mv "${bin_name}${BACKUP_SUFFIX}" ${bin_name} && echo "Restored ${bin_name} from previous version"
    fi
}

main "${@}"

