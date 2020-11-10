#!/usr/bin/env bash

if ! which sudo >/dev/null; then
	echo "Sudo not found! Please install Sudo."
	exit 1
fi

# Debian, etc.
if which apt >/dev/null; then
	echo "Apt manager found! Installing required staff..."
	MANAGER=apt
fi

# RHEL, etc.
if which yum >/dev/null; then
	echo "Yum manager found! Installing required staff..."
	MANAGER=yum
	sudo $MANAGER install -yq epel-release
fi

sudo $MANAGER install -yq zsh python3-pygments vim

# Install vim-plug
curl -sfLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Copy required files to user home directory
cp ./zshrc $HOME/.zshrc
cp ./zshenv $HOME/.zshenv
cp ./vimrc $HOME/.vimrc

# Change default user shell
echo "Changing user default shell to ZSH..."
if which chsh >/dev/null; then
	chsh -s /bin/zsh $USER
else
	sudo usermod -s /bin/zsh $USER
fi

echo "Done! Now you can run zsh!"
