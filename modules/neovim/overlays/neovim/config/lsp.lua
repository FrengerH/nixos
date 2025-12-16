local augroup_format = vim.api.nvim_create_augroup("Format", { clear = true })
local enable_format_on_save = function(_, bufnr)
    vim.api.nvim_clear_autocmds({ group = augroup_format, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup_format,
        buffer = bufnr,
        callback = function()
            vim.lsp.buf.format({ bufnr = bufnr })
        end,
    })
end

local on_attach = function(_, bufnr)
    local opts = { buffer = bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-i>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wl', function()
        vim.inspect(vim.lsp.buf.list_workspace_folders())
    end, opts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set(
        'n', '<leader>so', require('telescope.builtin').lsp_document_symbols, opts
    )
    vim.api.nvim_create_user_command("Format", function() vim.lsp.buf.format() end, {})
end

-- Set up completion using nvim_cmp with LSP source
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Configure LSP servers using new vim.lsp.config API
vim.lsp.config.intelephense = {
    cmd = { 'intelephense', '--stdio' },
    filetypes = { 'php' },
    root_markers = { 'composer.json', '.git' },
    capabilities = capabilities,
}

vim.lsp.config.pylsp = {
    cmd = { 'pylsp' },
    filetypes = { 'python' },
    root_markers = { 'pyproject.toml', 'setup.py', '.git' },
    capabilities = capabilities,
    settings = {
        pylsp = {
            plugins = {
                pylsp_mypy = {
                    enabled = true,
                    live_mode = true,
                    strict = true
                }
            }
        }
    }
}

vim.lsp.config.rnix = {
    cmd = { 'rnix-lsp' },
    filetypes = { 'nix' },
    root_markers = { 'flake.nix', 'default.nix', '.git' },
    capabilities = capabilities
}

vim.lsp.config.nixd = {
    cmd = { 'nixd' },
    filetypes = { 'nix' },
    root_markers = { 'flake.nix', 'default.nix', '.git' },
    capabilities = capabilities
}

vim.lsp.config.rust_analyzer = {
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' },
    root_markers = { 'Cargo.toml', '.git' },
    capabilities = capabilities
}

vim.lsp.config.clangd = {
    cmd = { 'clangd' },
    filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
    root_markers = { 'compile_commands.json', '.git' },
    capabilities = capabilities
}

vim.lsp.config.lua_ls = {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = { '.luarc.json', '.git' },
    capabilities = capabilities,
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' },
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false
            },
        },
    },
}

vim.lsp.config.arduino_language_server = {
    cmd = { 'arduino-language-server' },
    filetypes = { 'arduino' },
    root_markers = { '*.ino', '.git' },
    capabilities = capabilities
}

-- Enable LSP servers automatically on file open
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'php', 'python', 'nix', 'rust', 'c', 'cpp', 'lua', 'arduino' },
    callback = function(args)
        local clients = {
            php = 'intelephense',
            python = 'pylsp',
            nix = 'nixd',
            rust = 'rust_analyzer',
            c = 'clangd',
            cpp = 'clangd',
            lua = 'lua_ls',
            arduino = 'arduino_language_server'
        }

        local server = clients[args.match]
        if server then
            vim.lsp.enable(server)
            on_attach(nil, args.buf)

            -- Enable format on save for lua_ls
            if server == 'lua_ls' then
                enable_format_on_save(nil, args.buf)
            end
        end
    end
})

-- lsp_installer.on_server_ready(function(server)
--     local opts = {
--         on_attach = on_attach
--     }
--     if server.name == "sumneko_lua" then
--         opts = {
--             on_attach = on_attach,
--             settings = {
--                 Lua = {
--                     diagnostics = {
--                         globals = { "vim", "use" }
--                     }
--                 }
--             }
--         }
--     end
--     server:setup(opts)
-- end)
