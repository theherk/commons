#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Alternate Editor Bind
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 📝

# Documentation:
# @raycast.description Simulates pressing Option + 3
# @raycast.author theherk
# @raycast.authorURL https://raycast.com/theherk

tell application "System Events"
    key code 20 using {option down} # 20 is the key code for '3'
end tell
