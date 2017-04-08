#!/bin/bash

# -s [size]         "letter" or "card"          default: letter
# -o [orientation]  "portrait" or "landscape"   default: portrait
# -p [page]         page number                 default: 1
while getopts ":s:o:p:" opt; do
    case $opt in
        s)
            size=$OPTARG
            ;;
        o)
            orientation=$OPTARG
            ;;
        p)
            page_input=$OPTARG
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
    echo "Must include a file." >&2
else
    filename="${1##*/}"                             # Strip longest match of */ from start
    dir="${1:0:${#1} - ${#filename}}"               # Substring from 0 thru pos of filename
    base="${filename%.[^.]*}"                       # Strip shortest match of . plus at least one non-dot char from end
    ext="${filename:${#base} + 1}"                  # Substring from len of base thru end
    if [[ -z "$base" && -n "$ext" ]]; then          # If we have an extension and no base, it's really the base
        base=".$ext"
        ext=""
    fi
    echo "input: ${1}"
fi

# is no size or wrong size letter
if [[ -z "$size" ]]
then
    size="letter"
    echo "Assuming size: letter" >&2
elif [ "$size" != "letter" ] && [ "$size" != "card" ]
then
    echo "size must be letter or card" >&2
    size="letter"
    echo "Assuming size: letter" >&2
else
    echo "size: $size"
fi

# is no orientation or wrong orientation portrait
if [[ -z "$orientation" ]]
then
    orientation="portrait"
    echo "Assuming orientation: portrait" >&2
elif [ "$orientation" != "portrait" ] && [ "$orientation" != "landscape" ]
then
    echo "orientation must be portrait or landscape" >&2
    orientation="portrait"
    echo "Assuming orientation: portrait" >&2
else
    echo "orientation: $orientation"
fi

# is no page or wrong page
# page offset by 1 for 0 index
re='^[0-9]+$' # regular expression for number check
if [[ -z "$page_input" ]]
then
    page_0index=0
    echo "Assuming page: 1" >&2
elif ! [[ $page_input =~ $re ]]
then
    echo "page must be a number" >&2
    page_0index=0
    echo "Assuming page: 1" >&2
else
    page_0index=$((page_input - 1))
    echo "page: ${page_input}"
fi

if [ "$size" == "letter" ]
then
    if [ "$orientation" == "portrait" ]
    then
        # crop
        convert -density 300 -depth 8 -quality 100 -background white -alpha remove ${1}[${page_0index}] png:- |
        convert - -crop 2550x3300+0+0 +repage -quality 90 -resize 1275x1650 "${dir}${base}.jpg"
        echo "Created: ${dir}${base}.jpg"
    elif [ "$orientation" == "landscape" ]
    then
        # crop
        convert -density 300 -depth 8 -quality 100 -background white -alpha remove ${1}[${page_0index}] png:- |
        convert - -crop 3300x2550+0+0 +repage -quality 90 -resize 1650x1275 "${dir}${base}.jpg"
        echo "Created: ${dir}${base}.jpg"
    else
        echo "Uh oh!" >&2
    fi
elif [ "$size" == "card" ]
then
    if [ "$orientation" == "portrait" ]
    then
        # crop
        convert -density 300 -depth 8 -quality 100 -background white -alpha remove ${1}[${page_0index}] png:- |
        convert - -crop 645x1016+0+0 +repage -quality 90 "${dir}${base}.jpg"
        echo "Created: ${dir}${base}.jpg"
    elif [ "$orientation" == "landscape" ]
    then
        # crop
        convert -density 300 -depth 8 -quality 100 -background white -alpha remove ${1}[${page_0index}] png:- |
        convert - -crop 1016x645+0+0 +repage -quality 90 "${dir}${base}.jpg"
        echo "Created: ${dir}${base}.jpg"
    else
        echo "Uh oh!" >&2
    fi
else
    echo "nothing to see here yet"
fi



