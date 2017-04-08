#!/bin/bash

# Optional switch -h has no argument
# This will set video codec to huffyuv (default libx264)
# Optional switch -p has no argument
# This will set audio input to pulseaudio (default is from jack)
# Optional switch -s has no argument
# This with record audio and video to seperate files
while getopts ":hps" opt; do
    case $opt in
        h)
            HUFF="true"
            ;;
        p)
            PULSEIN="true"
            ;;
        s)
            SEPERATE="true"
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
            ;;
    esac
done

# Set the argument index back to 1
shift $((OPTIND-1))

if [[ -z "$1" ]]
then
    dir="."
else
    dir=${1%/}
fi

# Configuration - Logging
loglevel="panic"
# size=hd1080
size=2560x1440

# Configuration - Video
if [[ $HUFF == "true" ]]; then
    vstring="-f x11grab -s ${size} -r 30 -i :0.0 -vcodec huffyuv -pix_fmt yuv422p"
    vmethod="huffyuv"
else
    vstring="-f x11grab -s ${size} -r 30 -i :0.0 -vcodec libx264 -preset ultrafast -pix_fmt yuv422p"
    vmethod="libx264"
fi

# Configuration - Audio
if [[ $PULSEIN == "true" ]]; then
    astring="-f jack -ac 2 -i ffmpegpulsein"
    amethod="Jack > ffmpegpulsein"
else
    astring="-f jack -ac 2 -i ffmpeg"
    amethod="Jack > ffmpeg"
fi

# Check if Jackd is running
if ps ax | grep -v grep | grep jackd > /dev/null
then
    echo -e "Jack is up and running "
else
    echo -e "Jack is not running, please start jack before you go on "
fi

# Check if ffmpeg can handle jack
if ! ffmpeg -formats |& grep jack > /dev/null
then
    echo -e "FFmpeg is not compiled with jack"
    exit
fi

# Insert your desired filename below, extension will be added automatically
echo -n "Enter the filename without extension and hit <ENTER>: "
read name

# Echo output methods
echo "video codec: $vmethod, audio patch: $amethod"

if [[ $SEPERATE == "true" ]]; then
    ffmpeg -loglevel $loglevel $vstring -threads 0 "${dir}/${name}_video.avi" </dev/null >/dev/null 2>/dev/null &
    ffmpeg -loglevel $loglevel $astring -threads 0 "${dir}/${name}_audio.mp3" </dev/null >/dev/null 2>/dev/null &
    echo "Capturing Video: ${dir}/${name}_video.avi"
    echo "Capturing Audio: ${dir}/${name}_audio.mp3"
else
    ffmpeg -loglevel $loglevel $astring $vstring -threads 0 "${dir}/${name}.avi" </dev/null >/dev/null 2>/dev/null &
    echo "Capturing Video and Audio: ${dir}/${name}.avi"
fi

echo -e "Press ctrl-c to finish."

# Clean Exit that kills our ffmpeg processes
ExitFunc ()
{
    echo -e "\nDone"
    # This is probably not necessary,
    # but I would hate to leave them run.
    # killall -s INT ffmpeg
}
trap ExitFunc SIGINT

wait
