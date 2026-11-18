#!/usr/bin/env bash
# Exercises the tmux-powerline location lookup with a fake lookup command and a throwaway cache.
set -u

REPO_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
LOCATION_SCRIPT="${REPO_DIR}/dotfiles/config/tmux-powerline/location.sh"
failures=0

function fail() {
    echo "FAIL: $1"
    failures=$((failures + 1))
}

function assert_eq() {
    [ "$2" == "$3" ] || fail "$1: got '$2', want '$3'"
}

# Runs the location lookup in a clean subshell and prints "LAT LON".
function load_location() {
    (
        unset TMUX_POWERLINE_SEG_WEATHER_LAT TMUX_POWERLINE_SEG_WEATHER_LON
        # shellcheck source=/dev/null
        source "${LOCATION_SCRIPT}"
        tmux_powerline_load_location
        wait
        echo "${TMUX_POWERLINE_SEG_WEATHER_LAT:-} ${TMUX_POWERLINE_SEG_WEATHER_LON:-}"
    )
}

function setup() {
    TEST_DIR=$(mktemp -d)
    export TMUX_POWERLINE_LOCATION_CACHE="${TEST_DIR}/location"
    export TMUX_POWERLINE_LOCATION_TTL_MINUTES=60
    export TMUX_POWERLINE_LOCATION_CMD="echo 51.5074,-0.1278"
}

function teardown() {
    rm -rf "${TEST_DIR}"
}

function test_uses_cached_location() {
    setup
    echo "35.6762,139.6503" > "${TMUX_POWERLINE_LOCATION_CACHE}"
    assert_eq "cached location" "$(load_location)" "35.6762 139.6503"
    assert_eq "fresh cache is kept" "$(cat "${TMUX_POWERLINE_LOCATION_CACHE}")" "35.6762,139.6503"
    teardown
}

function test_missing_cache_is_fetched_in_background() {
    setup
    assert_eq "first load has no location yet" "$(load_location)" " "
    assert_eq "cache written" "$(cat "${TMUX_POWERLINE_LOCATION_CACHE}")" "51.5074,-0.1278"
    assert_eq "next load uses fetched location" "$(load_location)" "51.5074 -0.1278"
    teardown
}

function test_stale_cache_is_refreshed() {
    setup
    echo "35.6762,139.6503" > "${TMUX_POWERLINE_LOCATION_CACHE}"
    touch -t 202001010000 "${TMUX_POWERLINE_LOCATION_CACHE}"
    assert_eq "stale location still used meanwhile" "$(load_location)" "35.6762 139.6503"
    assert_eq "cache refreshed" "$(cat "${TMUX_POWERLINE_LOCATION_CACHE}")" "51.5074,-0.1278"
    teardown
}

function test_failed_lookup_keeps_previous_location() {
    setup
    export TMUX_POWERLINE_LOCATION_CMD="false"
    echo "35.6762,139.6503" > "${TMUX_POWERLINE_LOCATION_CACHE}"
    touch -t 202001010000 "${TMUX_POWERLINE_LOCATION_CACHE}"
    load_location > /dev/null
    assert_eq "cache kept after failure" "$(cat "${TMUX_POWERLINE_LOCATION_CACHE}")" "35.6762,139.6503"
    teardown
}

function test_malformed_lookup_is_rejected() {
    setup
    export TMUX_POWERLINE_LOCATION_CMD="echo <html>rate limited</html>"
    load_location > /dev/null
    [ -e "${TMUX_POWERLINE_LOCATION_CACHE}" ] && fail "malformed response was cached"
    teardown
}

function test_explicit_location_wins() {
    setup
    echo "35.6762,139.6503" > "${TMUX_POWERLINE_LOCATION_CACHE}"
    got=$(
        export TMUX_POWERLINE_SEG_WEATHER_LAT=1 TMUX_POWERLINE_SEG_WEATHER_LON=2
        # shellcheck source=/dev/null
        source "${LOCATION_SCRIPT}"
        tmux_powerline_load_location
        echo "${TMUX_POWERLINE_SEG_WEATHER_LAT} ${TMUX_POWERLINE_SEG_WEATHER_LON}"
    )
    assert_eq "explicit location" "${got}" "1 2"
    teardown
}

test_uses_cached_location
test_missing_cache_is_fetched_in_background
test_stale_cache_is_refreshed
test_failed_lookup_keeps_previous_location
test_malformed_lookup_is_rejected
test_explicit_location_wins

if [ "${failures}" -gt 0 ]; then
    echo "${failures} assertion(s) failed"
    exit 1
fi
echo "ok"
