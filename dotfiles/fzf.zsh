# Setup fzf
# ---------
if [[ ! "$PATH" == *${HOME}/dotfiles/dotfiles/vim/plugged/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}${HOME}/dotfiles/dotfiles/vim/plugged/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "${HOME}/dotfiles/dotfiles/vim/plugged/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "${HOME}/dotfiles/dotfiles/vim/plugged/fzf/shell/key-bindings.zsh"
