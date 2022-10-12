#!/usr/bin/env sh

cd ~/commons
if grep -q "light = true" ~/.config/git/config; then
    git apply -R patch/bat-light.patch
    git apply -R patch/delta-light.patch
    git apply -R patch/emacs-light.patch
    git apply -R patch/gitui-light.patch
    git apply -R patch/helix-light.patch
    git apply -R patch/wezterm-light.patch
else
    git apply patch/bat-light.patch
    git apply patch/delta-light.patch
    git apply patch/emacs-light.patch
    git apply patch/gitui-light.patch
    git apply patch/helix-light.patch
    git apply patch/wezterm-light.patch
fi
