#! /bin/bash

echo "Creating your new ssh key..."
mkdir -p $HOME/.ssh
ssh-keygen -f $HOME/.ssh/id_rsa
cat $HOME/.ssh/id_rsa.pub | pbcopy

echo ""
echo "Your new ssh key has been copied to the clipboard."
echo "Please add it to your GitHub account now."
echo ""
read -n1 -s -r -p $'Once complete, press any key to continue...'
echo ""

git clone git@github.com:guysherman/dotfiles ~/dotfiles

cd ~/dotfiles

echo "Dotfiles have been installed. You can now run the appropriate setup script"
