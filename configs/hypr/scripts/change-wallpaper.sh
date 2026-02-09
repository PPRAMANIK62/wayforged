#!/bin/bash

WP1="$HOME/Pictures/wallpapers/tokyo-night.png"
WP2="$HOME/Pictures/wallpapers/puki.jpeg"

STATE_FILE="$HOME/.config/hypr/states/.wallpaper"

if [ ! -f "$STATE_FILE" ]; then
    echo "1" > "$STATE_FILE"
    hyprctl hyprpaper wallpaper ",$WP1"
else
    CURRENT=$(cat "$STATE_FILE")
    if [ "$CURRENT" = "1" ]; then
        echo "2" > "$STATE_FILE"
        hyprctl hyprpaper wallpaper ",$WP2"
    else
        echo "1" > "$STATE_FILE"
        hyprctl hyprpaper wallpaper ",$WP1"
    fi
fi
