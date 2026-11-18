# shellcheck shell=bash
# tmux-powerline user config. Only overrides; everything else uses the plugin defaults.

export TMUX_POWERLINE_THEME="grocky"
export TMUX_POWERLINE_DIR_USER_THEMES="${XDG_CONFIG_HOME:-$HOME/.config}/tmux-powerline/themes"

# Room for the working directory, which lives on the left so the clock on the right never gets pushed off.
export TMUX_POWERLINE_STATUS_LEFT_LENGTH=120

# Machine-specific settings (e.g. a fixed weather location) live in an untracked file so they stay out of the public repo:
#   export TMUX_POWERLINE_SEG_WEATHER_LAT="40.71"
#   export TMUX_POWERLINE_SEG_WEATHER_LON="-74.01"
#   export TMUX_POWERLINE_SEG_WEATHER_UNIT="f"
_tmux_powerline_local_config="${XDG_CONFIG_HOME:-$HOME/.config}/tmux-powerline/config.local.sh"
# shellcheck source=/dev/null
[ -f "${_tmux_powerline_local_config}" ] && source "${_tmux_powerline_local_config}"
unset _tmux_powerline_local_config

# Weather follows the current location (IP-based) unless config.local.sh pins one.
# shellcheck source=/dev/null
source "${XDG_CONFIG_HOME:-$HOME/.config}/tmux-powerline/location.sh"
export TMUX_POWERLINE_SEG_WEATHER_UNIT="f"
tmux_powerline_load_location
