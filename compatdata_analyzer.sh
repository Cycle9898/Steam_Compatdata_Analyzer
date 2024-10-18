#!/bin/bash

# Check if a path has been passed as a parameter
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <compatdata folder path>"
    exit 1
fi 

PATH="$1"

# Check path validity
if [ ! -d "$PATH" ]; then
    echo "Error: '$PATH' is not a valid directory."
    exit 1
fi

# Get compatdata folders names, request Steam API and try to math them
STEAM_GAMES=$(/usr/bin/curl https://api.steampowered.com/ISteamApps/GetAppList/v2/ 2> /dev/null)

for DIR in $(/usr/bin/ls -d ${PATH}*/); do
    DIR_NAME=$(/usr/bin/basename "$DIR")

    GAME_NAME=$( /usr/bin/jq --argjson appId "$DIR_NAME" 'first(.applist | .apps | .[] | select(.appid == $appId).name)' <<< "$STEAM_GAMES" )

    if [ -z "$GAME_NAME" ]
    then
        echo "App ID: '$DIR_NAME' does not correspond to any Steam game"
    else
        echo "App ID: '$DIR_NAME' corresponds to the Steam game $GAME_NAME"
    fi
done
