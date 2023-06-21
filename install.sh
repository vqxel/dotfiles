#!/bin/zsh

cat ./.zshrc >> ~/.zshrc

cat ./vimconfig.vim >> ~/.vimrc

vim +PluginInstall +qall
