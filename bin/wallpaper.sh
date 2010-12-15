#!/usr/bin/env bash
DISPLAY="${DISPLAY:-:0}" feh --bg-fill "$(find ~/.config/awesome/theme/wallpapers -type f -iname '*.jpg' -o -iname '*.png' | shuf -n1)"
