# User
DEFAULT_USER="HSn"

# Paths and environment
export ZSH="$HOME/.oh-my-zsh"
export GOPATH="$HOME/go"
export JAVA_HOME="/opt/homebrew/opt/openjdk@11"
export NVM_DIR="$HOME/.nvm"
export BUILDKIT_NO_CLIENT_TOKEN=true
export EDITOR="nvim"
export CLICOLOR=1

if command -v zsh >/dev/null; then
  export SHELL="$(command -v zsh)"
fi

# PATH management
typeset -U path PATH
path_append() {
  [[ -d "$1" ]] && path+=("$1")
}

path_append "$GOPATH/bin"
path_append "/usr/local/mysql/bin"
path_append "$JAVA_HOME/bin"
path_append "/opt/homebrew/opt/icu4c/bin"
path_append "/opt/homebrew/opt/icu4c/sbin"
path_append "${KREW_ROOT:-$HOME/.krew}/bin"

if command -v npm >/dev/null; then
  npm_global_bin="$(npm bin -g 2>/dev/null)"
  if [[ -n "$npm_global_bin" ]]; then
    path_append "$npm_global_bin"
  fi
fi
unset npm_global_bin

# Enable NVM
if [[ -s "/opt/homebrew/opt/nvm/nvm.sh" ]]; then
  . "/opt/homebrew/opt/nvm/nvm.sh"
fi
if [[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ]]; then
  . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
fi

# Zsh settings
ZSH_THEME="robbyrussell"
plugins=(
  git
  jsontools
  zsh-autosuggestions
  vscode
  emoji-clock
  aliases
  web-search
  history-substring-search
  sudo
  tmux
  fzf
  macos
  zsh-syntax-highlighting
)

source "$ZSH/oh-my-zsh.sh"

# Disable command auto-correct
unsetopt correct correct_all

# Config shortcuts
alias bashconfig="vim ~/.bashfile"
alias zshconfig="vim ~/.zshrc"
alias vimconfig="vim ~/.vimrc"
# File and directory
if command -v eza >/dev/null; then
  alias ls='eza --color=auto'
  alias ll='eza -lh --color=auto'
  alias la='eza -a --color=auto'
  alias lsa='eza -la --color=auto'
  alias l.='eza -d .* --color=auto'
  alias lh='eza -alths --color=auto'
elif command -v gls >/dev/null; then
  alias ls='gls --color=auto'
  alias ll='gls -lh --color=auto'
  alias la='gls -a --color=auto'
  alias lsa='gls -la --color=auto'
  alias l.='gls -d .* --color=auto'
  alias lh='gls -alths --color=auto'
else
  alias ls='ls -G'
  alias ll='ls -lh -G'
  alias la='ls -a -G'
  alias lsa='ls -la -G'
  alias l.='ls -d .* -G'
  alias lh='ls -alths -G'
fi
alias ..='cd ..'
alias ...='cd ../../..'
alias mkdir='mkdir -pv'
alias rd='rm -rf'
alias tree='tree --charset ASCII'

# Search
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias findlarge='find . -type f -size +100M'

# Time and date
alias now='date "+%Y-%m-%d %H:%M:%S.%s"'
alias today='date "+%Y-%m-%d"'
alias timestamp='now; echo s: $(date +"%s"); echo ms: $(expr $(date +%s%N) / 1000000)'

# Safety for destructive commands
alias mv='mv -i'
alias cp='cp -ir'
alias ln='ln -i'
alias rm='rm -i'

# System
alias topcpu='ps aux --sort=-%cpu | head -10'
alias topmem='ps aux --sort=-%mem | head -10'
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias iotop='iotop -o'

# Network
alias myip='curl ifconfig.me'
alias ports='netstat -tulanp'
alias pingtest='ping -c 4 8.8.8.8'
alias ss='sudo ss -tuln'
alias ip='ipconfig getifaddr en0'

# Kubernetes
alias k="kubectl"
alias kg="kubectl get"
alias kgp="kubectl get pods"
alias kgpo="kubectl get pods"
alias kgn="kubectl get nodes"
alias kgnw="kubectl get nodes -o wide"
alias kgd="kubectl get deployment"
alias kgdw="kubectl get deployment -o wide"
alias kgs="kubectl get svc"
alias kgsw="kubectl get svc -o wide"

alias kdp="kubectl describe pod"
alias kdd="kubectl describe deployment"
alias kds="kubectl describe service"
alias kdn="kubectl describe node"

alias ke="kubectl edit"

alias ktpm="kubectl top pod --all-namespaces --sort-by=memory"
alias ktpc="kubectl top pod --all-namespaces --sort-by=cpu"

alias ks="kubectl -n kube-system"
alias ksg="kubectl -n kube-system get"
alias ksgp="kubectl -n kube-system get pods"
alias ksgpo="kubectl -n kube-system get pods"
alias ksgd="kubectl -n kube-system get deployment"

alias kl="kubectl logs"
alias klf="kubectl logs -f"
alias klf1="kubectl logs -f --tail=1"
alias klf10="kubectl logs -f --tail=10"
alias klf100="kubectl logs -f --tail=100"
alias klp="kubectl logs -p"
alias klt="kubectl logs --tail=50"

