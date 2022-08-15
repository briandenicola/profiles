cd $HOME

export ZSH="/home/brian/.oh-my-zsh"
export PATH=$HOME/bin:$HOME/bin/vaultcli:/usr/local/bin:$PATH
export DOTNET_CLI_TELEMETRY_OPTOUT=true
export GO111MODULE=on
export GOPATH=~/.go
export DOTNET_CLI_TELEMETRY_OPTOUT=1

ZSH_THEME="powerlevel10k/powerlevel10k"

export ARM_TENANT_ID=
export ARM_SUBSCRIPTION_ID=
export ARM_CLIENT_ID=
export ARM_CLIENT_SECRET=

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


source $ZSH/oh-my-zsh.sh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

alias ds='DirectorySize'
alias k='kubectl'
alias pwsh='pwsh -NoLogo'
alias utils='k run --restart=Never --rm -it --image=bjd145/utils:3.8 utils'

source <(kubectl completion zsh)
complete -F __start_kubectl k 

if command -v flux &> /dev/null
then
    source <(flux completion bash)
fi


#source bin/az.completion
#. "/home/brian/.acme.sh/acme.sh.env"
