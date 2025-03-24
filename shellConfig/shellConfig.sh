if [ -n ${ZSH_VERSION} ]; then
  SHELL_NAME="zsh"
elif [ -n ${BASH_VERSION} ]; then
  SHELL_NAME="bash"
else
  echo "Shell doesn't seem to be ZSH or BASH (neither $ZSH_VERSION nor $BASH_VERSION exist). These dotfiles do not run in other shells."
  return
fi

# All environment variables, aliases, etc. are handled in my organized dotfiles.

# Some dotfiles are specific to certain shells
for file in ${HOME}/dotfiles/shellConfig/${SHELL_NAME}/*.sh; do
  source "$file"
done

# Some dotfiles work accross all shells
for file in ${HOME}/dotfiles/shellConfig/allShells/*.sh; do
  source "$file"
done

# Some dotfiles are specific to specific systems
for file in ${HOME}/dotfiles/shellConfig/system_specific/${USER}/*.sh; do
  source "$file"
done
