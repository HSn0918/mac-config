local function build_capabilities()
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if ok then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
    end

    return capabilities
end

local function apply_organize_imports_sync(bufnr, client_filter)
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { "source.organizeImports" }, diagnostics = {} }

    local results = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 1500)
    for client_id, res in pairs(results or {}) do
        local client = vim.lsp.get_client_by_id(client_id)
        if client and (not client_filter or client_filter(client)) then
            for _, action in ipairs(res.result or {}) do
                if action.edit then
                    vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
                end
                if action.command then
                    vim.lsp.buf.execute_command(action.command)
                end
            end
        end
    end
end

local function enable_if_executable(config_name, executable_name)
    if vim.fn.executable(executable_name) == 1 then
        vim.lsp.enable(config_name)
        return true
    end
    return false
end

vim.lsp.config("*", {
    capabilities = build_capabilities(),
    root_markers = { ".git" },
})

do
    local opts = { noremap = true, silent = true }
    vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, opts)
end

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local bufnr = args.buf
        vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
        vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
        vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
        vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
        vim.keymap.set("n", "<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, bufopts)
        vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
        vim.keymap.set("n", "<leader>f", function()
            vim.lsp.buf.format({ async = true })
        end, bufopts)

        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then
            return
        end

        if client.name == "gopls" then
            local group = vim.api.nvim_create_augroup("GoImportsAndFormat", { clear = false })
            vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })

            vim.api.nvim_create_autocmd("BufWritePre", {
                group = group,
                buffer = bufnr,
                callback = function()
                    apply_organize_imports_sync(bufnr, function(c)
                        return c.name == "gopls"
                    end)
                    vim.lsp.buf.format({
                        bufnr = bufnr,
                        async = false,
                        timeout_ms = 2000,
                        filter = function(c)
                            return c.name == "gopls"
                        end,
                    })
                end,
            })
        end
    end,
})

vim.lsp.config("gopls", {
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_markers = { "go.work", "go.mod", ".git" },
    settings = {
        gopls = {
            gofumpt = true,
            completeUnimported = true,
            usePlaceholders = true,
            staticcheck = true,
            analyses = {
                unusedparams = true,
                shadow = true,
                fieldalignment = true,
                nilness = true,
                unusedwrite = true,
                useany = true,
            },
            hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
            },
        },
    },
})

vim.lsp.config("rust_analyzer", {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_markers = { "Cargo.toml", "rust-project.json", ".git" },
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                runBuildScripts = true,
            },
            completion = {
                addCallParenthesis = true,
                addCallArgumentSnippets = true,
                postfix = { enable = true },
                autoimport = { enable = true },
                fullFunctionSignatures = { enable = true },
            },
            checkOnSave = {
                command = "clippy",
                extraArgs = { "--all-features" },
            },
            assist = {
                importGranularity = "module",
                importPrefix = "by_self",
            },
            diagnostics = {
                enable = true,
                experimental = { enable = true },
            },
            hover = {
                actions = {
                    enable = true,
                    debug = true,
                    gotoTypeDef = true,
                    implementations = true,
                    run = true,
                    references = true,
                },
            },
            inlayHints = {
                bindingModeHints = { enable = true },
                chainingHints = { enable = true },
                closingBraceHints = { enable = true, minLines = 1 },
                closureReturnTypeHints = { enable = "always" },
                lifetimeElisionHints = { enable = "always", useParameterNames = true },
                maxLength = 25,
                parameterHints = { enable = true },
                reborrowHints = { enable = "always" },
                typeHints = { enable = true },
            },
            lens = {
                enable = true,
                implementations = { enable = true },
                run = { enable = true },
                references = {
                    adt = { enable = true },
                    enumVariant = { enable = true },
                    method = { enable = true },
                    trait = { enable = true },
                },
            },
            procMacro = { enable = true },
        },
    },
})

vim.lsp.config("pylsp", {
    cmd = { "pylsp" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", ".git" },
    settings = {
        pylsp = {
            plugins = {
                pycodestyle = { enabled = true, maxLineLength = 100 },
                pylint = { enabled = true, executable = "pylint" },
                pyflakes = { enabled = true },
                autopep8 = { enabled = true },
                yapf = { enabled = true },
            },
        },
    },
})

vim.lsp.config("volar", {
    cmd = { "vue-language-server", "--stdio" },
    filetypes = { "vue" },
    root_markers = { "package.json", ".git" },
    init_options = {
        vue = { hybridMode = false },
        typescript = { tsdk = "" },
    },
})

vim.lsp.config("ts_ls", {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
    },
    root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
    init_options = { hostInfo = "neovim" },
})

vim.lsp.config("marksman", {
    cmd = { "marksman", "server" },
    filetypes = { "markdown", "markdown.mdx" },
    root_markers = { ".marksman.toml", ".git" },
})

vim.lsp.config("sqlls", {
    cmd = { "sql-language-server", "up", "--method", "stdio" },
    filetypes = { "sql", "mysql" },
    root_markers = { ".sqllsrc.json", ".git" },
})

vim.lsp.config("html", {
    cmd = { "vscode-html-language-server", "--stdio" },
    filetypes = { "html", "templ" },
    root_markers = { "package.json", ".git" },
    init_options = {
        provideFormatter = true,
        embeddedLanguages = { css = true, javascript = true },
        configurationSection = { "html", "css", "javascript" },
    },
})

vim.lsp.config("cssls", {
    cmd = { "vscode-css-language-server", "--stdio" },
    filetypes = { "css", "scss", "less" },
    root_markers = { "package.json", ".git" },
    init_options = { provideFormatter = true },
    settings = {
        css = { validate = true },
        scss = { validate = true },
        less = { validate = true },
    },
})

vim.lsp.config("jsonls", {
    cmd = { "vscode-json-language-server", "--stdio" },
    filetypes = { "json", "jsonc" },
    root_markers = { "package.json", ".git" },
    init_options = { provideFormatter = true },
    settings = {
        json = {
            schemas = require("schemastore").json.schemas(),
        },
    },
})

enable_if_executable("gopls", "gopls")
enable_if_executable("rust_analyzer", "rust-analyzer")
enable_if_executable("pylsp", "pylsp")
enable_if_executable("volar", "vue-language-server")
enable_if_executable("ts_ls", "typescript-language-server")
enable_if_executable("marksman", "marksman")
enable_if_executable("sqlls", "sql-language-server")
enable_if_executable("html", "vscode-html-language-server")
enable_if_executable("cssls", "vscode-css-language-server")
enable_if_executable("jsonls", "vscode-json-language-server")
