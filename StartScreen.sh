#!/bin/bash

start_screen() {
    if [ "$#" -ne 3 ]; then
        echo "Usage: start_screen <screen_name> <path> <command>"
        return 1
    fi

    local screen_name="$1"
    local path="$2"
    local command="$3"

    if [ ! -d "$path" ]; then
        echo "Error: Directory '$path' does not exist."
        return 1
    fi

    if screen -list | grep -q "\.${screen_name}"; then
        echo "Error: Screen session '$screen_name' already exists."
        return 1
    fi

    echo "Starting screen session '$screen_name' in '$path' with command: $command"

    screen -S "$screen_name" -dm bash -c "cd '$path' && $command >> /tmp/$screen_name.log 2>&1"

    if [ $? -eq 0 ]; then
        echo "Screen session '$screen_name' started and running '$command' in '$path'."
    else
        echo "Error: Failed to start screen session '$screen_name'."
        return 1
    fi

    if screen -ls | grep -q "$screen_name"; then
        echo "Screen session '$screen_name' is active and running."
    else
        echo "Error: Screen session '$screen_name' was not created or is inactive."
    fi
}
