export PATH=$HOME/.local/bin:$HOME/bin:/usr/local/bin:$HOME/.acme.sh:$PATH
export DOTNET_CLI_TELEMETRY_OPTOUT=true
export GO111MODULE=on
export GOPATH=~/.go

if [ -f $HOME/.aliases.rc ]; then source $HOME/.aliases.rc; fi
if [ -f $HOME/.banner.rc ]; then source $HOME/.banner.rc; fi

if command -v gh > /dev/null; then source <(gh completion -s bash); fi
if command -v kubectl > /dev/null; then source <(kubectl completion bash); fi
if command -v flux > /dev/null; then source <(flux completion bash); fi
if command -v az > /dev/null; then source /etc/bash_completion.d/azure-cli; fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

if [ -f $HOME/.local.rc ]; then source $HOME/.local.rc; fi

cd $HOME