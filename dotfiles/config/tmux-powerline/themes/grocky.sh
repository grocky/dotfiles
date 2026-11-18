# shellcheck shell=bash
# The plugin's default theme, with the working directory moved from the right side to the left.

# shellcheck source=/dev/null
source "${TMUX_POWERLINE_DIR_THEMES}/default.sh"

# shellcheck disable=SC2034
TMUX_POWERLINE_LEFT_STATUS_SEGMENTS=(
	"tmux_session_info 148 234"
	"hostname 33 0"
	"lan_ip 24 255 ${TMUX_POWERLINE_SEPARATOR_RIGHT_THIN}"
	"wan_ip 24 255"
	"pwd 89 211"
	"vcs_branch 29 88"
)

# shellcheck disable=SC2034
TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS=(
	"now_playing 234 37"
	"load 237 167"
	"battery 137 127"
	"weather 37 255"
	"date_day 235 136"
	"date 235 136 ${TMUX_POWERLINE_SEPARATOR_LEFT_THIN}"
	"time 235 136 ${TMUX_POWERLINE_SEPARATOR_LEFT_THIN}"
)
