local status, nvim_lsp = pcall(require, "lspconfig")
if (not status) then return end

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
    vim.api.nvim_create_user_command("Format", vim.lsp.buf.formatting, {})
end

-- Set up completion using nvim_cmp with LSP source
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- nvim_lsp['psalm'].setup {
--     -- cmd = { 'psalm --language-server' },
--     on_attach = on_attach,
--     capabilities = capabilities,
-- }

nvim_lsp['intelephense'].setup {
    on_attach = on_attach,
    capabilities = capabilities,
}

nvim_lsp['pylsp'].setup {
    on_attach = on_attach,
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

-- nvim_lsp['pylyzer'].setup {
--     on_attach = on_attach,
--     capabilities = capabilities,
--     settings = {
--         python = {
--             checkOnType = false,
--             diagnostics = true,
--             inlayHints = true,
--             smartCompletion = true
--         }
--     }
-- }

nvim_lsp['rnix'].setup {
    on_attach = on_attach,
    filetypes = { "nix" },
    cmd = { "rnix-lsp" },
    capabilities = capabilities
}

nvim_lsp['nixd'].setup {
    on_attach = on_attach,
    filetypes = { "nix" },
    cmd = { "nixd" },
    capabilities = capabilities
}

nvim_lsp['rust_analyzer'].setup {
    on_attach = on_attach,
    capabilities = capabilities
}

nvim_lsp['clangd'].setup {
    on_attach = on_attach,
    capabilities = capabilities
}

nvim_lsp['lua_ls'].setup {
    capabilities = capabilities,
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        enable_format_on_save(client, bufnr)
    end,
    settings = {
        Lua = {
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
            },

            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false
            },
        },
    },
}

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
