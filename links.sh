#!/bin/sh

# Force link setup for dotfiles

ln -sf ~/dotfiles/.bash_profile ~/
ln -sf ~/dotfiles/.bashrc ~/
ln -sf ~/dotfiles/.dir_colors ~/
ln -sf ~/dotfiles/.git-completion.bash ~/
ln -sf ~/dotfiles/.git-completion.zsh ~/
ln -sf ~/dotfiles/.gitconfig ~/
ln -sf ~/dotfiles/.gvimrc ~/
ln -sf ~/dotfiles/.pypirc ~/
ln -sf ~/dotfiles/.ssh/.config ~/.ssh/.config
ln -sf ~/dotfiles/.vim/ ~/
ln -sf ~/dotfiles/.vimrc ~/
ln -sf ~/dotfiles/.Xresources ~/
ln -sf ~/dotfiles/.zshrc ~/

