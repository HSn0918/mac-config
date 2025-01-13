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
    rust_analyzer = {
        settings = {
            ["rust-analyzer"] = {
                cargo = {
                    allFeatures = true, -- 启用所有 Cargo 功能
                },
                checkOnSave = {
                    command = "clippy", -- 使用 Clippy 进行代码检查
                },
                assist = {
                    importGranularity = "module", -- 控制导入粒度
                    importPrefix = "by_self", -- 使用 `self` 作为模块导入前缀
                },
                diagnostics = {
                    enable = true, -- 启用诊断信息
                },
                inlayHints = {
                    enable = true, -- 启用内联提示
                    typeHints = true,
                    chainingHints = true,
                    parameterHints = true,
                },
                lens = {
                    enable = true, -- 启用代码镜头（如测试运行按钮）
                },
            },
        },
    },
    gopls = {
        settings = {
            gopls = {
                usePlaceholders = true,  -- 在补全中插入占位符
                completeUnimported = true, -- 自动补全未导入的包并添加 import
                staticcheck = true,       -- 启用静态分析
                analyses = {
                    unusedparams = true,  -- 检查未使用的参数
                    shadow = true,        -- 检查变量遮蔽问题
                },
                hints = {
                    assignVariableTypes = true, -- 提示变量赋值类型
                    compositeLiteralFields = true, -- 提示复合文字中的字段
                    compositeLiteralTypes = true,  -- 提示复合文字的类型
                    constantValues = true,         -- 提示常量值
                    functionTypeParameters = true, -- 提示函数类型参数
                    parameterNames = true,         -- 提示参数名
                    rangeVariableTypes = true,     -- 提示范围变量的类型
                },
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