alias ka="kubectl apply -f"
alias kdel="kubectl delete"
alias kcf="kubectl create -f"
alias kr="kubectl rollout restart"
alias krd="kubectl rollout status deployment"

alias kns="kubectl config set-context --current --namespace"

alias kge="kubectl get events --sort-by='.lastTimestamp'"

alias kw="kubectl get --watch"
alias kgwl="kubectl get pods -o wide --watch"

alias kgcrd="kubectl get crd"

alias kgjp="kubectl get pods -o json | jq"
alias kgjd="kubectl get deployment -o json | jq"

alias kdfp="kubectl delete pod --field-selector=status.phase=Failed"

alias kres="kubectl rollout restart deployment"

if command -v kubecolor >/dev/null; then
  alias kubectl="kubecolor"
fi

if command -v kubecm >/dev/null; then
  alias kc='kubecm'
  alias kcs='kubecm switch'
fi

if command -v kubefwd >/dev/null; then
  alias kf='kubefwd'
fi

alias kctx="kubectl config get-contexts"
alias kcx="kubectl config use-context"

alias kgns="kubectl get namespaces"

alias kcfg="kubectl config view --minify"

alias ktn="kubectl top nodes"

alias badnode='kubectl get nodes -o jsonpath='\''{range .items[*]}{.metadata.name}{"\t"}{.status.conditions[?(@.type=="Ready")].status}{"\t"}{.status.addresses[?(@.type=="InternalIP")].address}{"\n"}{end}'\'' | awk -F'\''\t'\'' '\''$2 != "True" {print $3}'\'''

alias kv="kubevpn"

# Docker
alias dps='docker ps'
alias di='docker images'
alias dstart='docker start'
alias dstop='docker stop'
alias drm='docker rm'
alias drmi='docker rmi'
alias dlog='docker logs -f'
alias dvol='docker volume ls'

# Git stats
alias daygit='git log --author="hsn" --since="1 day ago" --pretty=tformat: --numstat -- . ":(exclude)vendor" ":(exclude)static/bower_components" | awk '\''{ add += $1; subs += $2; loc += $1 - $2 } END { printf "today git added %s lines, deleted %s lines, total %s lines\n", add, subs, loc }'\'''
alias weekgit='git log --author="hsn" --since="1 week ago" --pretty=tformat: --numstat -- . ":(exclude)vendor" ":(exclude)static/bower_components" | awk '\''{ add += $1; subs += $2; loc += $1 - $2 } END { printf "this week git added %s lines, deleted %s lines, total %s lines\n", add, subs, loc }'\'''
alias monthgit='git log --author="hsn" --since="1 month ago" --pretty=tformat: --numstat -- . ":(exclude)vendor" ":(exclude)static/bower_components" | awk '\''{ add += $1; subs += $2; loc += $1 - $2 } END { printf "this month git added %s lines, deleted %s lines, total %s lines\n", add, subs, loc }'\'''
alias yeargit='git log --author="hsn" --since="1 year ago" --pretty=tformat: --numstat -- . ":(exclude)vendor" ":(exclude)static/bower_components" | awk '\''{ add += $1; subs += $2; loc += $1 - $2 } END { printf "this year git added %s lines, deleted %s lines, total %s lines\n", add, subs, loc }'\'''
alias allgit='git log --author="hsn" --pretty=tformat: --numstat -- . ":(exclude)vendor" ":(exclude)static/bower_components" | awk '\''{ add += $1; subs += $2; loc += $1 - $2 } END { printf "git total added %s lines, deleted %s lines, total %s lines\n", add, subs, loc }'\'''

# Dev tools
alias cl='clear'
alias h='history'
alias py='python3'
alias code='code .'
alias vimdiff='vim -d'
alias vim='nvim'
alias clear='clear && clear'

# File suffix shortcuts
alias -s php='vim'
alias -s css='vim'
alias -s scss='vim'
alias -s xml='vim'
alias -s json='vim'
alias -s yaml='vim'
alias -s yml='vim'
alias -s toml='vim'
alias -s md='vim'

alias -s js='vim'
alias -s ts='vim'
alias -s py='vim'
alias -s rb='vim'
alias -s java='vim'
alias -s go='vim'
alias -s rs='vim'
alias -s kt='vim'
alias -s cs='vim'
alias -s c='vim'
alias -s cpp='vim'
alias -s h='vim'
alias -s swift='vim'
alias -s dart='vim'
alias -s lua='vim'
alias -s sql='vim'
alias -s txt='vim'
alias -s pl='vim'
alias -s scala='vim'
alias -s jsx='vim'
alias -s tsx='vim'
alias -s vue='vim'
alias -s dockerfile='vim'
alias -s makefile='vim'
alias -s html='vim'
alias -s ini='vim'
alias -s cfg='vim'
alias -s conf='vim'
alias -s log='vim'

# Completion
if command -v kubectl >/dev/null; then
  source <(kubectl completion zsh)
fi
if command -v minikube >/dev/null; then
  source <(minikube completion zsh)
fi
if command -v kubecm >/dev/null; then
  source <(kubecm completion zsh)
fi
if command -v helm >/dev/null; then
  source <(helm completion zsh)
fi
if command -v kubecolor >/dev/null && (( $+functions[compdef] )); then
  compdef kubecolor=kubectl
fi

function command_not_found_handle {
  echo "Command not found. Skipping..." > /dev/null
}
