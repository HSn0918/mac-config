# mac-config

> mac-config 是一个用于管理 macOS 系统开发环境的配置项目，包含常见的配置文件、环境变量、以及工具的初始化设置。

## 目录结构

```
mac-config/
├── nvim/               # Neovim 配置文件夹
├── .gitconfig          # Git 配置文件
├── .ideavimrc         # IntelliJ IDEA 的 Vim 模式配置文件
├── .npmrc             # npm 配置文件，存储 npm 注册表和认证信息
├── .vimrc             # Vim 编辑器的配置文件
├── .zprofile          # Zsh 登录 Shell 的配置文件
├── .zshrc             # Zsh 交互式 Shell 的配置文件
├── docker.json        # Docker 配置文件
├── go.env             # Go 语言环境变量配置文件
└── README.md          # 项目说明文件
```

## 文件说明

### 1. nvim/
Neovim 文件夹包含 Neovim 的配置文件和插件管理设置，用于自定义和优化 Neovim 编辑器。

### 2. .gitconfig
Git 全局配置文件，用于设置 Git 用户名、邮箱、别名等。

### 3. .ideavimrc
IntelliJ IDEA 的 Vim 模式配置文件，用于配置快捷键和常用命令。

### 4. .npmrc
npm 的配置文件，可用来设置：
- 私有 npm 注册表
- 缓存目录
- npm Token

### 5. .vimrc
Vim 的配置文件，包含快捷键、主题和常用设置。

### 6. .zprofile
Zsh 登录 Shell 的配置文件，在启动登录 Shell 时执行，常用于设置环境变量。

### 7. .zshrc
Zsh 的交互式配置文件，包含别名、路径、插件和主题配置。

### 8. docker.json
Docker 的配置文件，用于配置 Docker 守护进程的选项，例如镜像加速器。

### 9. go.env
Go 语言相关的环境变量文件，可用来设置 Go 的工作区路径和代理。

## 使用方法

### 1. 克隆项目
```bash
git clone https://github.com/hsn0918/mac-config.git
cd mac-config
```

### 2. 复制配置文件
```bash
cp .gitconfig ~/.gitconfig
cp .zshrc ~/.zshrc
cp .vimrc ~/.vimrc
```

### 3. 自定义配置
```bash
vim .zshrc  # 根据需要编辑对应文件
```

### 4. 重新加载配置
```bash
source ~/.zshrc
```

## 环境要求

- **操作系统**
  - macOS

- **必需工具**
  - Neovim 或 Vim
  - Git
  - Zsh
  - Docker
  - Go

## 贡献

欢迎提交 issue 和 PR，以改进项目的功能或文档。

## 许可证

[MIT License](LICENSE)
