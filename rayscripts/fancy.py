#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.8"
# dependencies = [ "art" ]
# ///

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Art
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🎨
# @raycast.packageName Fun
# @raycast.argument1 { "type": "text", "placeholder": "Text" }

# Documentation:
# @raycast.author theherk
# @raycast.authorURL https://raycast.com/theherk

import sys

from art import tprint

message = sys.argv[1] if len(sys.argv) > 1 else "Hello from Raycast!"

tprint(message)
