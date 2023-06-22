
export JAVA_HOME=$(/usr/libexec/java_home -v17.0.3)
#export JAVA_HOME=$(/usr/libexec/java_home -v11.0.15)
export M2_HOME="/Users/mine215/localpath/apache-maven-3.6.3"
PATH="${M2_HOME}/bin:${PATH}"
export ANDROID_HOME=/Users/$USER/Library/Android/sdk
export PATH=${PATH}:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
export PATH="${PATH}:${HOME}/bin"
export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
