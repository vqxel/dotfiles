# Install Homebrew
which -s brew
if [[ $? != 0 ]] ; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  brew update
fi

# Install Homebrew formulae needed
brew install cmake
brew install gcc
brew install latexindent
brew install python
brew install imagemagick
brew install nvm
brew install vim
brew install tmux
