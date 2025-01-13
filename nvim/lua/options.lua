-- 提示：使用 `:h <选项>` 来查看每个选项的详细含义

-- 使用系统剪贴板
vim.opt.clipboard = 'unnamedplus'

-- 自动补全设置
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

-- 启用鼠标支持
vim.opt.mouse = 'a'

-- Tab 配置
vim.opt.tabstop = 4 -- 设置 Tab 键为 4 个空格宽度
vim.opt.softtabstop = 4 -- 编辑时 Tab 表现为 4 个空格
vim.opt.shiftwidth = 4 -- 自动缩进时使用 4 个空格
vim.opt.expandtab = true -- 将 Tab 替换为空格（特别适合 Python）

-- 界面配置
vim.opt.number = true -- 显示绝对行号
vim.opt.relativenumber = true -- 显示相对行号
vim.opt.cursorline = true -- 高亮当前光标所在行
vim.opt.splitbelow = true -- 新的水平分屏会在下方打开
vim.opt.splitright = true -- 新的垂直分屏会在右侧打开
-- vim.opt.termguicolors = true -- 启用终端中 24 位 RGB 颜色支持
vim.opt.showmode = false -- 隐藏模式提示，比如 "-- INSERT --"（适合熟练用户）

-- 搜索配置
vim.opt.incsearch = true -- 输入搜索时实时显示匹配结果
vim.opt.hlsearch = false -- 搜索后不高亮匹配项
vim.opt.ignorecase = true -- 搜索时默认忽略大小写
vim.opt.smartcase = true -- 如果搜索包含大写字母，则区分大小写