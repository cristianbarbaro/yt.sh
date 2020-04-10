#!/usr/bin/env python3

import argparse
import subprocess
from colorama import Fore, Style
from subprocess import Popen


def show_list(videos):
    index = 1
    print("============================== PLAYLIST ==============================")
    for video in videos:
        print("{0} - {1}.".format(str(index),video["title"]))
        index+=1
    print("======================================================================\n")


def play_videos(videos):
    for video in videos:
        print(Fore.GREEN + "Now playing {0}".format(video["title"]) + Style.RESET_ALL) 
        p = Popen(["mplayer", "-slave", "-quiet", "-cache", "16384", "-cache-min", "80", video["audio_url"]], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        p.wait()
        output, errors = p.communicate()
        print("Next song...")
    print("No more music :(")
    return


def get_videos_from_urls(urls):
    videos = []
    vid_dict = {}
    for url in urls.split(" "):
        p = Popen(["youtube-dl","-g", "-e", url], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        output, errors = p.communicate()
        output = output.decode().split("\n")

        vid_dict = {
            "title" : output[0],
            "video_url": output[1],
            "audio_url": output[2]
        }
        videos.append(vid_dict)
    return videos


def get_videos_from_playlist(playlist):
    videos = []
    vid_dict = {}
    print("Downloading playlist. Please, wait...")

    p = Popen(["youtube-dl","-g", "-e", "-i", "--playlist-start", "1", playlist], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    output, errors = p.communicate()
    output = output.decode().split("\n")

    for line in output:
        if not "mime=video" in line and not "mime=audio" in line:
            vid_dict["title"] = line
        elif "mime=video" in line:
            vid_dict["video_url"] = line
        elif "mime=audio" in line:
            vid_dict["audio_url"] = line
            videos.append(vid_dict)
            vid_dict = {}
    return videos


parser = argparse.ArgumentParser()
parser.add_argument('--urls', help='urls')
parser.add_argument('--list', help="playlist")
args = parser.parse_args()

urls = args.urls
playlist = args.list

if urls:
    videos = get_videos_from_urls(urls)
    show_list(videos)
    play_videos(videos)

elif playlist:
    videos = get_videos_from_playlist(playlist)
    show_list(videos)
    play_videos(videos)
