-- 加载 lspconfig 插件
local lspconfig = require('lspconfig')

-- 自定义 on_attach 函数
local on_attach = function(client, bufnr)
    -- 设置补全触发键
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- 键位映射设置
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<space>f', function()
        vim.lsp.buf.format({ async = true })
    end, bufopts)
end

-- 全局诊断快捷键
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- 配置语言服务器
local servers = {
    pylsp = {},               -- Python
    lua_ls = {
        settings = {
            Lua = {
                diagnostics = {
                    globals = { "vim" }, -- 识别全局变量 vim
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                },
            },
        },
    },
    rust_analyzer = {},       -- Rust
    gopls = {
        settings = {
            gopls = {
                gofumpt = true, -- 启用更严格的格式化规则
            },
        },
    },
    jdtls = {},               -- Java
    bashls = {},              -- Shell
    clangd = {},              -- C/C++
    dockerls = {},            -- Dockerfile
    yamlls = {                -- YAML (Kubernetes 配置文件)
        settings = {
            yaml = {
                schemas = {
                    kubernetes = "*.yaml", -- 匹配所有 YAML 文件
                },
                validate = true, -- 启用验证
            },
        },
    },
    ts_ls = {},            -- TypeScript/JavaScript
    html = {},                -- HTML
    cssls = {},               -- CSS
    jsonls = {                -- JSON
        settings = {
            json = {
                schemas = require('schemastore').json.schemas(),
            },
        },
    },
}

-- 遍历配置所有服务器
for lsp, config in pairs(servers) do
    lspconfig[lsp].setup(vim.tbl_extend("force", {
        on_attach = on_attach,
        capabilities = require('cmp_nvim_lsp').default_capabilities(), -- 补全能力
    }, config))
end

-- 保存时自动格式化
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.go", "*.py", "*.lua", "*.js", "*.ts", "*.json", "*.yaml", "*.html", "*.css" },
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})