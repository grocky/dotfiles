#!/usr/bin/env bash

BIN_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/bins

function help() {
  command_name=$(basename $0)
  printf "usage: %s [-u]\n\t-u\tUninstall the bins and restor any backups.\n" "${command_name}"
  description="\nSymlink bins from this repo to your home directory (%s).\n\n"
  printf "${description}" "${HOME}/bin"
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

  ${command}
}

function install() {
  ln -s ${BIN_DIR} ${HOME}/bin
}

function uninstall() {
  rm ${HOME}/bin
}

main "${@}"

