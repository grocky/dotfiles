#!/usr/bin/env bash
#
# Per-day digest of your git activity. Groups commits by author date and
# prints the commit subjects under each date, with a daily stats line
# (commits / files touched / +adds / -dels).
#
# Defaults:
#   - Author = `git config user.email`
#   - Window = last 14 days
#   - Includes all local + remote branches (`--all`)
#
# Usage:
#   scripts/daily-summary.sh
#   scripts/daily-summary.sh --since 2026-05-01 --until 2026-05-14
#   scripts/daily-summary.sh --author someone@example.com
#   scripts/daily-summary.sh --no-stats          # subjects only, faster
#   scripts/daily-summary.sh --branches          # tag each commit with branch
#   scripts/daily-summary.sh -h | --help

set -u

author="$(git config user.email)"
since="2 weeks ago"
until=""
show_stats=1
show_branches=0

usage() {
  sed -n '3,/^$/p' "$0" | sed 's/^# \{0,1\}//'
  exit "${1:-0}"
}

while [ $# -gt 0 ]; do
  case "$1" in
    --author)      author="$2"; shift 2 ;;
    --since)       since="$2"; shift 2 ;;
    --until)       until="$2"; shift 2 ;;
    --no-stats)    show_stats=0; shift ;;
    --branches)    show_branches=1; shift ;;
    -h|--help)     usage 0 ;;
    *)             echo "Unknown option: $1" >&2; usage 1 ;;
  esac
done

if [ -z "$author" ]; then
  echo "Error: --author not provided and git config user.email is empty." >&2
  exit 1
fi

log_args=(
  --all
  --no-merges
  --author="$author"
  --since="$since"
  --date=short
  --pretty=format:'%ad%x09%h%x09%s'
)
[ -n "$until" ] && log_args+=(--until="$until")

# Sort by date descending so commits from different branches on the same
# day stay contiguous in the output regardless of git's topological order.
# Within a day, preserve commit order by hash as secondary key.
commits="$(git log "${log_args[@]}" | sort -t$'\t' -k1,1r -k2,2)"

if [ -z "$commits" ]; then
  echo "No commits found for $author since '$since'${until:+ until '$until'}."
  exit 0
fi

# Group commits by date (column 1). Print header per date, then commits.
current_date=""
day_hashes=()

flush_day() {
  [ -z "$current_date" ] && return
  local count="${#day_hashes[@]}"
  local stats_label=""
  if [ "$show_stats" -eq 1 ]; then
    # Compute totals across the day's commits using git log --shortstat.
    local stats
    stats="$(git log --no-walk "${day_hashes[@]}" --shortstat --pretty=format: 2>/dev/null \
      | awk '
        /file.*changed/ {
          for (i=1; i<=NF; i++) {
            if ($i ~ /^[0-9]+$/) {
              if ($(i+1) ~ /file/)       files += $i
              else if ($(i+1) ~ /inser/) adds  += $i
              else if ($(i+1) ~ /delet/) dels  += $i
            }
          }
        }
        END { printf "%d files, +%d/-%d", files+0, adds+0, dels+0 }')"
    stats_label="  ·  $stats"
  fi
  printf '\n==== %s  (%d commits%s) ====\n' "$current_date" "$count" "$stats_label"
  # Re-list this day's commits in insertion order (newest first per git log).
  for h in "${day_hashes[@]}"; do
    if [ "$show_branches" -eq 1 ]; then
      local branch
      branch="$(git branch --all --contains "$h" --format='%(refname:short)' 2>/dev/null \
        | grep -v -E '^(HEAD|origin/HEAD)$' | head -1)"
      printf '  %s  [%s]  %s\n' "$h" "${branch:-?}" "$(git log -n 1 --pretty=format:'%s' "$h")"
    else
      printf '  %s  %s\n' "$h" "$(git log -n 1 --pretty=format:'%s' "$h")"
    fi
  done
}

while IFS=$'\t' read -r date hash subject; do
  [ -z "$date" ] && continue
  if [ "$date" != "$current_date" ]; then
    flush_day
    current_date="$date"
    day_hashes=()
  fi
  day_hashes+=("$hash")
done <<<"$commits"
flush_day
echo
