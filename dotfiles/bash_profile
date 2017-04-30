# source the users bashrc if it exists
if [ -f "${HOME}/.bashrc" ] ; then
  source "${HOME}/.bashrc"
fi

#Set PATH so it includes user's private bin if it exists
if [ -d "${HOME}/bin" ] ; then
  PATH="${HOME}/bin:${PATH}"
fi

if [ -f "${HOME}/.bash_completions" ]; then
  source "${HOME}/.bash_completions"
fi

export XDG_CONFIG_HOME=${HOME}/.config

export PATH="${PATH}:/usr/local/bin:${HOME}/.rvm/bin" # Add RVM to PATH for scripting
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH" # use coreutils
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

export VISUAL=vim
export EDITOR="$VISUAL"

travis_sh=${HOME}/.travis/travis.sh && [ -f ${travis_sh} ] && source ${travis_sh}
j_sh=/usr/local/etc/profile.d/autojump.sh && [ -f ${j_sh} ] && source ${j_sh}

## Powerline bash
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
powerline_sh=/usr/local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh
[ -f ${powerline_sh} ] && source ${powerline_sh}

