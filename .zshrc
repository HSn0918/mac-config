DEFAULT_USER="HSn"
export ZSH="$HOME/.oh-my-zsh"
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/usr/local/mysql/bin
export NVM_DIR="$HOME/.nvm"
export SHELL=$(which zsh)
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
export CLICOLOR=1
export LSCOLORS=ExGxFxdaCxDaDahbadeche
export BUILDKIT_NO_CLIENT_TOKEN=true
export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"
export PATH="/opt/homebrew/opt/icu4c/bin:$PATH"
export PATH="/opt/homebrew/opt/icu4c/sbin:$PATH"
export JAVA_HOME=/Users/hsn/Library/Java/JavaVirtualMachines/graalvm-jdk-23.0.1/Contents/Home
export PATH=$JAVA_HOME/bin:$PATH
export PATH="$GRAALVM_HOME/bin:$PATH"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
. "$HOME/.cargo/env"
ZSH_THEME="robbyrussell"
plugins=(
    git
    jsontools
    zsh-autosuggestions
    zsh-syntax-highlighting
    vscode
    emoji-clock
    aliases
    web-search
)
source $ZSH/oh-my-zsh.sh
setopt CORRECT_ALL
alias bashconfig="vim ~/.bashfile"
alias zshconfig="vim ~/.zshrc"
alias vimconfig="vim ~/.vimrc"
#实时补全
autoload -U compinit; compinit
source <(goctl completion zsh)
source <(kubectl completion zsh)
source <(minikube completion zsh)
source <(kubecm completion zsh)
source <(cue completion zsh)
source <(helm completion zsh)
compdef kubecolor=kubectl
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

##alias
alias apigen='goctl api go -api *.api -dir ../  --style=goZero'

## 1 - ls
# 带颜色设置
alias ls='ls --color=auto'
# 长格式输出
alias ll='ls -l --color=auto'
# 显示隐藏文件
alias l.='ls -ld .* --color=auto'
# 长格式显示所有文件，按照时间倒序并显示每个文件的容量
alias lh='ls -alths --color=auto'
#
alias la='ll -A'
## 2 - cd
# 避免日常手误
alias cd..='cd ..'
# 退出当前目录
alias ..='cd ..'
alias ...='cd ../../..'
alias ....='cd ../../../..'
alias .....='cd ../../../..'
alias .2='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

## 3 - grep
# 带颜色设置
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

## 5 - mkdir
# 创建级联目录并打印
alias mkdir='mkdir -pv'

