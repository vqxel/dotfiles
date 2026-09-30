#!/usr/bin/env bash

# An optional name selects a named special workspace; no name uses the default.
special_ws=special
if [[ -n "${1:-}" ]]; then
    special_ws="special:$1"
fi

active_ws=$(hyprctl activewindow -j | jq -r '.workspace.name // empty')
[[ -n "$active_ws" ]] || exit 0

if [[ "$active_ws" == special || "$active_ws" == special:* ]]; then
    hyprctl dispatch movetoworkspace e+0
else
    hyprctl dispatch movetoworkspace "$special_ws"
fi
