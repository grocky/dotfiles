# shellcheck shell=bash
# Sets the weather segment's location from an IP geolocation lookup, so it follows you as you travel.
#
# The lookup is cached and refreshed in the background, so rendering the status line never waits on the network.
# A location already set (e.g. in config.local.sh) always wins. Overridable settings:
#   TMUX_POWERLINE_LOCATION_CMD          command that prints "lat,lon" (default: ipinfo.io lookup)
#   TMUX_POWERLINE_LOCATION_TTL_MINUTES  how long a lookup is reused (default: 60)
#   TMUX_POWERLINE_LOCATION_CACHE        cache file path

function __tmux_powerline_location_cache() {
    echo "${TMUX_POWERLINE_LOCATION_CACHE:-${XDG_CACHE_HOME:-$HOME/.cache}/tmux-powerline/location}"
}

function __tmux_powerline_location_is_fresh() {
    local cache=$1 ttl=${TMUX_POWERLINE_LOCATION_TTL_MINUTES:-60}
    [ -n "$(find "${cache}" -mmin "-${ttl}" 2>/dev/null)" ]
}

function __tmux_powerline_location_refresh() {
    local cache=$1 lock="${1}.lock" location
    mkdir -p "$(dirname "${cache}")"
    # Drop a lock left behind by a lookup that died; skip if another lookup is in flight.
    [ -n "$(find "${lock}" -mmin +1 2>/dev/null)" ] && rmdir "${lock}" 2>/dev/null
    mkdir "${lock}" 2>/dev/null || return 0

    location=$(${TMUX_POWERLINE_LOCATION_CMD:-curl --max-time 3 -fsS https://ipinfo.io/loc} 2>/dev/null | tr -d '[:space:]')
    if [[ "${location}" =~ ^-?[0-9]+(\.[0-9]+)?,-?[0-9]+(\.[0-9]+)?$ ]]; then
        echo "${location}" > "${cache}.tmp" && mv "${cache}.tmp" "${cache}"
    fi
    rmdir "${lock}"
}

function tmux_powerline_load_location() {
    if [ -n "${TMUX_POWERLINE_SEG_WEATHER_LAT:-}" ] || [ -n "${TMUX_POWERLINE_SEG_WEATHER_LON:-}" ]; then
        return
    fi

    local cache location
    cache=$(__tmux_powerline_location_cache)
    if ! __tmux_powerline_location_is_fresh "${cache}"; then
        # Detach output so tmux doesn't wait on the lookup before drawing the status line.
        __tmux_powerline_location_refresh "${cache}" > /dev/null 2>&1 &
    fi

    [ -f "${cache}" ] || return
    location=$(cat "${cache}")
    export TMUX_POWERLINE_SEG_WEATHER_LAT="${location%,*}"
    export TMUX_POWERLINE_SEG_WEATHER_LON="${location#*,}"
}
