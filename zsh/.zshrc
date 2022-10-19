cd $HOME

export PATH=$HOME/bin:$HOME/bin/vaultcli:/usr/local/bin:$PATH
export DOTNET_CLI_TELEMETRY_OPTOUT=true
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
	zsh-autosuggestions
	zsh-syntax-highlighting
)

if [ -f $HOME/.aliases.rc ]; then source $HOME/.aliases.rc; fi
if [ -f $HOME/.banner.rc ]; then source $HOME/.banner.rc; fi

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source ~/.oh-my-zsh/oh-my-zsh.sh

if command -v kubectl > /dev/null; then source <(kubectl completion zsh); fi
if command -v flux > /dev/null; then source <(flux completion zsh); fi
if command -v az > /dev/null; then source /etc/bash_completion.d/azure-cli; fi

complete -F __start_kubectl k 

#source bin/az.completion
#. "/home/brian/.acme.sh/acme.sh.env"
