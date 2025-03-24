#!/bin/sh

source ${HOME}/dotfiles/installers/$(uname).sh

source ${HOME}/dotfiles/shellConfig/shellConfig.sh

echo "amongus"

# Configure shell and Vim
ln -sf ${HOME}/dotfiles/shellConfig/shellConfig.sh ${HOME}/.${SHELL_NAME}rc
ln -sf ${HOME}/dotfiles/vimConfig/vimconfig.vim ${HOME}/.vimrc
ln -sf ${HOME}/dotfiles/tmuxConfig/tmux.conf ${HOME}/.tmux.conf

vim -s ${HOME}/dotfiles/vimConfig/vimCommands.com
