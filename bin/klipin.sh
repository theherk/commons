#!/bin/bash
if [ -z "$1" ]
then
    #qdbus org.kde.klipper /klipper org.kde.klipper.klipper.setClipboardContents "$(< /dev/stdin)" &>/tmp/foo
    qdbus org.kde.klipper /klipper org.kde.klipper.klipper.setClipboardContents "$(cat)"
else
    qdbus org.kde.klipper /klipper org.kde.klipper.klipper.setClipboardContents "$1"
fi
