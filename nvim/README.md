# Neovim 配置使用文档

本仓库是个人 Neovim 配置（`lazy.nvim` 管理插件）。本文档按“能直接上手使用”的方式整理：如何启动、补全、LSP、自动导入、以及全部快捷键（包含冲突/覆盖说明）。

---

## 快速开始

1. 确保 `~/.config/nvim` 指向本配置（或把本仓库内容复制到 `~/.config/nvim`）。
2. 打开 Neovim：`nvim`
3. 首次启动会由 `lazy.nvim` 拉取插件（需要网络）。

### Leader 键

- `leader` = 空格（`vim.g.mapleader = " "`）

---

## 补全（nvim-cmp）

补全来源（按优先级）：
- LSP（`nvim_lsp`）
- Snippet（`luasnip`）
- Buffer（`buffer`）
- Path（`path`）

补全按键（插入模式）：
- `Tab`：选择下一个候选；若可展开/跳转 snippet 则展开/跳转；否则在有词时触发补全
- `S-Tab`：选择上一个候选；若可向后跳转 snippet 则跳转
- `Enter`：确认（默认选中当前项）
- `Ctrl-Space`：手动触发补全
- `Ctrl-j / Ctrl-k`：下一项 / 上一项
- `Ctrl-f / Ctrl-b`：补全文档下/上滚动
- `Option-Enter`：映射为 `Ctrl-Space`（等同“手动触发补全”）

---

## LSP（跳转/重构/诊断）

### 常用 LSP 按键（normal 模式，buffer 内生效）

- `gd`：跳转定义（definition）
- `gD`：跳转声明（declaration）
- `gi`：跳转实现（implementation）
- `K`：悬浮文档（hover）
- `gK`：签名帮助（signature help）
- `Space rn`：重命名（rename）
- `Space ca`：代码动作（code action，含 auto-import）
- `gr`：引用（references）
- `Space f`：格式化当前 buffer

### 诊断按键（global）

- `Space e`：浮窗显示诊断
- `[d / ]d`：上一个/下一个诊断
- `Space dl`：把诊断放入 location list

---

## 自动导入（Auto Import）

这里的“自动导入”分两类：

1. **补全/代码动作触发的导入**：通过 LSP 提供的 `code action` 或补全条目完成
2. **保存时整理 import**：在保存前触发 `source.organizeImports`（目前只在 `gopls` 的 `on_attach` 内启用）

### Go（gopls）

- 已开启 `completeUnimported = true`：补全会包含未导入符号
- 保存前会同步执行：
  - `source.organizeImports`（等价于 goimports 的“整理导入/排序/删除未用”能力）
  - `gopls` 格式化（开启 `gofumpt = true`，等价于 gofumpt 风格）

#### 安装 gofumpt / goimports（推荐）

macOS（Homebrew）：
- `brew install gofumpt`

goimports（官方建议用 go install）：
- `go install golang.org/x/tools/cmd/goimports@latest`

确保它们在 `PATH` 中（例如 `~/go/bin`）。

#### 可选：设置本地 import 分组（类似 goimports -local）

`gopls` 支持 `local`（用于把本项目包路径前缀分到单独一组）。例如你的 module 是 `github.com/acme/foo`，可在 `lua/lsp.lua` 的 `gopls.settings.gopls` 增加：

```lua
local = "github.com/acme/foo",
```

---

### Rust（rust-analyzer）

- 已开启 `completion.autoimport.enable = true`
- 推荐用 `Space ca` 选择 `Import ...` 类动作完成导入

### JS/TS/Vue（volar）

- 导入主要依赖 `Space ca` 的 code action（例如 `Add import ...`）
- 若你需要更完整的 TypeScript 语言服务（非 Vue 文件），可额外配置 `ts_ls`（本配置当前未显式启用）

---

## 插件功能与快捷键

### 文件树（nvim-tree）

- `Space t`：切换文件树
- `F2`：切换文件树

### Telescope

- `Ctrl-p`：查找文件（`Telescope find_files`）
- `Ctrl-f`：全局搜索（`Telescope live_grep`）

### kubectl.nvim

- `Space k`：打开/关闭 kubectl 面板（`require("kubectl").toggle()`）

提示：
- kubectl.nvim 需要 native 二进制 `kubectl_client`。本配置使用 release tag（`version = "2.*"`）+ `saghen/blink.download` 自动下载。
- 若打开时报错，优先运行 `:checkhealth kubectl`。

### Go Impl（go-impl.nvim）

- `Space Gi`：打开 Go Impl 窗口（`require("go-impl").open()`）
- `Space i`：执行 `:GoImplOpen`（同类功能，可能与上面重复）

---

## 编辑/窗口/终端快捷键

### 窗口与分屏

- `sv`：垂直分屏（`:vsp`）
- `sh`：水平分屏（`:sp`）
- `sc`：关闭当前窗口
- `so`：关闭其他窗口

窗口缩放：
- `s, / s.`：左右缩放（`vertical resize -20 / +20`）
- `sj / sk`：上下缩放（`resize +10 / -10`）
- `s=`：等比例

### 窗口切换（macOS Option 键）

可选：使用 macOS Option 键切换窗口（等价于 `Ctrl-w h/j/k/l`）：

- `Option-w`：在窗口间循环（`<C-w>w`）
- `Option-h/j/k/l`：切换到左/下/上/右窗口

### 快速移动（normal）

- `Ctrl-d / Ctrl-u`：下/上移动 9 行

### 退出/保存

- `W`：保存（`:w`）
- `q`：退出全部（`:qa`）
- `qq`：强制退出当前（`:q!`）
- `Q`：强制退出全部（`:qa!`）

### 命令行

- `;`：进入命令行（映射为 `:`）

### 终端

- `Space s`：水平打开终端（`:sp | terminal`）
- `Space vs`：垂直打开终端（`:vsp | terminal`）
- `Space x`：关闭当前窗口（normal/terminal 都支持）

---

## 键位冲突/覆盖（重要）

由于 `init.lua` 加载顺序是 `keymaps` 在前、`lsp` 在后：

- `Space q` / `Ctrl-h/j/k/l` 的冲突已修复：
  - 诊断列表改为 `Space dl`（不再覆盖 `Space q`）
  - `Ctrl-h/j/k/l` 保持窗口导航（移除了未安装的 BufferLine 映射）

建议的做法：
- 窗口导航用 `Ctrl-w h/j/k/l` 或本文档的 `Option-h/j/k/l`
- 如需 BufferLine，请显式安装插件后再增加对应 keymap（避免误触报 `E492`）

---

## 常见问题（Troubleshooting）

### LSP 没有补全

按顺序排查：
1. 确认语言服务器已安装（例如 `gopls` / `rust-analyzer` / `volar` 等）
2. 在 Neovim 执行 `:LspInfo` 看 server 是否 attached
3. 确认补全源启用：插入模式按 `Ctrl-Space` 看是否弹出菜单

### kubectl.nvim 打开报错

1. `:checkhealth kubectl`
2. 确认 `kubectl` 可执行：终端 `command -v kubectl`
3. 如果提示下载了 binary，按提示 **重启 Neovim** 让 `kubectl_client` 生效
