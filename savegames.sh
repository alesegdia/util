#!/usr/bin/env bash

if [ "$#" -ne 1 ]; then
	echo "Usage: ./savegames.sh <dest-folder>"
	exit
fi

BACKUP_FOLDER=$1
echo $BACKUP_FOLDER

if [ ! -d $BACKUP_FOLDER ]; then
	echo "Folder doesn't exist!"
	exit
fi

function backup_game {
	tar -cf "$BACKUP_FOLDER/$1_$(date +%Y_%m_%d).tar.gz" "${@:2}"
}

USER=<YOUR-USER-HERE>

backup_game "Borderlands2" "/home/$USER/.local/share/aspyr-media/borderlands 2/willowgame/savedata"
backup_game "SystemShock2" "/home/$USER/.systemshock2/systemshock2/drive_c/Program Files/SystemShock2/save_"*
backup_game "Minecraft" "/home/$USER/.minecraft/saves"
