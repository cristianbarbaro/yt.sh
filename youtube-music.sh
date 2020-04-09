#!/bin/bash

URLS=$1

for URL in $URLS
do

	echo -e "Searching video url from YouTube for $URL...\n"

	YT_VID_URLS=$(/usr/local/bin/youtube-dl -g "$URL")

	YT_VID_URL=$(echo $YT_VID_URLS | cut -d" " -f2)

	echo -e "Playing ${YT_VID_URL}...\nPress 'Ctrl + C' for next song.\n"

	mplayer -ao alsa:device=default $YT_VID_URL 2>/dev/null

	echo -e "${YT_VID_URL} has played. Next...\n"

done

exit 0
 
