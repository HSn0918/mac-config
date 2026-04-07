if status is-interactive
# Commands to run in interactive sessions can go here
end

# ── PATH & Environment ──────────────────────────────────────────────────────
fish_add_path /opt/homebrew/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.bun/bin
fish_add_path $HOME/go/bin
fish_add_path /usr/local/mysql/bin
fish_add_path /opt/homebrew/opt/icu4c/bin
fish_add_path /opt/homebrew/opt/icu4c/sbin
fish_add_path $HOME/.krew/bin
fish_add_path /Volumes/Disk2TB/jetbrain

set -gx GOPATH $HOME/go
set -gx NVM_DIR $HOME/.nvm
set -gx BUN_INSTALL $HOME/.bun
set -gx BUN_INSTALL_CACHE_DIR /Volumes/Disk2TB/dev-cache/bun
set -gx EDITOR nvim
set -gx CLICOLOR 1
set -gx BUILDKIT_NO_CLIENT_TOKEN true
# set -gx DOC2X_APIKEY "your-doc2x-api-key"
# set -gx GITHUB_TOKEN "your-github-token"
# set -gx NPM_TOKEN "your-npm-token"

# ── NVM (via fisher nvm plugin or fallback to system node) ───────────────────
# nvm requires bass; if not available, node is managed via homebrew
set -gx NVM_DIR $HOME/.nvm

# ── Autojump ─────────────────────────────────────────────────────────────────
if test -f /opt/homebrew/share/autojump/autojump.fish
    source /opt/homebrew/share/autojump/autojump.fish
end

# ── fzf ──────────────────────────────────────────────────────────────────────
fish_add_path $HOME/.fzf/bin

# ── Vi mode ──────────────────────────────────────────────────────────────────
fish_vi_key_bindings
bind -M insert \ca beginning-of-line
bind -M insert \ce end-of-line
bind -M insert \cw backward-kill-word
bind -M insert \cu backward-kill-line
bind -M insert \ck kill-line
bind -M insert \cr history-search-backward
bind -M insert \cp up-or-search
bind -M insert \cn down-or-search
bind -M insert \cb backward-char
bind -M insert \cf forward-char
bind -M insert \cl clear-screen

# ── Starship ─────────────────────────────────────────────────────────────────
if command -q starship
    starship init fish | source
end

# ── Aliases: file & directory ────────────────────────────────────────────────
alias ls='eza --icons'
alias ll='eza -lh --icons'
alias la='eza -a --icons'
alias l.='eza -d .* --icons'
alias lh='eza -l --sort=modified -h --icons'
alias lt='eza -T --level=2 --icons'
alias lt3='eza -T --level=3 --icons'
alias tree='eza -T --icons'
alias lg='eza -la --git --icons'
alias ..='cd ..'
alias ...='cd ../../..'
alias mkdir='mkdir -pv'
alias rd='rm -rf'
alias lds='du -sh * | sort -h'

# ── Aliases: search ──────────────────────────────────────────────────────────
alias grep='rg'
alias findlarge='fd --size +100m'

# ── Aliases: time ────────────────────────────────────────────────────────────
alias now='date "+%Y-%m-%d %H:%M:%S"'
alias today='date "+%Y-%m-%d"'

# ── Aliases: safety ──────────────────────────────────────────────────────────
alias mv='mv -i'
alias cp='cp -ir'
alias ln='ln -i'
alias rm='rm -i'

# ── Aliases: system ──────────────────────────────────────────────────────────
alias df='df -h'
alias du='du -h'
alias myip='curl -s ifconfig.me'
alias ip='ipconfig getifaddr en0'
alias cl='clear'
alias h='history'
alias py='python3'
alias vim='nvim'

# ── Aliases: apps ────────────────────────────────────────────────────────────
alias zed='open -a Zed'
alias code='code .'

# ── Aliases: kubectl ─────────────────────────────────────────────────────────
if command -q kubecolor
    alias kubectl='kubecolor'
end
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
alias kl='kubectl logs'
alias klf='kubectl logs -f'
alias klf1='kubectl logs -f --tail=1'
alias klf10='kubectl logs -f --tail=10'
alias klf100='kubectl logs -f --tail=100'
alias klp='kubectl logs -p'
alias klt='kubectl logs --tail=50'
alias ka='kubectl apply -f'
alias kdel='kubectl delete'
alias kc='kubectl create -f'
alias kr='kubectl rollout restart'
alias krd='kubectl rollout status deployment'
alias kns='kubectl config set-context --current --namespace'
alias kge='kubectl get events --sort-by=.lastTimestamp'
alias kw='kubectl get --watch'
alias kgwl='kubectl get pods -o wide --watch'
alias kgcrd='kubectl get crd'
alias kdfp='kubectl delete pod --field-selector=status.phase=Failed'
alias kres='kubectl rollout restart deployment'
alias kctx='kubectl config get-contexts'
alias kcx='kubectl config use-context'
alias kgns='kubectl get namespaces'
alias kcfg='kubectl config view --minify'
alias ktn='kubectl top nodes'

if command -q kubecm
    alias kc='kubecm'
    alias kcs='kubecm switch'
end

# ── Aliases: docker ──────────────────────────────────────────────────────────
alias dps='docker ps'
alias di='docker images'
alias dstart='docker start'
alias dstop='docker stop'
alias drm='docker rm'
alias drmi='docker rmi'
alias dlog='docker logs -f'
alias dvol='docker volume ls'
