# 用户默认设置
DEFAULT_USER="HSn"  # 设置默认用户名称

# Zsh 和环境变量配置
export ZSH="$HOME/.oh-my-zsh"  # Oh My Zsh 的安装路径
export GOPATH="$HOME/go"  # Go 工作目录
export JAVA_HOME="/opt/homebrew/opt/openjdk@11"  # Java 安装路径
export NVM_DIR="$HOME/.nvm"  # NVM 路径
export PATH=$PATH:$GOPATH/bin:/usr/local/mysql/bin:$JAVA_HOME/bin  # Go、MySQL、Java 路径
export PATH=$PATH:/opt/homebrew/opt/icu4c/bin:/opt/homebrew/opt/icu4c/sbin  # ICU 工具路径
export PATH=$PATH:"${KREW_ROOT:-$HOME/.krew}/bin"  # Kubernetes 插件管理工具路径
export BUILDKIT_NO_CLIENT_TOKEN=true  # 禁用 BuildKit 客户端令牌
export PATH=$PATH:$(npm bin -g)
# 启用 NVM（Node Version Manager）
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # 加载 NVM 主脚本
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # 加载 NVM 自动补全

# Zsh 设置
ZSH_THEME="robbyrussell"  # 设置 Zsh 的主题
plugins=(  # 加载的插件列表
    git                  # Git 工具，增强 git 命令功能
    jsontools            # JSON 工具，格式化和操作 JSON 数据
    zsh-autosuggestions  # 自动补全建议，提高输入效率
    zsh-syntax-highlighting  # 命令语法高亮，便于快速检查命令
    vscode               # VSCode 集成
    emoji-clock          # 时间表情插件，显示当前时间的表情
    aliases              # 快捷别名管理
    web-search           # 快速执行 Web 搜索
    history-substring-search  # 历史命令快速模糊搜索
    sudo                 # 输入 `!!` 快速提升为 `sudo` 权限
    tmux                 # 提供 tmux 支持和快捷键补全
    fzf                  # 使用 fzf 进行模糊搜索和导航
    macos
)


source $ZSH/oh-my-zsh.sh  # 加载 Oh My Zsh

# Shell 和颜色设置
export SHELL=$(which zsh)  # 设置默认 shell 为 Zsh
export CLICOLOR=1  # 启用颜色显示
# export LSCOLORS=ExGxFxdaCxDaDahbadeche  # 配置 ls 命令的颜色

# 禁用命令自动纠正
unsetopt correct correct_all  # 禁用命令自动纠正功能

# 快捷命令
alias bashconfig="vim ~/.bashfile"  # 快速打开 bash 配置文件
alias zshconfig="vim ~/.zshrc"  # 快速打开 zsh 配置文件
alias vimconfig="vim ~/.vimrc"  # 快速打开 vim 配置文件

# 别名分类 ================================================

## 1. 文件与目录操作
alias ls='ls --color=auto'  # 启用 ls 的颜色
alias ll='ls -lh --color=auto'  # 详细显示文件信息，单位人性化
alias la='ls -a --color=auto'  # 显示隐藏文件
alias lsa='ls -la --color=auto'  # 显示所有文件详细信息
alias l.= 'ls -d .* --color=auto'  # 列出隐藏文件夹
alias lh='ls -alths --color=auto'  # 详细信息按修改时间排序
alias ..='cd ..'  # 返回上一级目录
alias ...='cd ../../..'  # 返回上三层目录
alias mkdir='mkdir -pv'  # 递归创建目录并显示
alias rd='rm -rf'  # 删除目录或文件
alias tree='tree --charset ASCII'  # 显示目录树结构

## 2. 搜索相关
alias grep='grep --color=auto'  # 搜索并高亮显示匹配内容
alias egrep='egrep --color=auto'  # 增强版 grep
alias fgrep='fgrep --color=auto'  # 快速版 grep
alias findlarge='find . -type f -size +100M'  # 搜索当前目录中大于 100MB 的文件

## 3. 时间与日期
alias now='date "+%Y-%m-%d %H:%M:%S.%s"'  # 显示当前时间，带毫秒
alias today='date "+%Y-%m-%d"'  # 显示当前日期
alias timestamp='now; echo s: $(date +"%s"); echo ms: $(expr $(date +%s%N) / 1000000)'  # 显示时间戳

## 4. 安全设置（危险命令加确认）
alias mv='mv -i'  # 移动文件前确认
alias cp='cp -i'  # 复制文件前确认
alias ln='ln -i'  # 创建链接前确认
alias rm='rm -i'  # 删除文件前确认

## 5. 系统资源监控
alias topcpu='ps aux --sort=-%cpu | head -10'  # 显示 CPU 占用最高的 10 个进程
alias topmem='ps aux --sort=-%mem | head -10'  # 显示内存占用最高的 10 个进程
alias df='df -h'  # 显示磁盘使用情况，单位人性化
alias du='du -h'  # 显示文件夹大小
alias free='free -h'  # 显示内存使用
alias iotop='iotop -o'  # 显示 I/O 使用情况

## 6. 网络相关
alias myip='curl ifconfig.me'  # 获取外网 IP
alias ports='netstat -tulanp'  # 查看监听端口
alias pingtest='ping -c 4 8.8.8.8'  # 测试网络连接
alias ss='sudo ss -tuln'  # 检查监听端口
alias ip='ipconfig getifaddr en0'

