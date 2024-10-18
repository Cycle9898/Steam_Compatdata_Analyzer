# Steam Compatdata Analyzer

## Introduction

Proton from Valve is a tool for use with the Steam client which allows Windows games to run on a Linux distro or the SteamDeck. It rely on [Wine](https://www.winehq.org/).

More infos about Proton [here](https://github.com/ValveSoftware/Proton).

Proton will create a prefix per game. A prefix is a folder, named according to the Steam app ID, that contains all Proton/Wine configurations as well as all Windows elements that Proton/Wine uses.

These prefixes are stored in the Compatdata folder, located in `/home/$USER/.steam/steam/steamapps/compatdata/`.

When you uninstall a game on the Steam client, the prefix will not necessarily be deleted.

If you want to clean up a bit, you need to know which game ID corresponds to which game.

This bash script will retrieve all folder names inside the compatdata folder and then display the corresponding game name using the Steam API.

## Dependencies

This script need the following packages to work properly:

-   coreutils (typically pre-installed on most Linux distributions)

-   curl

-   jq

Use your favorite package manager to install the missing ones if needed.

## Usage

After downloading the script, run this command in the folder where it is located: `./compatdata_analyzer.sh <compatdata folder path>`.

Exemple:

```bash
./compatdata_analyzer.sh /home/deck/.steam/steam/steamapps/compatdata/
```

It will output `App ID: '$APP_ID' corresponds to the Steam game "$GAME_NAME"` or `App ID: '$APP_ID' does not correspond to any Steam game` if it is not found in the Steam API response.
