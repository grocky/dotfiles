# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/grocky/dotfiles/dotfiles/vim/plugged/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/Users/grocky/dotfiles/dotfiles/vim/plugged/fzf/bin"
fi

source <(fzf --zsh)
