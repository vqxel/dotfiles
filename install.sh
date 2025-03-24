#!/bin/sh

source ${HOME}/dotfiles/installers/$(uname).sh

source ${HOME}/dotfiles/shellConfig/shellConfig.sh

# Configure shell and Vim
ln -sf ${HOME}/dotfiles/shellConfig/shellConfig.sh ${HOME}/.${SHELL_NAME}rc
ln -sf ${HOME}/dotfiles/vimConfig/vimconfig.vim ${HOME}/.vimrc

vim -s ${HOME}/dotfiles/vimConfig/vimCommands.com