## 7 - date
alias now='date "+%Y-%m-%d %H:%M:%S.%s"'
# 获取秒和毫秒的时间戳，时间戳转换为时间：date "+%Y-%m-%d %H:%M:%S" -d @1619503315
alias timestamp='now; echo s: $(date +"%s"); echo ms: $(echo `expr \`date +%s%N\` / 1000000`)'
## 8 - vim
alias vi=vim
alias ports='netstat -tulan'
## 10 - 危险命令安全设置,
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'
## 12 - 磁盘、内存、CPU、进程监控
alias psg='ps -e | grep '
# 仅显示当前用户的进程
alias psme='ps -e| grep $USER --color=always '
# 磁盘
alias du1='du -h -d 1'
alias du2='du -h -d 2'
alias du3='du -h -d 3'
# 内存信息
alias meminfo='free -h -l -t'
# cpu信息
alias cpuinfo='lscpu'
# 获取占用内存的进程排名
alias psmem='ps aux | sort -nr -k 4'
alias psmem10='ps aux | sort -nr -k 4 | head -10'
# 获取占用 cpu 的进程排名
alias pscpu='ps aux | sort -nr -k 3'
alias pscpu10='ps aux | sort -nr -k 3 | head -10'
# 磁盘、内存、端口情况
## 13 - 短命令
alias h='history'
alias j='jobs -l'
## 15 - other
alias ping="time ping"
alias nocomment='grep -Ev "^(#|$)"'
alias tf='tail -f '
## 16 - etcd
alias etcdc='etcdctl'
## 17 - kubernetes
alias kubectl="kubecolor"
alias kc='kubecm'
alias kcs='kubecm switch'
alias k="kubectl"
alias kk='kubectl kui'
alias kgp='kubectl get pod'
alias ks='kubectl -n kube-system'
alias kt='kubectl top'
alias kl='kubectl logs'
alias ksl='kubectl -n kube-system logs'
alias kst='kubectl -n kube-system top'
alias po='pod'
alias kg='kubectl get'
alias kgpo='kubectl get pods'
alias kgn="kubectl get nodes -o wide"
alias kgp="kubectl get pods -o wide"
alias kgd="kubectl get deployment -o wide"
alias kgs="kubectl get svc -o wide"
alias kdp="kubectl describe pod"
alias kdd="kubectl describe deployment"
alias kds="kubectl describe service"
alias kdn="kubectl describe node"
alias ke="kubectl edit"
alias ktpm="kubectl top pod --all-namespaces --sort-by=memory"
alias ktpc="kubectl top pod --all-namespaces --sort-by=cpu"
# minikube
# head and tail and sed
alias sed='sed -n'
# tree
alias tree='tree --charset ASCII'
# history
setopt hist_ignore_space
alias cd=" cd"
alias ls=" ls"
# ip
alias ip='ipconfig getifaddr en0'
# dtm
alias dtm='dtm -c /opt/homebrew/etc/dtm.yml'
# vim 快速打开文件
alias -s sh='vim'       # Shell 脚本
alias -s php='vim'      # PHP 文件
alias -s css='vim'      # CSS 文件
alias -s scss='vim'     # SCSS 文件
alias -s xml='vim'      # XML 文件
alias -s json='vim'     # JSON 文件
alias -s yaml='vim'     # YAML 文件
alias -s yml='vim'      # YAML 文件（YAML 文件的另一个常见扩展名）
alias -s toml='vim'     # TOML 文件
alias -s md='vim'       # Markdown 文件
alias -s sql='vim'      # SQL 文件
alias -s swift='vim'    # Swift 文件
alias -s go='vim'       # Go 文件
alias -s rs='vim'       # Rust 文件
alias -s kt='vim'       # Kotlin 文件
alias -s pl='vim'       # Perl 文件
alias -s lua='vim'      # Lua 文件
alias -s rb='vim'       # Ruby 文件
alias -s py='vim'       # Python 文件
alias -s js='vim'       # JavaScript 文件
alias -s c='vim'        # C 文件
alias -s java='vim'     # Java 文件
alias -s txt='vim'      # 文本文件
alias -s h='vim'        # C/C++ 头文件
alias -s cpp='vim'      # C++ 文件
alias -s ts='vim'       # TypeScript 文件
# git commit
# 今天统计
alias daygit='git log --author="hsn" --since="1 day ago" --pretty=tformat: --numstat -- . ":(exclude)vendor" ":(exclude)static/bower_components" | \
awk '\''{ add += $1; subs += $2; loc += $1 - $2 } END { printf "今天git增加了 %s 行, 删除了 %s 行, 总共修改了 %s 行\n", add, subs, loc }'\'''
# 本周统计
alias weekgit='git log --author="hsn" --since="1 week ago" --pretty=tformat: --numstat -- . ":(exclude)vendor" ":(exclude)static/bower_components" | \
awk '\''{ add += $1; subs += $2; loc += $1 - $2 } END { printf "本周git增加了 %s 行, 删除了 %s 行, 总共修改了 %s 行\n", add, subs, loc }'\'''



# 本月提交的统计，排除 vendor 目录及其子目录
alias monthgit='git log --author="hsn" --since="1 month ago" --pretty=tformat: --numstat -- . ":(exclude)vendor" ":(exclude)static/bower_components" | \
awk '\''{ add += $1; subs += $2; loc += $1 - $2 } END { printf "本月git增加了 %s 行, 删除了 %s 行, 总共修改了 %s 行\n", add, subs, loc }'\'''

# 过去一年提交的统计，排除 vendor 目录及 static/bower_components 目录及其子目录
alias yeargit='git log --author="hsn" --since="1 year ago" --pretty=tformat: --numstat -- . ":(exclude)vendor" ":(exclude)static/bower_components" | \
awk '\''{ add += $1; subs += $2; loc += $1 - $2 } END { printf "今年git增加了 %s 行, 删除了 %s 行, 总共修改了 %s 行\n", add, subs, loc }'\'''

# 总共提交的统计（所有历史），排除 vendor 目录及 static/bower_components 目录及其子目录
alias allgit='git log --author="hsn" --pretty=tformat: --numstat -- . ":(exclude)vendor" ":(exclude)static/bower_components" | \
awk '\''{ add += $1; subs += $2; loc += $1 - $2 } END { printf "总共git增加了 %s 行, 删除了 %s 行, 总共修改了 %s 行\n", add, subs, loc }'\'''
