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

# Get compatdata folders names, request Steam API and try to math app ID with game / tool name
STEAM_GAMES=$(/usr/bin/curl https://api.steampowered.com/ISteamApps/GetAppList/v2/ 2> /dev/null)
STEAM_PROTON='[{"appid": 858280,"name": "Proton 3.7"},{"appid": 930400,"name": "Proton 3.7 Beta"},{"appid": 961940,"name": "Proton 3.16"},{"appid": 996510,"name": "Proton 3.16 Beta"},{"appid": 1054830,"name": "Proton 4.2"},{"appid": 1113280,"name": "Proton 4.11"},{"appid": 1161040,"name": "Proton BattlEye Runtime"},{"appid": 1245040,"name": "Proton 5.0"},{"appid": 1420170,"name": "Proton 5.13"},{"appid": 1493710,"name": "Proton Experimental"},{"appid": 1580130,"name": "Proton 6.3"},{"appid": 1826330,"name": "Proton EasyAntiCheat Runtime"},{"appid": 1887720,"name": "Proton 7.0"},{"appid": 2180100,"name": "Proton Hotfix"},{"appid": 2230260,"name": "Proton Next"},{"appid": 2348590,"name": "Proton 8.0"},{"appid": 2805730,"name": "Proton 9.0"},{"appid": 3658110,"name": "Proton 10.0"}]'

for DIR in $(/usr/bin/ls -d ${PATH}*/); do
    DIR_NAME=$(/usr/bin/basename "$DIR")

    GAME_NAME=$( /usr/bin/jq --argjson appId "$DIR_NAME" 'first(.applist | .apps | .[] | select(.appid == $appId).name)' <<< "$STEAM_GAMES" )

    if [ -z "$GAME_NAME" ]
    then
        PROTON_NAME=$( /usr/bin/jq --argjson appId "$DIR_NAME" 'first(.[] | select(.appid == $appId).name)' <<< "$STEAM_PROTON" )

        if [ -z "$PROTON_NAME" ]
        then
        echo "App ID: '$DIR_NAME' does not correspond to any Steam app"
        else
        echo "App ID: '$DIR_NAME' corresponds to the Steam tool $PROTON_NAME"
        fi
    else
        echo "App ID: '$DIR_NAME' corresponds to the Steam game $GAME_NAME"
    fi
done
