#!/bin/bash

play(){
	VID=$1
	if [[ $VID == *"mime=audio"* ]];
	then
		echo -e "Playing ${VID}...\n\nPress 'Ctrl + C' for next song.\n"
		mplayer -cache 16384 -cache-min 80 $VID 2>/dev/null
	fi
}

play_urls() {

	for URL in $URLS
	do
		echo -e "Searching video url from YouTube for $URL...\n"
		
		YT_VID_URLS=$(/usr/local/bin/youtube-dl -g "$URL")

		for VID in $YT_VID_URLS
		do 
			play $VID
		done
	done

	echo -e "No more links. Exiting..."
}


play_list(){

	echo -e "Downloading playlist. Please, wait...\n"

	PLAYLIST=$(/usr/local/bin/youtube-dl -g --playlist-start 1 $URLS)

	for VID in $PLAYLIST
	do 
		play $VID
	done

	echo -e "No more playlist. Exiting..."
}

OPT=$1
URLS=$2

case $OPT in 

	-u) play_urls;;

	-p) play_list;;

	*) echo "Option $1 not recognized.";;

esac

shift

exit 0
 
