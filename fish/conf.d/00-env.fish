if test -x /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv fish)
else if test -x /usr/local/bin/brew
    eval (/usr/local/bin/brew shellenv fish)
end

set -gx GOPATH "$HOME/go"
set -gx NVM_DIR "$HOME/.nvm"
set -gx BUN_INSTALL "$HOME/.bun"
set -gx EDITOR nvim
set -gx CLICOLOR 1
set -gx BUILDKIT_NO_CLIENT_TOKEN true
set -gx HOMEBREW_PIP_INDEX_URL https://pypi.mirrors.ustc.edu.cn/simple
set -gx HOMEBREW_API_DOMAIN https://mirrors.ustc.edu.cn/homebrew-bottles/api
set -gx HOMEBREW_BOTTLE_DOMAIN https://mirrors.ustc.edu.cn/homebrew-bottles

set -l path_candidates \
    "$HOME/.local/bin" \
    "$GOPATH/bin" \
    "$HOME/.cargo/bin" \
    "$HOME/.bun/bin" \
    "$HOME/.fzf/bin" \
    "$HOME/.krew/bin" \
    /usr/local/mysql/bin \
    /opt/homebrew/opt/icu4c/bin \
    /opt/homebrew/opt/icu4c/sbin \
    "$HOME/Library/Application Support/JetBrains/Toolbox/scripts"

for candidate in $path_candidates
    if test -d "$candidate"
        fish_add_path -gP "$candidate"
    end
end

if set -q JAVA_HOME
    if test -d "$JAVA_HOME/bin"
        fish_add_path -gP "$JAVA_HOME/bin"
    end
end

if test -f "$HOME/.orbstack/shell/init2.fish"
    source "$HOME/.orbstack/shell/init2.fish"
end
