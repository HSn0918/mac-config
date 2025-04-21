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
    -- Python 配置优化
    pylsp = {
        settings = {
            pylsp = {
                plugins = {
                    pycodestyle = {
                        enabled = true,
                        maxLineLength = 100
                    },
                    pylint = {
                        enabled = true,
                        executable = "pylint"
                    },
                    pyflakes = { enabled = true },
                    autopep8 = { enabled = true },
                    yapf = { enabled = true }
                }
            }
        }
    },

    -- Lua 语言服务器
    lua_ls = {
        settings = {
            Lua = {
                runtime = {
                    version = 'LuaJIT',
                },
                diagnostics = {
                    globals = {'vim'},
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false,
                },
                telemetry = {
                    enable = false,
                },
            },
        },
    },

    -- TypeScript/JavaScript 配置优化
    ts_ls = {
        settings = {
            typescript = {
                inlayHints = {
                    includeInlayParameterNameHints = 'all',
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                },
            },
            javascript = {
                inlayHints = {
                    includeInlayParameterNameHints = 'all',
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                },
            },
        },
    },

    -- Vue 语言服务器
    volar = {
        filetypes = {'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json'},
    },

    -- Markdown 语言服务器
    marksman = {},

    -- SQL 语言服务器
    sqlls = {},

    -- 保留原有配置
    rust_analyzer = {
        settings = {
            ["rust-analyzer"] = {
                cargo = {
                    allFeatures = true,
                    loadOutDirsFromCheck = true,
                    runBuildScripts = true,
                },
                -- 详细的代码补全设置
                completion = {
                    addCallParenthesis = true,
                    addCallArgumentSnippets = true,
                    postfix = {
                        enable = true,
                    },
                    autoimport = {
                        enable = true,
                    },
                    fullFunctionSignatures = {
                        enable = true,
                    },
                },
                checkOnSave = {
                    command = "clippy",
                    extraArgs = {"--all-features"},
                },
                -- 增强的代码提示
                assist = {
                    importGranularity = "module",
                    importPrefix = "by_self",
                },
                -- 诊断设置
                diagnostics = {
                    enable = true,
                    experimental = {
                        enable = true,
                    },
                },
                -- 悬停提示设置
                hover = {
                    actions = {
                        enable = true,
                        debug = true,
                        gotoTypeDef = true,
                        implementations = true,
                        run = true,
                    },
                    documentation = {
                        enable = true,
                        keywords = true,
                    },
                },
                -- 内联提示设置
                inlayHints = {
                    enable = true,
                    bindingModeHints = {
                        enable = true,
                    },
                    chainingHints = {
                        enable = true,
                    },
                    closingBraceHints = {
                        enable = true,
                        minLines = 1,
                    },
                    closureReturnTypeHints = {
                        enable = "always",
                    },
                    lifetimeElisionHints = {
                        enable = "always",
                        useParameterNames = true,
                    },
                    maxLength = 25,
                    parameterHints = {
                        enable = true,
                    },
                    reborrowHints = {
                        enable = "always",
                    },
                    typeHints = {
                        enable = true,
                        hideClosureInitialization = false,
                        hideNamedConstructor = false,
                    },
                },
                -- 代码镜头设置
                lens = {
                    enable = true,
                    debug = {
                        enable = true,
                    },
                    implementations = {
                        enable = true,
                    },
                    run = {
                        enable = true,
                    },
                    references = {
                        adt = {
                            enable = true,
                        },
                        enumVariant = {
                            enable = true,
                        },
                        method = {
                            enable = true,
                        },
                        trait = {
                            enable = true,
                        },
                    },
                },
                -- 过程宏支持
                procMacro = {
                    enable = true,
                    ignored = {},
                },
            },
        },
    },
    gopls = {
        settings = {
            gopls = {
                -- 基础设置
                usePlaceholders = true,
                completeUnimported = true,
                directoryFilters = {"-node_modules"},

                -- 代码分析设置
                analyses = {
                    unusedparams = true,
                    shadow = true,
                    fieldalignment = true,
                    nilness = true,
                    unusedwrite = true,
                    useany = true,
                },

                -- 代码建议设置
                hints = {
                    assignVariableTypes = true,
                    compositeLiteralFields = true,
                    compositeLiteralTypes = true,
                    constantValues = true,
                    functionTypeParameters = true,
                    parameterNames = true,
                    rangeVariableTypes = true,
                },

                -- 诊断设置
                diagnosticsDelay = "500ms",
                semanticTokens = true,

                -- 代码补全设置
                matcher = "Fuzzy",
                experimentalPostfixCompletions = true,

                -- 格式化设置
                gofumpt = true,

                -- 导入设置
                importShortcut = "Both",

                -- 代码链接设置
                linkTarget = "pkg.go.dev",

                -- 代码模板设置
                templateExtensions = {"tmpl", "gotmpl"},

                -- 符号设置
                symbolMatcher = "fuzzy",
                symbolStyle = "Dynamic",

                -- 代码导航设置
                codelenses = {
                    gc_details = true,
                    generate = true,
                    regenerate_cgo = true,
                    run_govulncheck = true,
                    test = true,
                    tidy = true,
                    upgrade_dependency = true,
                    vendor = true,
                },

                -- 静态检查设置
                staticcheck = true,

                -- 工作区设置
                expandWorkspaceToModule = true,
                experimentalWorkspaceModule = true,

                -- 模块设置
                allowModfileModifications = true,
                allowImplicitNetworkAccess = true,
            },
        },
        -- 确保某些命令在保存时运行
        on_attach = function(client, bufnr)
            -- 调用原有的 on_attach
            on_attach(client, bufnr)

            -- 自动导入
            local function organize_imports()
                vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
            end

            -- 为当前缓冲区创建自动命令
            vim.api.nvim_create_autocmd("BufWritePre", {
                callback = organize_imports,
                buffer = bufnr,
            })
        end,
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