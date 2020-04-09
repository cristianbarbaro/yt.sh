#!/bin/bash

URLS=$1

for URL in $URLS
do

	echo -e "Searching video url from YouTube for $URL...\n"

	YT_VID_URLS=$(/usr/local/bin/youtube-dl -g "$URL")

	YT_VID_URL=$(echo $YT_VID_URLS | cut -d" " -f2)

	echo -e "Playing ${URL}...\nPress 'Ctrl + C' for next song.\n"

	mplayer -cache 16384 -cache-min 80 $YT_VID_URL 2>/dev/null

	echo -e "${URL} has played. Next...\n"

done

echo -e "No more links. Exiting..."

exit 0
 
