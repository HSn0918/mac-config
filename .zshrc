DEFAULT_USER="HSn"  # Default prompt user

# Enable Powerlevel10k instant prompt. Keep this close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Zsh and environment
export ZSH="$HOME/.oh-my-zsh"
export GOPATH="$HOME/go"
export NVM_DIR="$HOME/.nvm"
export BUN_INSTALL="$HOME/.bun"
export PATH="/opt/homebrew/bin:$PATH:/opt/homebrew/bin/npx"
export PATH="$HOME/.local/bin:$PATH"

# Load private tokens and machine-local overrides from ~/.zshrc.local.
# Keep secrets, proxies and private endpoints out of this repo.
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

export PATH=$PATH:$GOPATH/bin:/usr/local/mysql/bin
[[ -n "$JAVA_HOME" ]] && export PATH=$PATH:$JAVA_HOME/bin
export PATH=$PATH:/opt/homebrew/opt/icu4c/bin:/opt/homebrew/opt/icu4c/sbin
export PATH=$PATH:"${KREW_ROOT:-$HOME/.krew}/bin"
[[ -n "$BUN_INSTALL" ]] && export PATH="$BUN_INSTALL/bin:$PATH"

export BUILDKIT_NO_CLIENT_TOKEN=true
export EDITOR="nvim"
export CLICOLOR=1

[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

typeset -U path PATH

ZSH_COMPLETION_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/completions"
[[ -d "$ZSH_COMPLETION_CACHE_DIR" ]] || command mkdir -p "$ZSH_COMPLETION_CACHE_DIR"
fpath=("$ZSH_COMPLETION_CACHE_DIR" $fpath)

cache_completion() {
  local cmd="$1"
  shift
  local cache_file="$ZSH_COMPLETION_CACHE_DIR/_${cmd}"

  (( $+commands[$cmd] )) || return 0

  if [[ ! -s "$cache_file" || ${commands[$cmd]} -nt "$cache_file" ]]; then
    "$cmd" "$@" >| "$cache_file" 2>/dev/null || {
      command rm -f "$cache_file"
      return 0
    }
  fi
}

cache_completion kubectl completion zsh
cache_completion kubecm completion zsh
cache_completion helm completion zsh
cache_completion buf completion zsh
cache_completion dagger completion zsh
cache_completion sqlc completion zsh
cache_completion kwok completion zsh
cache_completion kwokctl completion zsh
cache_completion talosctl completion zsh
cache_completion kubebuilder completion zsh
cache_completion jj util completion zsh
cache_completion railway completion zsh

# Zsh settings
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(
  git
  jsontools
  vscode
  emoji-clock
  aliases
  web-search
  history-substring-search
  sudo
  tmux
  fzf
  macos
  autojump
)

source "$ZSH/oh-my-zsh.sh"
[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

# Shell behavior
unsetopt correct correct_all
bindkey -v
KEYTIMEOUT=10

# Keep common Ctrl shortcuts available in insert mode so mistyped keys
# don't get inserted as literal control characters such as ^A.
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line
bindkey -M viins '^W' backward-kill-word
bindkey -M viins '^U' backward-kill-line
bindkey -M viins '^K' kill-line
bindkey -M viins '^R' history-incremental-search-backward
bindkey -M viins '^P' up-line-or-history
bindkey -M viins '^N' down-line-or-history
bindkey -M viins '^B' backward-char
bindkey -M viins '^F' forward-char
bindkey -M viins '^L' clear-screen

# Config shortcuts
alias bashconfig="vim ~/.bashfile"
alias zshconfig="vim ~/.zshrc"
alias vimconfig="vim ~/.vimrc"

# Apps
alias zed='open -a Zed'

# File and directory
alias ls='eza --icons'
alias ll='eza -lh --icons'
alias la='eza -a --icons'
alias l.='eza -d .* --icons'
alias lh='eza -l --sort=modified -h --icons'
alias lt='eza -T --level=2 --icons'
alias lt3='eza -T --level=3 --icons'
alias tree='eza -T --icons'
alias ..='cd ..'
alias ...='cd ../../..'
alias mkdir='mkdir -pv'
alias rd='rm -rf'
alias lds='du -sh * | sort -h'
alias lg='eza -la --git --icons'

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

if (( $+commands[kubecolor] )); then
  alias kubectl="kubecolor"
fi

if (( $+commands[kubecm] )); then
  alias kc='kubecm'
  alias kcs='kubecm switch'
fi

if (( $+commands[kubefwd] )); then
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
alias daygit='git log --author="hsn" --since="1 day ago" --pretty=tformat: --numstat -- . ":(exclude)vendor" ":(exclude)static/bower_components" | awk '\''{ add += $1; subs += $2; loc += $1 - $2 } END { printf "今天git增加了 %s 行, 删除了 %s 行, 总共修改了 %s 行\n", add, subs, loc }'\'''
alias weekgit='git log --author="hsn" --since="1 week ago" --pretty=tformat: --numstat -- . ":(exclude)vendor" ":(exclude)static/bower_components" | awk '\''{ add += $1; subs += $2; loc += $1 - $2 } END { printf "本周git增加了 %s 行, 删除了 %s 行, 总共修改了 %s 行\n", add, subs, loc }'\'''
alias monthgit='git log --author="hsn" --since="1 month ago" --pretty=tformat: --numstat -- . ":(exclude)vendor" ":(exclude)static/bower_components" | awk '\''{ add += $1; subs += $2; loc += $1 - $2 } END { printf "本月git增加了 %s 行, 删除了 %s 行, 总共修改了 %s 行\n", add, subs, loc }'\'''
alias yeargit='git log --author="hsn" --since="1 year ago" --pretty=tformat: --numstat -- . ":(exclude)vendor" ":(exclude)static/bower_components" | awk '\''{ add += $1; subs += $2; loc += $1 - $2 } END { printf "今年git增加了 %s 行, 删除了 %s 行, 总共修改了 %s 行\n", add, subs, loc }'\'''
alias allgit='git log --author="hsn" --pretty=tformat: --numstat -- . ":(exclude)vendor" ":(exclude)static/bower_components" | awk '\''{ add += $1; subs += $2; loc += $1 - $2 } END { printf "git总共增加了 %s 行, 删除了 %s 行, 总共修改了 %s 行\n", add, subs, loc }'\'''

# Dev tools
alias cl='clear'
alias h='history'
alias py='python3'
alias code='code .'
alias vimdiff='vim -d'
alias vim='nvim'

# Suffix aliases
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

(( $+commands[kubecolor] )) && compdef kubecolor=kubectl

function command_not_found_handle {
  return 127
}

# Load interactive zsh widgets last so they can wrap self-insert/accept-line correctly.
if [[ -f "$ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "$ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
elif [[ -f "$ZSH/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "$ZSH/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

if [[ -f "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
elif [[ -f "$ZSH/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "$ZSH/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
