export ZSH="/home/brian/.oh-my-zsh"
export PATH=$HOME/.local/bin/buildkit/bin:$HOME/.local/bin:$HOME/bin/:$HOME/.porter:/usr/local/bin:$HOME/.acme.sh:$PATH
export DOTNET_CLI_TELEMETRY_OPTOUT=true
export FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT=true
export GO111MODULE=on
export GOPATH=~/.go

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
	common-aliases
	git
	github
	docker
	golang
	helm
	bundler
	dotenv
	kubectl
)

if [ -f $HOME/.aliases.rc ]; then source $HOME/.aliases.rc; fi
if [ -f $HOME/.banner.rc ]; then source $HOME/.banner.rc; fi

source $ZSH/oh-my-zsh.sh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

if command -v gh > /dev/null; then source <(gh completion -s zsh); fi
if command -v kubectl > /dev/null; then source <(kubectl completion zsh); fi
if command -v flux > /dev/null; then source <(flux completion zsh); fi
if command -v az > /dev/null; then source /etc/bash_completion.d/azure-cli; fi
if command -v rad > /dev/null; then source <(rad completion zsh); fi

complete -F __start_kubectl k 

. "/home/brian/.acme.sh/acme.sh.env"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

if [ -f $HOME/.local.rc ]; then source $HOME/.local.rc; fi

cd $HOME
