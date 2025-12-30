-- 检查光标前是否有单词
local has_words_before = function()
    unpack = unpack or table.unpack                          -- 兼容不同 Lua 版本的 `unpack`
    local line, col = unpack(vim.api.nvim_win_get_cursor(0)) -- 获取光标的行和列
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    -- 检查光标前一个字符是否不是空白字符
end

-- 引入插件
local luasnip = require("luasnip") -- LuaSnip 插件，用于代码片段补全
local cmp = require("cmp")         -- nvim-cmp 插件，用于智能补全

-- 配置 nvim-cmp
cmp.setup({
    snippet = {
        -- 必须指定代码片段引擎
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- 使用 LuaSnip 处理代码片段展开
        end,
    },

    -- 快捷键映射
    mapping = cmp.mapping.preset.insert({
        -- 滚动补全文档
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),            -- 向上滚动 4 行
        ['<C-f>'] = cmp.mapping.scroll_docs(4),             -- 向下滚动 4 行
        -- 切换补全项
        ['<C-k>'] = cmp.mapping.select_prev_item(),         -- 选择上一个补全项
        ['<C-j>'] = cmp.mapping.select_next_item(),         -- 选择下一个补全项
        -- 确认补全项
        ['<CR>'] = cmp.mapping.confirm({ select = true }),  -- 确认选中的补全项
        ['<C-Space>'] = cmp.mapping.complete(),             -- Manually trigger completion

        -- Tab 键补全
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()  -- 如果补全菜单可见，选择下一个补全项
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()  -- 如果光标前有单词，打开补全
            else
                fallback()      -- 否则执行默认操作
            end
        end, { "i", "s" }),     -- 适用于插入模式（i）和选择模式（s）

        -- Shift+Tab 键跳转到上一个补全项
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item() -- 如果补全菜单可见，选择上一个补全项
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)       -- 如果 LuaSnip 可以跳转，向后跳转
            else
                fallback()             -- 否则执行默认操作
            end
        end, { "i", "s" }),
    }),

    -- 配置补全菜单的显示样式
    formatting = {
        -- 补全菜单的显示字段顺序
        fields = { 'abbr', 'menu' },

        -- 自定义补全菜单的外观
        format = function(entry, vim_item)
            -- 根据补全来源显示菜单内容
            vim_item.menu = ({
                nvim_lsp = '[Lsp]',    -- 来自 LSP
                luasnip = '[Luasnip]', -- 来自 LuaSnip
                buffer = '[File]',     -- 来自当前文件
                path = '[Path]',       -- 来自路径
            })[entry.source.name]
            return vim_item
        end,
    },

    -- 设置补全来源的优先级
    sources = cmp.config.sources({
        { name = 'nvim_lsp' }, -- 优先使用 LSP 提供的补全
        { name = 'luasnip' },  -- 使用 LuaSnip 提供的代码片段补全
        { name = 'buffer' },   -- 使用当前文件内容的补全
        { name = 'path' },     -- 使用路径补全
    })
})
