# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/grocky/dotfiles/dotfiles/vim/plugged/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/Users/grocky/dotfiles/dotfiles/vim/plugged/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/Users/grocky/dotfiles/dotfiles/vim/plugged/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/Users/grocky/dotfiles/dotfiles/vim/plugged/fzf/shell/key-bindings.zsh"
