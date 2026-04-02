#!/bin/sh
input=$(cat)

# ═══ ANSI Colors ═══
RST="\033[0m"
BOLD="\033[1m"
DIM="\033[2m"
WHITE="\033[97m"
GRAY="\033[90m"
YELLOW="\033[33m"
BGREEN="\033[92m"
BYELLOW="\033[93m"
BRED="\033[91m"
BCYAN="\033[96m"
BMAGENTA="\033[95m"
BBLUE="\033[94m"

# ═══ Extract ALL fields in one jq call ═══
eval "$(echo "$input" | jq -r '
  def s(f): if f == null or f == "" then "" else f | tostring end;
  "model_full=" + (s(.model.id) | @sh),
  "cwd=" + (s(.workspace.current_dir // .cwd) | @sh),
  "used=" + (s(.context_window.used_percentage) | @sh),
  "ctx_size=" + (s(.context_window.context_window_size) | @sh),
  "cache_read=" + (s(.context_window.current_usage.cache_read_input_tokens) | @sh),
  "total_in=" + (s(.context_window.total_input_tokens) | @sh),
  "total_out=" + (s(.context_window.total_output_tokens) | @sh),
  "five_pct=" + (s(.rate_limits.five_hour.used_percentage) | @sh),
  "five_reset=" + (s(.rate_limits.five_hour.resets_at) | @sh),
  "week_pct=" + (s(.rate_limits.seven_day.used_percentage) | @sh),
  "sonnet_pct=" + (s(.rate_limits.sonnet_daily.used_percentage) | @sh),
  "vim_mode=" + (s(.vim.mode) | @sh),
  "session_name=" + (s(.session_name) | @sh),
  "cost_usd=" + (s(.cost.total_usd // .session_cost_usd) | @sh)
')"

# ═══ Shorten model name ═══
short_model=$(echo "$model_full" | sed \
  -e 's/claude-//' \
  -e 's/-2[0-9]\{6\}$//' \
  -e 's/\[.*\]$//' \
  -e 's/\([0-9]\)-\([0-9]\)$/\1.\2/')

# ═══ Color by percentage ═══
pct_color() {
  pct_int=$(printf '%.0f' "$1" 2>/dev/null || echo 0)
  if   [ "$pct_int" -ge 80 ]; then printf "%s" "$BRED"
  elif [ "$pct_int" -ge 60 ]; then printf "%s" "$BYELLOW"
  elif [ "$pct_int" -ge 40 ]; then printf "%s" "$YELLOW"
  else printf "%s" "$BGREEN"
  fi
}

# ═══ Progress bar (12 blocks) ═══
build_bar() {
  filled=$(awk "BEGIN { printf \"%d\", ($1 / 100) * 12 + 0.5 }")
  color=$(pct_color "$1")
  i=0; bar=""; empty=""
  while [ $i -lt $filled ] && [ $i -lt 12 ]; do bar="${bar}█"; i=$((i+1)); done
  while [ $i -lt 12 ]; do empty="${empty}░"; i=$((i+1)); done
  printf "%b%s%b%b%s%b" "$color" "$bar" "$RST" "$DIM" "$empty" "$RST"
}

# ═══ Format token count (always with unit) ═══
fmt_k() {
  awk "BEGIN {
    n = $1 + 0
    if (n >= 1000000)      printf \"%.1fm\", n/1000000
    else if (n >= 100000)  printf \"%.0fk\", n/1000
    else                   printf \"%.1fk\", n/1000
  }"
}

# ═══ Format reset countdown ═══
fmt_reset() {
  now=$(date +%s)
  diff=$(( $1 - now ))
  [ $diff -le 0 ] && printf "soon" && return
  h=$((diff / 3600)); m=$(( (diff % 3600) / 60 ))
  [ $h -gt 0 ] && printf "%dh%02dm" $h $m || printf "%dm" $m
}

# ═══ Separator ═══
sep() { printf "%b │ %b" "$DIM" "$RST"; }

# ═══════════════════════════════════════════
# Assemble
# ═══════════════════════════════════════════

# Model
printf "%b✦ %b%s%b" "$BCYAN" "$BOLD$WHITE" "$short_model" "$RST"

# Working directory
if [ -n "$cwd" ]; then
  sep
  printf "%b%s%b" "$BBLUE" "$(basename "$cwd")" "$RST"
fi

# Session name
[ -n "$session_name" ] && sep && printf "%b%s%b" "$BMAGENTA" "$session_name" "$RST"

# Vim mode
[ -n "$vim_mode" ] && sep && printf "%b%s%b" "$BOLD$BCYAN" "$vim_mode" "$RST"

# Context bar
if [ -n "$used" ] && [ -n "$ctx_size" ]; then
  pct_val=$(printf '%.0f' "$used")
  tok=$(fmt_k "$(awk "BEGIN { printf \"%.0f\", ($used/100)*$ctx_size }")")
  ctx=$(fmt_k "$ctx_size")
  color=$(pct_color "$used")
  sep
  build_bar "$used"
  printf " %b%s%%%b %b%s%b%b/%s%b" "$color$BOLD" "$pct_val" "$RST" "$WHITE" "$tok" "$RST" "$DIM" "$ctx" "$RST"
elif [ -n "$used" ]; then
  pct_val=$(printf '%.0f' "$used")
  sep; build_bar "$used"
  printf " %b%s%%%b" "$(pct_color "$used")$BOLD" "$pct_val" "$RST"
fi

# Cache
if [ -n "$cache_read" ] && [ "$cache_read" != "0" ]; then
  printf " %bcache:%s%b" "$DIM" "$(fmt_k "$cache_read")" "$RST"
fi

# 5h rate limit
if [ -n "$five_pct" ]; then
  color=$(pct_color "$five_pct")
  sep
  printf "%b5h %b%s%%%b" "$GRAY" "$color$BOLD" "$(printf '%.0f' "$five_pct")" "$RST"
  [ -n "$five_reset" ] && printf "%b(%s)%b" "$DIM" "$(fmt_reset "$five_reset")" "$RST"
fi

# 7d rate limit
if [ -n "$week_pct" ]; then
  color=$(pct_color "$week_pct")
  sep
  printf "%b7d %b%s%%%b" "$GRAY" "$color$BOLD" "$(printf '%.0f' "$week_pct")" "$RST"
fi

# Sonnet daily
if [ -n "$sonnet_pct" ]; then
  color=$(pct_color "$sonnet_pct")
  printf " %bsonnet:%b%s%%%b" "$DIM" "$color" "$(printf '%.0f' "$sonnet_pct")" "$RST"
fi

# Session cost
if [ -n "$cost_usd" ] && [ "$cost_usd" != "0" ] && [ "$cost_usd" != "null" ]; then
  sep; printf "%b\$%s%b" "$BGREEN" "$cost_usd" "$RST"
fi

# Git branch + dirty file count
if [ -n "$cwd" ]; then
  git_branch=$(cd "$cwd" && git rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [ -n "$git_branch" ]; then
    git_count=$(cd "$cwd" && git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    sep
    if [ "$git_count" -gt 0 ] 2>/dev/null; then
      printf "%b%s%b%b*%s%b" "$BGREEN" "$git_branch" "$RST" "$BYELLOW" "$git_count" "$RST"
    else
      printf "%b%s%b" "$BGREEN" "$git_branch" "$RST"
    fi
  fi
fi

# Session totals
if [ -n "$total_in" ] && [ -n "$total_out" ]; then
  sep
  printf "%bin %b%s%b %bout %b%s%b" "$DIM" "$BCYAN" "$(fmt_k "$total_in")" "$RST" "$DIM" "$BMAGENTA" "$(fmt_k "$total_out")" "$RST"
fi

