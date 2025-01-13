-- 定义通用选项
local opts = {
    noremap = true,      -- 非递归映射
    silent = true,       -- 禁止显示多余的提示信息
}
vim.g.mapleader = " "
-----------------
-- 普通模式 --
-----------------

-- 窗口导航
vim.keymap.set('n', '<C-h>', '<C-w>h', opts)
vim.keymap.set('n', '<C-j>', '<C-w>j', opts)
vim.keymap.set('n', '<C-k>', '<C-w>k', opts)
vim.keymap.set('n', '<C-l>', '<C-w>l', opts)

-- 调整窗口大小
vim.keymap.set('n', '<C-Up>', ':resize -2<CR>', opts)
vim.keymap.set('n', '<C-Down>', ':resize +2<CR>', opts)
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', opts)
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', opts)

vim.keymap.set("n", "<leader>q", ":wq<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>q!", ":q!<CR>", { noremap = true, silent = true })

-----------------
-- 可视模式 --
-----------------

-- 左右缩进并保持选中
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

---------------------
-- 插入模式快捷键 --
---------------------

-- 使用 'jk' 或 'kj' 切换到普通模式
vim.keymap.set('i', 'jk', '<ESC>', opts)
vim.keymap.set('i', 'kj', '<ESC>', opts)


-- 文件树
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<F2>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })