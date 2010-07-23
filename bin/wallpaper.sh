#!/usr/bin/env bash
echo "HEY, I GOT CALLED, Y'ALL!"
feh --bg-fill "$(find ~/.config/awesome/theme/wallpapers -type f -iname '*.jpg' -o -iname '*.png' | shuf -n1)"
