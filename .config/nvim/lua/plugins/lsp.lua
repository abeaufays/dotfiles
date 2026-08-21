return {
    {
        'neovim/nvim-lspconfig',
        config = function()
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
                callback = function(event)
                    -- LSP keymaps
                    local Snacks = require 'snacks'
                    vim.keymap.set('n', 'gd', function()
                        Snacks.picker.lsp_definitions()
                    end, { buffer = event.buf, desc = 'Goto [D]efinition' })
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration,
                        { buffer = event.buf, desc = 'Goto [D]eclaration' })
                    vim.keymap.set('n', 'grr', function()
                        Snacks.picker.lsp_references()
                    end, { buffer = event.buf, desc = '[R]eference' })
                    vim.keymap.set('n', 'gri', function()
                        Snacks.picker.lsp_implementations()
                    end, { buffer = event.buf, desc = '[I]mplementations' })

                    vim.keymap.set('n', 'gO', function()
                        Snacks.picker.lsp_symbols()
                    end, { buffer = event.buf, desc = '[O] Navigate symbols' })
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
        dependencies = { 'neovim/nvim-lspconfig', 'hrsh7th/cmp-nvim-lsp', 'b0o/schemastore.nvim' },
        opts = {
            ensure_installed = { 'lua_ls', 'jsonls' },
        },
        config = function(_, opts)
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            vim.lsp.config('*', { capabilities = capabilities })

            vim.lsp.config('ty', {
                settings = {
                    ty = {
                        completions = {
                            autoImport = false,
                        },
                    },
                },
            })

            vim.lsp.config('jsonls', {
                filetypes = { 'json', 'jsonc' },
                settings = {
                    json = {
                        schemas = require('schemastore').json.schemas(),
                        validate = { enable = true },
                        -- Allow comments in JSON files
                        allowComments = true,
                        -- Allow trailing commas
                        allowTrailingCommas = true,
                    },
                },
                init_options = {
                    provideFormatter = true,
                },
            })

            require('mason-lspconfig').setup(opts)
        end,
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
