-- 定义通用选项
local opts = { noremap = true, silent = true }
vim.g.mapleader = " " -- 设置 leader 键

-----------------
-- 普通模式 --
-----------------
-- 窗口导航
vim.keymap.set('n', '<C-h>', '<C-w>h', opts)
vim.keymap.set('n', '<C-j>', '<C-w>j', opts)
vim.keymap.set('n', '<C-k>', '<C-w>k', opts)
vim.keymap.set('n', '<C-l>', '<C-w>l', opts)

-- 窗口调整大小
vim.keymap.set('n', '<C-Up>', ':resize -2<CR>', opts)
vim.keymap.set('n', '<C-Down>', ':resize +2<CR>', opts)
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', opts)
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', opts)

-- 窗口分屏
vim.keymap.set('n', 'sv', ':vsp<CR>', opts) -- 垂直分屏
vim.keymap.set('n', 'sh', ':sp<CR>', opts) -- 水平分屏

-- Mac 下option + hjkl  窗口之间跳转
vim.keymap.set("n", "∑", "<C-w>w", opt)
vim.keymap.set("n", "˙", "<C-w>h", opt)
vim.keymap.set("n", "∆", "<C-w>j", opt)
vim.keymap.set("n", "˚", "<C-w>k", opt)
vim.keymap.set("n", "¬", "<C-w>l", opt)
-- Mac 下option + hjkl  左右移动
vim.keymap.set("i", "˙", "<Left>", opt)
vim.keymap.set("i", "∆", "<Down>", opt)
vim.keymap.set("i", "˚", "<Up>", opt)
vim.keymap.set("i", "¬", "<Right>", opt)

-- 关闭窗口
vim.keymap.set('n', 'sc', '<C-w>c', opts) -- 关闭当前窗口
vim.keymap.set('n', 'so', '<C-w>o', opts) -- 关闭其他窗口

-- 文件树
vim.keymap.set('n', '<leader>t', ':NvimTreeToggle<CR>', opts)
vim.keymap.set('n', '<F2>', ':NvimTreeToggle<CR>', opts)

-- 文件操作
vim.keymap.set("n", "<leader>q", ":wq<CR>", opts) -- 保存并退出
vim.keymap.set("n", "<leader>q!", ":q!<CR>", opts) -- 强制退出

-- 快速退出
vim.keymap.set('n', 'q', ':qa<CR>', opts)
vim.keymap.set('n', 'qq', ':q!<CR>', opts)
vim.keymap.set('n', 'ww', ':w<CR>', opts)
vim.keymap.set('n', 'Q', ':qa!<CR>', opts)

-- 上下滚动
vim.keymap.set('n', '<C-j>', '4j', opts)
vim.keymap.set('n', '<C-k>', '4k', opts)
vim.keymap.set('n', '<C-u>', '9k', opts)
vim.keymap.set('n', '<C-d>', '9j', opts)

-- 窗口比例调整
vim.keymap.set('n', 's,', ':vertical resize -20<CR>', opts)
vim.keymap.set('n', 's.', ':vertical resize +20<CR>', opts)
vim.keymap.set('n', 'sj', ':resize +10<CR>', opts)
vim.keymap.set('n', 'sk', ':resize -10<CR>', opts)
vim.keymap.set('n', 's=', '<C-w>=', opts) -- 等比例调整

-- Bufferline 操作
vim.keymap.set('n', '<C-h>', ':BufferLineCyclePrev<CR>', opts)
vim.keymap.set('n', '<C-l>', ':BufferLineCycleNext<CR>', opts)
vim.keymap.set('n', '<C-w>', ':Bdelete!<CR>', opts)
vim.keymap.set('n', '<leader>bl', ':BufferLineCloseRight<CR>', opts)
vim.keymap.set('n', '<leader>bh', ':BufferLineCloseLeft<CR>', opts)
vim.keymap.set('n', '<leader>bc', ':BufferLinePickClose<CR>', opts)

-- Telescope 快捷键
vim.keymap.set('n', '<C-p>', ':Telescope find_files<CR>', opts) -- 查找文件
vim.keymap.set('n', '<C-f>', ':Telescope live_grep<CR>', opts) -- 全局搜索

-- kubectl
vim.keymap.set("n", "<leader>k", '<cmd>lua require("kubectl").toggle()<cr>', { noremap = true, silent = true })

-----------------
-- 插入模式 --
-----------------
-- 快速回到普通模式
vim.keymap.set('i', 'jk', '<ESC>', opts)
vim.keymap.set('i', 'kj', '<ESC>', opts)

-- 插入模式下快速跳转
vim.keymap.set('i', '<C-b>', '<ESC>I', opts) -- 跳到行首
vim.keymap.set('i', '<C-e>', '<ESC>A', opts) -- 跳到行尾

-----------------
-- 可视模式 --
-----------------
-- 左右缩进并保持选中
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

-- 移动选中文本
vim.keymap.set('v', 'J', ":move '>+1<CR>gv-gv", opts)
vim.keymap.set('v', 'K', ":move '<-2<CR>gv-gv", opts)

-- 粘贴操作：覆盖时不复制
vim.keymap.set('v', 'p', '"_dP', opts)

-----------------
-- 终端模式 --
-----------------
-- 打开终端
vim.keymap.set('n', '<leader>s', ':sp | terminal<CR>', opts) -- 水平终端
vim.keymap.set('n', '<leader>vs', ':vsp | terminal<CR>', opts) -- 垂直终端


-- 关闭终端
vim.keymap.set('n', '<leader>x', '<C-w>c', opts) -- 普通模式关闭当前窗口
vim.keymap.set('t', '<leader>x', [[<C-\><C-n><C-w>c]], opts) -- 终端模式直接关闭

-- 调整窗口大小
vim.keymap.set('n', '<C-Up>', ':resize -2<CR>', opts)
vim.keymap.set('n', '<C-Down>', ':resize +2<CR>', opts)
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', opts)
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', opts)


-- 绑定快捷键 leader + i 执行 GoImplOpen
vim.api.nvim_set_keymap(
    "n", -- 普通模式
    "<leader>i", -- 快捷键
    ":GoImplOpen<CR>", -- 执行命令
    { noremap = true, silent = true } -- 选项
)