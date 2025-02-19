#!/bin/bash

# Dependencies: yad, gh CLI, jq, xdg-utils
# Install: sudo apt install yad jq xdg-utils gh
# Remember to log in with GitHub: gh auth login

ICON_PATH="$HOME/jobs/gh.png"
GITHUB_URL="https://github.com/notifications"
CHECK_INTERVAL=60  # Check every 60 seconds

# Function to check GitHub notifications
check_notifications() {
    gh api notifications | jq length
}

# Main loop
while true; do
    NOTIF_COUNT=$(check_notifications)

    # Remove existing notification
    pkill -f "yad --notification"
    
    # If notifications exist, show icon, else kill any existing one
    if [[ "$NOTIF_COUNT" -gt 0 ]]; then
        GDK_BACKEND=x11 yad --notification --image="$ICON_PATH" --command="xdg-open $GITHUB_URL" --text "$NOTIF_COUNT notifications" &
    fi

    sleep "$CHECK_INTERVAL"
done
