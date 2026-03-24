# mac-config

> macOS 开发环境配置仓库，包含 shell、tmux、编辑器和常用工具配置。

## 目录结构

```text
mac-config/
├── nvim/                 # Neovim 配置
├── .gitconfig            # Git 配置
├── .ideavimrc            # IdeaVim 配置
├── .npmrc                # npm registry 配置
├── .p10k.zsh             # Powerlevel10k 主题
├── .tmux.conf            # tmux 配置
├── .vimrc                # Vim 配置
├── .zprofile             # Zsh login shell 配置
├── .zshrc                # Zsh interactive 配置
├── .zshrc.local.example  # 本地私有变量模板
├── docker.json           # Docker 配置
├── go.env                # Go 环境变量
└── README.md             # 项目说明
```

## 说明

- `.zshrc` 是公开版，不包含 token、API key、私有服务地址。
- 私有变量统一放到 `~/.zshrc.local`，示例见 `.zshrc.local.example`。
- `.p10k.zsh` 是当前使用的 Powerlevel10k 主题配置。
- `.tmux.conf` 包含当前使用的 tmux 键位、路径继承和状态栏配置。

## 安装

1. 克隆仓库

```bash
git clone https://github.com/hsn0918/mac-config.git
cd mac-config
```

2. 复制常用配置

```bash
cp .gitconfig ~/.gitconfig
cp .zshrc ~/.zshrc
cp .p10k.zsh ~/.p10k.zsh
cp .tmux.conf ~/.tmux.conf
cp .vimrc ~/.vimrc
```

3. 创建本地私有配置

```bash
cp .zshrc.local.example ~/.zshrc.local
```

4. 按需填写 `~/.zshrc.local`

- Token
- API key
- 私有服务地址
- 代理
- 机器专属路径

5. 重新加载配置

```bash
exec zsh
tmux source-file ~/.tmux.conf
```

## 安全约定

- 不要把 token、API key、密码、私有 endpoint 提交到仓库。
- 所有敏感变量都只放在 `~/.zshrc.local`。
- 仓库中的 `.zshrc` 只保留可公开分享的默认配置。

## 环境要求

- macOS
- Zsh
- Oh My Zsh
- Powerlevel10k
- tmux
- Neovim 或 Vim

## 许可证

[MIT License](LICENSE)
