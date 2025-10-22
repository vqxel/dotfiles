export JAVA_HOME=$(/usr/libexec/java_home -v22.0.2)
#export JAVA_HOME=$(/usr/libexec/java_home -v11.0.15)

export M2_HOME="/Users/mine215/localpath/apache-maven-3.6.3"
PATH="${M2_HOME}/bin:${PATH}"
export ANDROID_HOME=/Users/$USER/Library/Android/sdk
export PATH=${PATH}:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:${HOME}/bin

export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# From nrfutil completion install
[[ -r "${HOME}/.nrfutil/share/nrfutil-completion/scripts/zsh/setup.zsh" ]] && . "${HOME}/.nrfutil/share/nrfutil-completion/scripts/zsh/setup.zsh"

export DISPLAY=:0

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/mine215/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/mine215/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/mine215/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/mine215/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
. "$HOME/.cargo/env"
