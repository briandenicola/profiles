export PATH=$HOME/bin:$HOME/bin:/usr/local/bin:$PATH
export DOTNET_CLI_TELEMETRY_OPTOUT=true
export GO111MODULE=on
export GOPATH=~/.go

export BASTION_NAME=''
export BASTION_RG=''
export JUMPBOX_ID=''

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
	common-aliases
	git
	github
	docker
	golang
	helm
	encode64
	bundler
	dotenv
	kubectl
	zsh-autosuggestions
	zsh-syntax-highlighting
)

if [ -f $HOME/.aliases.rc ]; then source $HOME/.aliases.rc; fi
if [ -f $HOME/.banner.rc ]; then source $HOME/.banner.rc; fi

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source ~/.oh-my-zsh/oh-my-zsh.sh

if command -v gh > /dev/null; then source <(gh completion -s zsh); fi
if command -v kubectl > /dev/null; then source <(kubectl completion zsh); fi
if command -v flux > /dev/null; then source <(flux completion zsh); fi
if command -v az > /dev/null; then source /etc/bash_completion.d/azure-cli; fi

complete -F __start_kubectl k 

if [ -f $HOME/.local.rc ]; then source $HOME/.local.rc; fi

cd $HOME