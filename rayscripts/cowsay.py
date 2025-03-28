#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.8"
# dependencies = [ "cowsay" ]
# ///

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Cowsay
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🐮
# @raycast.packageName Fun
# @raycast.argument1 { "type": "text", "placeholder": "What should the animal say?" }
# --- Dropdown argument: Note the 'data' JSON must be on a single line! ---
# @raycast.argument2 { "type": "dropdown", "placeholder": "Pick an animal", "default": "cow", "data": [{ "title": "Beavis 📺", "value": "beavis" }, { "title": "Cheese 🧀", "value": "cheese" }, { "title": "Cow 🐮", "value": "cow" }, { "title": "Daemon 😈", "value": "daemon" }, { "title": "Dragon 🐉", "value": "dragon" }, { "title": "Fox 🦊", "value": "fox" }, { "title": "Ghostbusters 👻", "value": "ghostbusters" }, { "title": "Kitty 🐱", "value": "kitty" }, { "title": "Meow 🐈", "value": "meow" }, { "title": "Miki 🐭", "value": "miki" }, { "title": "Milk 🥛", "value": "milk" }, { "title": "Octopus 🐙", "value": "octopus" }, { "title": "Pig 🐷", "value": "pig" }, { "title": "Stegosaurus 🦕", "value": "stegosaurus" }, { "title": "Stimpy ❓", "value": "stimpy" }, { "title": "T-Rex 🦖", "value": "trex" }, { "title": "Turkey 🦃", "value": "turkey" }, { "title": "Turtle 🐢", "value": "turtle" }, { "title": "Tux 🐧", "value": "tux" }] }

# Documentation:
# @raycast.author marcmagn1
# @raycast.authorURL https://raycast.com/marcmagn1

import sys

import cowsay

# Args are: 1=message, 2=animal
message = sys.argv[1] if len(sys.argv) > 1 else "Hello from Raycast!"
animal = (
    sys.argv[2] if len(sys.argv) > 2 else "cow"
)  # Default 'cow' used if arg2 missing/fails

# Dynamically call the chosen animal function, fallback to 'cow' if invalid
if hasattr(cowsay, animal):
    try:
        getattr(cowsay, animal)(message)
    except Exception as e:
        print(f"⚠️ Error using animal '{animal}': {e}\n")
        cowsay.cow(message)  # Fallback on error during generation
else:
    print(f"⚠️ Unknown animal '{animal}' in cowsay library, falling back to cow...\n")
    cowsay.cow(message)
