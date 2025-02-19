#!/bin/bash

# Dependencies: yad, gh CLI, jq, xdg-utils
# Install: sudo apt install yad jq xdg-utils gh
# Remember to log in with GitHub: gh auth login

ICON_PATH="$HOME/jobs/gh.png"
GITHUB_URL="https://github.com/notifications"
CHECK_INTERVAL=60  # Check every 60 seconds

# Function to check if there are any GitHub notifications
has_notifications() {
    [[ $(gh api notifications | jq length) -gt 0 ]]
}

# Initialize state variables
HAS_NOTIFICATIONS=false
YAD_PID=0

# Main loop
while true; do
    if has_notifications; then
        if ! $HAS_NOTIFICATIONS; then
            # Notifications exist, but the icon is not shown - show it
            GDK_BACKEND=x11 yad --notification --image="$ICON_PATH" --command="xdg-open $GITHUB_URL" --text "$NOTIF_COUNT notifications" &
            YAD_PID=$!  # Store PID of the notification
            HAS_NOTIFICATIONS=true
        fi
    else
        if $HAS_NOTIFICATIONS; then
            # No notifications, but the icon is still there - remove it
            if [[ "$YAD_PID" -ne 0 ]] && ps -p "$YAD_PID" > /dev/null; then
                kill "$YAD_PID"
            fi
            YAD_PID=0
            HAS_NOTIFICATIONS=false
        fi
    fi

    sleep "$CHECK_INTERVAL"
done