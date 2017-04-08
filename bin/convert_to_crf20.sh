#!/bin/bash

# strip the extension
noext=${1%.*}

ffmpeg -i $1 -vcodec libx264 -crf 20 ${noext}_crf20.mp4

