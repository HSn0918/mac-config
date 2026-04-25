if type -q eza
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -lh --icons --group-directories-first'
    alias la='eza -a --icons --group-directories-first'
    alias 'l.'='eza -d .* --icons'
    alias lh='eza -l --sort=modified -h --icons --group-directories-first'
    alias lt='eza -T --level=2 --icons'
    alias lt3='eza -T --level=3 --icons'
    alias tree='eza -T --icons'
    alias lg='eza -la --git --icons --group-directories-first'
else
    alias ls='ls -G'
    alias ll='ls -alh'
    alias la='ls -A'
    alias lh='ls -alht'
    alias lt='find . -maxdepth 2 -print'
    alias lt3='find . -maxdepth 3 -print'
    alias tree='find . -print'
    alias lg='ls -alh'
end

if type -q nvim
    alias vim='nvim'
    alias vimdiff='nvim -d'
else
    alias vim='vim'
    alias vimdiff='vim -d'
end

if type -q lazygit
    alias lzg='lazygit'
end

if type -q yazi
    alias y='yazi'
end

alias bashconfig='vim ~/.bashfile'
alias zshconfig='vim ~/.zshrc'
alias fishconfig='vim ~/.config/fish/config.fish'
alias fishalias='vim ~/.config/fish/conf.d/20-aliases.fish'
alias ghosttyconfig='vim ~/.config/ghostty/config'
alias starshipconfig='vim ~/.config/starship.toml'
alias vimconfig='vim ~/.vimrc'
alias reloadfish='source ~/.config/fish/config.fish'

alias zed='open -a Zed'
alias code='code .'
alias cl='clear'
alias h='history'
alias py='python3'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias mkdir='mkdir -pv'
alias rd='rm -rf'
alias lds='du -sh * | sort -h'

if type -q rg
    alias grep='rg'
    alias egrep='rg'
    alias fgrep='rg -F'
else if type -q ggrep
    alias grep='ggrep --color=auto'
    alias egrep='ggrep -E --color=auto'
    alias fgrep='ggrep -F --color=auto'
end
if type -q fd
    alias findlarge='fd --size +100m'
else
    alias findlarge='find . -type f -size +100M'
end

alias now='date "+%Y-%m-%d %H:%M:%S"'
alias today='date "+%Y-%m-%d"'

alias mv='mv -i'
alias cp='cp -ir'
alias ln='ln -i'
alias rm='rm -i'

alias topcpu='ps aux | sort -nrk 3 | head -10'
alias topmem='ps aux | sort -nrk 4 | head -10'
alias df='df -h'
alias du='du -h'
alias ports='lsof -nP -iTCP -sTCP:LISTEN'
alias myip='curl -fsSL ifconfig.me'
alias pingtest='ping -c 4 8.8.8.8'
alias ip='ipconfig getifaddr en0'

alias k='kubectl'
alias kg='kubectl get'
alias kgp='kubectl get pods'
alias kgpo='kubectl get pods'
alias kgn='kubectl get nodes'
alias kgnw='kubectl get nodes -o wide'
alias kgd='kubectl get deployment'
alias kgdw='kubectl get deployment -o wide'
alias kgs='kubectl get svc'
alias kgsw='kubectl get svc -o wide'
alias kdp='kubectl describe pod'
alias kdd='kubectl describe deployment'
alias kds='kubectl describe service'
alias kdn='kubectl describe node'
alias ke='kubectl edit'
alias ktpm='kubectl top pod --all-namespaces --sort-by=memory'
alias ktpc='kubectl top pod --all-namespaces --sort-by=cpu'
alias ks='kubectl -n kube-system'
alias ksg='kubectl -n kube-system get'
alias ksgp='kubectl -n kube-system get pods'
alias ksgpo='kubectl -n kube-system get pods'
alias ksgd='kubectl -n kube-system get deployment'
alias kl='kubectl logs'
alias klf='kubectl logs -f'
alias klf1='kubectl logs -f --tail=1'
alias klf10='kubectl logs -f --tail=10'
alias klf100='kubectl logs -f --tail=100'
alias klp='kubectl logs -p'
alias klt='kubectl logs --tail=50'
alias ka='kubectl apply -f'
alias kdel='kubectl delete'
alias kcf='kubectl create -f'
alias kr='kubectl rollout restart'
alias krd='kubectl rollout status deployment'
alias kns='kubectl config set-context --current --namespace'
alias kge='kubectl get events --sort-by=.lastTimestamp'
alias kw='kubectl get --watch'
alias kgwl='kubectl get pods -o wide --watch'
alias kgcrd='kubectl get crd'
alias kgjp='kubectl get pods -o json | jq'
alias kgjd='kubectl get deployment -o json | jq'
alias kdfp='kubectl delete pod --field-selector=status.phase=Failed'
alias kres='kubectl rollout restart deployment'
alias kctx='kubectl config get-contexts'
alias kcx='kubectl config use-context'
alias kgns='kubectl get namespaces'
alias kcfg='kubectl config view --minify'
alias ktn='kubectl top nodes'

if type -q kubecolor
    alias kubectl='kubecolor'
end

if type -q kubecm
    alias kc='kubecm'
    alias kcs='kubecm switch'
end

alias dps='docker ps'
alias di='docker images'
alias dstart='docker start'
alias dstop='docker stop'
alias drm='docker rm'
alias drmi='docker rmi'
alias dlog='docker logs -f'
alias dvol='docker volume ls'

function timestamp
    set -l current_epoch (date +%s)
    set -l current_ms (math "$current_epoch * 1000")
    printf "%s\n" (date "+%Y-%m-%d %H:%M:%S")
    printf "s: %s\n" "$current_epoch"
    printf "ms: %s\n" "$current_ms"
end

function git_loc_since --argument-names since_range
    git log --author="hsn" --since="$since_range" --pretty=tformat: --numstat -- . ":(exclude)vendor" ":(exclude)static/bower_components" | \
        awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added %s lines, removed %s lines, net %s lines\n", add, subs, loc }'
end

function daygit
    git_loc_since "1 day ago"
end

function weekgit
    git_loc_since "1 week ago"
end

function monthgit
    git_loc_since "1 month ago"
end

function yeargit
    git_loc_since "1 year ago"
end

function allgit
    git log --author="hsn" --pretty=tformat: --numstat -- . ":(exclude)vendor" ":(exclude)static/bower_components" | \
        awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added %s lines, removed %s lines, net %s lines\n", add, subs, loc }'
end
