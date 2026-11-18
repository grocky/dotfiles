# shellcheck shell=bash
# tmux-powerline user config. Only overrides; everything else uses the plugin defaults.

export TMUX_POWERLINE_THEME="grocky"
export TMUX_POWERLINE_DIR_USER_THEMES="${XDG_CONFIG_HOME:-$HOME/.config}/tmux-powerline/themes"

# Room for the working directory, which lives on the left so the clock on the right never gets pushed off.
export TMUX_POWERLINE_STATUS_LEFT_LENGTH=120
