#!/usr/bin/env bash

# Get the DISPLAY variable for the user's currently-running X, if it exists.
read -rt 1 DISPLAY < <(ps -ef | grep "$USER"'.*X' | grep -o ' :[[:digit:]]\+ ')

if [[ -n "$DISPLAY" ]] ; then
	feh --bg-fill "$(find -L ~/.config/awesome/theme/wallpapers/ -type f -iname '*.jpg' -o -iname '*.png' | shuf -n1)"
fi
