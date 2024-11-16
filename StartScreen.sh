#!/bin/bash

history_file="./.screensHistory.log"
active_file="./.screensActive.log"

show_help() {
    cat <<EOF
Usage: ./startScreen.sh [OPTIONS] <screen_name> <path> <command>

Options:
  -h, --help            Show this help message and exit.
  -Re                    Restart all active screen sessions listed in 'screensActive.log'.
  -rm                    Remove all active screen sessions listed in 'screensActive.log'.

Commands:
  <screen_name>          The name of the screen session to start.
  <path>                 The directory where the command will be executed.
  <command>              The command to run in the screen session.

Description:
  - Use './startScreen.sh <screen_name> <path> <command>' to start a new screen session.
  - The screen session will be logged in both 'screensHistory.log' and 'screensActive.log'.
  - 'screensHistory.log' tracks the full history of all screen sessions, while 'screensActive.log' keeps track of currently running sessions.
  - Use './startScreen.sh -Re' to restart all active sessions from 'screensActive.log'.
  - Use './startScreen.sh -rm' to remove (quit) all active sessions from 'screensActive.log'.

Notes:
  - When restarting or removing sessions, their log files in '/tmp' will be deleted.
  - Both 'screensHistory.log' and 'screensActive.log' are stored in your home directory by default, and can be modified in the script.

EOF
}

start_screen() {
    if [ "$#" -ne 3 ]; then
        echo "Usage: start_screen <screen_name> <path> <command>"
        return 1
    fi

    local screen_name="$1"
    local path="$2"
    local command="$3"
    local session_log="/tmp/$screen_name.log"

    if [ ! -d "$path" ]; then
        echo "Error: Directory '$path' does not exist."
        return 1
    fi

    if screen -list | grep -q "\.${screen_name}"; then
        echo "Error: Screen session '$screen_name' already exists."
        return 1
    fi

    echo "Starting screen session '$screen_name' in '$path' with command: $command"

    if [ ! -f "$history_file" ]; then
        touch "$history_file"
        echo "Created new history file: $history_file"
    fi

    echo "$screen_name $path $command" >> "$history_file"
    echo "Appended to history file: $screen_name $command"

    screen -S "$screen_name" -dm bash -c "cd '$path' && $command >> $session_log 2>&1"

    if [ $? -eq 0 ]; then
        echo "Screen session '$screen_name' started and running '$command' in '$path'."
    else
        echo "Error: Failed to start screen session '$screen_name'."
        return 1
    fi

    echo "$screen_name" >> "$active_file"

    if screen -ls | grep -q "$screen_name"; then
        echo "Screen session '$screen_name' is active and running."
    else
        echo "Error: Screen session '$screen_name' was not created or is inactive."
    fi
}

restart_all_screens() {
    echo "Restarting all screen sessions..."

    if [ ! -f "$active_file" ]; then
        echo "Error: No active file found. No screen sessions to restart."
        return 1
    fi

    while IFS= read -r screen_name; do
        if screen -ls | grep -q "\.${screen_name}"; then
            echo "Restarting screen session '$screen_name'..."

            screen -S "$screen_name" -X quit
            sleep 1

            session_info=$(grep "^$screen_name " "$history_file")
            if [ -z "$session_info" ]; then
                echo "Error: Session '$screen_name' not found in history file. Skipping..."
                continue
            fi

            screen_name_from_history=$(echo "$session_info" | awk '{print $1}')
            path_from_history=$(echo "$session_info" | awk '{print $2}')
            command_from_history=$(echo "$session_info" | awk '{print $3}')

            screen -S "$screen_name" -dm bash -c "cd '$path_from_history' && $command_from_history >> /tmp/$screen_name.log 2>&1"
        else
            echo "Screen session '$screen_name' is not active. Skipping..."
        fi
    done < "$active_file"

    > "$active_file"
}

remove_all_screens() {
    echo "Removing all screen sessions..."

    if [ ! -f "$active_file" ]; then
        echo "Error: No active file found. No screen sessions to remove."
        return 1
    fi

    while IFS= read -r screen_name; do
        if screen -ls | grep -q "\.${screen_name}"; then
            echo "Removing screen session '$screen_name'..."

            screen -S "$screen_name" -X quit

            rm -f "/tmp/$screen_name.log"
        else
            echo "Screen session '$screen_name' is not active. Skipping..."
        fi
    done < "$active_file"

    > "$active_file"
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
    exit 0
elif [[ "$1" == "-Re" ]]; then
    restart_all_screens
elif [[ "$1" == "-rm" ]]; then
    remove_all_screens
else
    start_screen "$@"
fi
