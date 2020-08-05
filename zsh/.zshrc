cd $HOME

export ZSH="/home/brian/.oh-my-zsh"
export PATH=$PATH:/home/brian/bin
export DOTNET_CLI_TELEMETRY_OPTOUT=true
export GO111MODULE=on
export DOTNET_CLI_TELEMETRY_OPTOUT=1

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
	git
	bundler
	dotenv
	kubectl
	zsh-autosuggestions
	zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

alias k='kubectl'
alias p='pwsh -NoLogo'
alias utils='k run --restart=Never --rm -it --image=bjd145/utils:latest utils -- bash'

source bin/az.completion
. "/home/brian/.acme.sh/acme.sh.env"
