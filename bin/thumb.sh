#!/bin/bash

path=${1%/}
file=${path##*/}
name=${file%.*}
ext=${file##*.}

make_th() {
    if [[ $pic != th-* ]];
    then
        thumb="th-$pic"
        convert "$pic" -thumbnail 200 "$thumb"
    fi
}

# Now we need a way to call make_thumbnail on each file.
# The easiest robust way is to restrict on files at level 2, and glob those
# with */*.jpg
# (we could also glob levels 2 and 3 with two globs: */*.jpg */*/*.jpg)

cd $path

shopt -s nullglob
for pic in *.{png,jpg}
do
    make_th "$pic"
done