## 7. Kubernetes 命令
alias kubectl="kubecolor"
alias kc='kubecm'
alias kcs='kubecm switch'
alias k="kubectl"
alias kg="kubectl get"
alias kgp="kubectl get pods"
alias kgpo="kubectl get pods"
alias kgn="kubectl get nodes -o wide"
alias kgd="kubectl get deployment -o wide"
alias kgs="kubectl get svc -o wide"
alias kdp="kubectl describe pod"
alias kdd="kubectl describe deployment"
alias kds="kubectl describe service"
alias kdn="kubectl describe node"
alias ke="kubectl edit"
alias ktpm="kubectl top pod --all-namespaces --sort-by=memory"
alias ktpc="kubectl top pod --all-namespaces --sort-by=cpu"

## 8. Docker 命令
alias dps='docker ps'  # 查看运行中的容器
alias di='docker images'  # 查看镜像
alias dstart='docker start'  # 启动容器
alias dstop='docker stop'  # 停止容器
alias drm='docker rm'  # 删除容器
alias drmi='docker rmi'  # 删除镜像
alias dlog='docker logs -f'  # 实时查看容器日志
alias dvol='docker volume ls'  # 查看所有 volumes

## 9. Git 提交统计
alias daygit='git log --author="hsn" --since="1 day ago" --pretty=tformat: --numstat -- . ":(exclude)vendor" ":(exclude)static/bower_components" | awk '\''{ add += $1; subs += $2; loc += $1 - $2 } END { printf "今天git增加了 %s 行, 删除了 %s 行, 总共修改了 %s 行\n", add, subs, loc }'\'''
alias weekgit='git log --author="hsn" --since="1 week ago" --pretty=tformat: --numstat -- . ":(exclude)vendor" ":(exclude)static/bower_components" | awk '\''{ add += $1; subs += $2; loc += $1 - $2 } END { printf "本周git增加了 %s 行, 删除了 %s 行, 总共修改了 %s 行\n", add, subs, loc }'\'''
alias monthgit='git log --author="hsn" --since="1 month ago" --pretty=tformat: --numstat -- . ":(exclude)vendor" ":(exclude)static/bower_components" | awk '\''{ add += $1; subs += $2; loc += $1 - $2 } END { printf "本月git增加了 %s 行, 删除了 %s 行, 总共修改了 %s 行\n", add, subs, loc }'\'''
alias yeargit='git log --author="hsn" --since="1 year ago" --pretty=tformat: --numstat -- . ":(exclude)vendor" ":(exclude)static/bower_components" | awk '\''{ add += $1; subs += $2; loc += $1 - $2 } END { printf "今年git增加了 %s 行, 删除了 %s 行, 总共修改了 %s 行\n", add, subs, loc }'\'''
alias allgit='git log --author="hsn" --pretty=tformat: --numstat -- . ":(exclude)vendor" ":(exclude)static/bower_components" | awk '\''{ add += $1; subs += $2; loc += $1 - $2 } END { printf "git总共增加了 %s 行, 删除了 %s 行, 总共修改了 %s 行\n", add, subs, loc }'\'''

## 10. 开发工具
alias cl='clear'  # 清屏
alias h='history'  # 查看历史命令
alias py='python3'  # 简化 Python3 调用
alias code='code .'  # 打开 VSCode 当前目录
alias vimdiff='vim -d'  # 使用 vim 比较文件差异
alias vim='nvim'  # 使用 nvim 替代 vim
# 文件类型快捷打开方式
alias -s sh='vim'      # Shell 脚本
alias -s php='vim'     # PHP 文件
alias -s css='vim'     # CSS 样式文件
alias -s scss='vim'    # SCSS 样式文件
alias -s xml='vim'     # XML 文件
alias -s json='vim'    # JSON 文件
alias -s yaml='vim'    # YAML 文件
alias -s yml='vim'     # YAML 文件（简写）
alias -s toml='vim'    # TOML 文件
alias -s md='vim'      # Markdown 文件

# 新增主流编程语言支持
alias -s js='vim'      # JavaScript 文件
alias -s ts='vim'      # TypeScript 文件
alias -s py='vim'      # Python 文件
alias -s rb='vim'      # Ruby 文件
alias -s java='vim'    # Java 文件
alias -s go='vim'      # Go 文件
alias -s rs='vim'      # Rust 文件
alias -s kt='vim'      # Kotlin 文件
alias -s cs='vim'      # C# 文件
alias -s c='vim'       # C 文件
alias -s cpp='vim'     # C++ 文件
alias -s h='vim'       # C/C++ 头文件
alias -s swift='vim'   # Swift 文件
alias -s dart='vim'    # Dart 文件
alias -s lua='vim'     # Lua 文件
alias -s sql='vim'     # SQL 文件
alias -s txt='vim'     # 文本文件
alias -s pl='vim'      # Perl 文件
alias -s rb='vim'      # Ruby 文件
alias -s scala='vim'   # Scala 文件
alias -s jsx='vim'     # JSX 文件
alias -s tsx='vim'     # TSX 文件
alias -s vue='vim'     # Vue.js 文件
alias -s dockerfile='vim' # Dockerfile
alias -s makefile='vim' # Makefile
alias -s html='vim'    # HTML 文件
alias -s ini='vim'     # INI 配置文件
alias -s cfg='vim'     # 配置文件
alias -s conf='vim'    # 通用配置文件
alias -s log='vim'     # 日志文件


autoload -U compinit && compinit
source <(goctl completion zsh)
source <(kubectl completion zsh)
source <(minikube completion zsh)
source <(kubecm completion zsh)
source <(cue completion zsh)
source <(helm completion zsh)
compdef kubecolor=kubectl
function command_not_found_handle {
    echo "Command not found. Skipping..." > /dev/null
}
