return {
    {
        'neovim/nvim-lspconfig',
        config = function()
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
                callback = function(event)
                    -- LSP keymaps
                    local fzf = require 'fzf-lua'
                    vim.keymap.set('n', 'gd', fzf.lsp_definitions, { buffer = event.buf, desc = 'Goto [D]efinition' })
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration,
                        { buffer = event.buf, desc = 'Goto [D]eclaration' })
                    vim.keymap.set('n', 'grr', fzf.lsp_references, { buffer = event.buf, desc = '[R]eference' })
                    vim.keymap.set('n', 'gri', fzf.lsp_implementations,
                        { buffer = event.buf, desc = '[I]mplementations' })

                    vim.keymap.set('n', 'gO', fzf.lsp_document_symbols,
                        { buffer = event.buf, desc = '[O] Navigate symbols' })

                    -- Formatting
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client then
                        if client.supports_method 'textDocument/formatting' then
                            vim.keymap.set('n', '<leader>=', function()
                                vim.lsp.buf.format { bufnr = event.buf, id = client.id }
                            end, { desc = '[=] Format buffer' })

                            vim.api.nvim_create_autocmd('BufWritePre', {
                                buffer = event.buf,
                                callback = function()
                                    vim.lsp.buf.format { bufnr = event.buf, id = client.id }
                                    vim.lsp.buf.code_action {
                                        context = { only = { 'source.organizeImports' } },
                                        apply = true,
                                    }
                                end,
                            })
                        end
                    end
                end,
            })
        end,
    },
    {
        'mason-org/mason.nvim',
        opts = {},
    },
    {
        'mason-org/mason-lspconfig.nvim',
        dependencies = { 'neovim/nvim-lspconfig', 'saghen/blink.cmp' },
        opts = {
            ensure_installed = { 'lua_ls' },
            handlers = {
                function(server_name)
                    local capabilities = require('blink.cmp').get_lsp_capabilities()
                    vim.lsp.enable(server_name, { capabilities = capabilities })
                end,
            },
        },
    },
    {
        -- for nvim configs
        'folke/lazydev.nvim',
        ft = 'lua', -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
            },
        },
    },
}
