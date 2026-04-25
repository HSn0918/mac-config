set -g fish_greeting

if status is-interactive
    fish_vi_key_bindings

    set -g fish_cursor_default block
    set -g fish_cursor_insert line
    set -g fish_cursor_replace_one underscore
    set -g fish_cursor_visual block

    bind -M insert \ca beginning-of-line
    bind -M insert \ce end-of-line
    bind -M insert \cw backward-kill-word
    bind -M insert \cu backward-kill-line
    bind -M insert \ck kill-line
    bind -M insert \cp up-or-search
    bind -M insert \cn down-or-search
    bind -M insert \cb backward-char
    bind -M insert \cl clear-screen

    # Ctrl+R: fzf 历史搜索
    function fzf_history
        set selected (history | fzf --height 40% --layout=reverse --border)
        if test -n "$selected"
            commandline --replace -- $selected
        end
    end
    bind \cr fzf_history
    bind -M insert \cr fzf_history
    bind -M default \cr fzf_history

    # Ctrl+T: fzf 文件预览
    function fzf_file_preview
        set file (fd | fzf \
            --height 60% \
            --layout=reverse \
            --border \
            --preview 'bat --style=numbers --color=always {}' \
            --preview-window=right:60%)
        if test -n "$file"
            commandline --insert $file
        end
    end
    bind -M insert \ct fzf_file_preview

    # Alt+C: fzf 目录跳转
    function fzf_cd
        set dir (fd -t d | fzf --height 40% --layout=reverse --border --preview 'eza --icons --tree --level=2 {}')
        if test -n "$dir"
            cd $dir
        end
        commandline -f repaint
    end
    bind \ec fzf_cd

    # Ctrl+F: fzf + rg 全文搜索，跳转到 nvim
    function fzf_rg_preview
        set result (rg --line-number --no-heading "" | \
            fzf \
            --delimiter ':' \
            --height 60% \
            --layout=reverse \
            --border \
            --preview 'bat --color=always {1} --highlight-line {2}' \
            --preview-window=right:60%)
        if test -n "$result"
            set file (echo $result | cut -d: -f1)
            set line (echo $result | cut -d: -f2)
            nvim +$line $file
        end
    end
    bind -M insert \cf fzf_rg_preview

    # Ctrl+G: fzf git 分支切换
    function fzf_git_branch
        set branch (git branch 2>/dev/null | sed 's/* //' | string trim | fzf --height 40% --layout=reverse --border)
        if test -n "$branch"
            git checkout $branch
        end
        commandline -f repaint
    end
    bind -M insert \cg fzf_git_branch

    if type -q zoxide
        zoxide init fish | source
    end

    if type -q atuin
        atuin init fish | source
    end

    if test -f /opt/homebrew/share/autojump/autojump.fish
        source /opt/homebrew/share/autojump/autojump.fish
    end

    if type -q starship
        starship init fish | source
    end
end

if test -f "$HOME/.config/fish/config.local.fish"
    source "$HOME/.config/fish/config.local.fish"
end
