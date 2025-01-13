-- 定义 Lazy.nvim 的安装路径
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- 检查 Lazy.nvim 是否已经安装，如果没有则自动安装
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

-- 将 Lazy.nvim 添加到运行时路径中
vim.opt.rtp:prepend(lazypath)

-- 加载 Lazy.nvim 插件管理器
require("lazy").setup({
    -- Vscode 风格的图标
    {
        "onsails/lspkind.nvim",
        event = { "VimEnter" },
    },
    -- 自动补全引擎
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "lspkind.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
        },
        config = function()
            require("config.nvim-cmp")
        end,
    },
    -- 代码片段引擎
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
    },
    -- Theme
    "tanvirtin/monokai.nvim",
    "nvim-lualine/lualine.nvim",
    "nvim-tree/nvim-web-devicons",
    "nvim-tree/nvim-tree.lua",
    "nvim-treesitter/nvim-treesitter",
    "nvim-treesitter/nvim-treesitter-textobjects",
    "nvim-treesitter/nvim-treesitter-context",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    "b0o/schemastore.nvim",
    "windwp/nvim-autopairs",
})

-- 配置主题
vim.cmd([[colorscheme monokai_pro]])

-- 加载 nvim-autopairs
require("nvim-autopairs").setup({
    check_ts = true,
    disable_filetype = { "TelescopePrompt" },
})

-- 与 nvim-cmp 集成
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp = require("cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

-- 文件树配置
require("nvim-tree").setup({
    view = {
        width = 30,
        side = "left",
    },
    renderer = {
        highlight_git = true,
        icons = {
            show = {
                file = true,
                folder = true,
                folder_arrow = true,
                git = true,
            },
        },
    },
    actions = {
        open_file = {
            quit_on_open = true,
        },
    },
    git = {
        enable = true,
        ignore = false,
    },
})

-- Treesitter 配置
require("nvim-treesitter.configs").setup({
    ensure_installed = {
        -- 编程语言
        "lua", "python", "go", "javascript", "typescript", "json", "html", "css",
        "bash", "c", "cpp", "java", "rust",

        -- 标记语言
        "yaml", "toml", "markdown", "markdown_inline", "xml",

        -- 脚本语言
        "perl", "ruby", "php",

        -- Web 开发
        "vue", "svelte", "scss",

        -- 配置文件
        "dockerfile", "make", "gitignore",

        -- 其他
        "regex", "query", "vim",
    },
    highlight = {
        enable = true, -- 启用语法高亮
    },
    indent = {
        enable = true, -- 启用智能缩进
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true, -- 光标自动跳转到下一个匹配项
            keymaps = {
                ["af"] = "@function.outer", -- 选择整个函数
                ["if"] = "@function.inner", -- 选择函数内部
                ["ac"] = "@class.outer",    -- 选择整个类
                ["ic"] = "@class.inner",    -- 选择类内部
            },
        },
    },
})
-- 保存时自动格式化
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
        vim.lsp.buf.format({ async = true })
    end,
})