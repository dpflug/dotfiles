#!/usr/bin/env bash
feh --bg-fill "$(find ~/.config/awesome/theme/wallpapers -type f -iname '*.jpg' -o -iname '*.png' | shuf -n1)"
