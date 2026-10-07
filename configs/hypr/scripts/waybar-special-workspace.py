#!/usr/bin/env python3
"""Show a special-workspace button only while it contains windows."""

import json
import subprocess
import sys


def hyprland_data(command):
    return json.loads(subprocess.check_output(
        ["hyprctl", "-j", command], stderr=subprocess.DEVNULL, timeout=2
    ))


def button_data(key, workspaces, monitors):
    name = "special:special" if key == "a" else f"special:{key}"
    workspace = next((w for w in workspaces if w["name"] == name), None)
    if not workspace or workspace.get("windows", 0) == 0:
        return {"text": ""}
    visible = any(m.get("specialWorkspace", {}).get("name") == name for m in monitors)
    count = workspace["windows"]
    return {
        "text": key.upper(),
        "class": "visible" if visible else "hidden",
        "tooltip": f"{key.upper()}: {count} window{'s' if count != 1 else ''} — click to toggle",
    }


if __name__ == "__main__":
    key = sys.argv[1]
    if key not in ("a", "z", "x"):
        raise SystemExit("Expected a, z, or x")
    try:
        result = button_data(key, hyprland_data("workspaces"), hyprland_data("monitors"))
    except (subprocess.SubprocessError, OSError, ValueError):
        result = {"text": ""}
    print(json.dumps(result, ensure_ascii=False))
