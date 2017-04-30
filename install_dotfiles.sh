#!/usr/bin/env bash

DOTFILE_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

pushd ${HOME}

for dotfile in $(find ${DOTFILE_DIR} -maxdepth 1 | grep -v '\.$\|\.git); do
    ln -s ${dotfile} .$(basename ${dotfile})
done

popd
