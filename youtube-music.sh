#!/bin/bash

play(){
	VID="$1"

	if [[ $VID != *"mime="* ]];
	then
		TITLE="$TITLE $VID"
	elif [[ $VID == *"mime=audio"* ]];
	then
		echo -e "\e[1;32mPlaying:${TITLE}\e[m\n"
		echo -e "\e[31mPress 'Ctrl + C' (kill mplayer process) for next song when playing.\e[m\n"
		mplayer -cache 16384 -cache-min 80 $VID 2>/dev/null
		TITLE=""
	fi
}

play_urls() {

	for URL in $URLS
	do
		echo -e "Searching video url from YouTube for $URL...\n"
		
		YT_VID_URLS=$(/usr/local/bin/youtube-dl -g -e "$URL")

		for VID in $YT_VID_URLS
		do 
			play "$VID"
		done
	done

	echo -e "No more links. Exiting..."
}


play_list(){

	echo -e "Downloading playlist. Please, wait...\n"

	PLAYLIST=$(/usr/local/bin/youtube-dl -g -e -i --playlist-start 1 $URLS)

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
 
