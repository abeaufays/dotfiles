return {
    {
        "neovim/nvim-lspconfig",
        config = function ()
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
                callback = function (event)
                    local telescope_builtins = require('telescope.builtin')
                    vim.keymap.set('n', 'grr', telescope_builtins.lsp_references, { buffer=event.buf, desc = '[G]oto [R]eference'})
                    vim.keymap.set('n', 'gri', telescope_builtins.lsp_implementations, { buffer=event.buf, desc = '[G]oto [I]mplementations'})
                end
            })
        end
    },
    {
        "mason-org/mason.nvim",
        opts = {},
    },
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = { "neovim/nvim-lspconfig", "saghen/blink.cmp" },
        opts = {
            ensure_installed = { "lua_ls" },
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
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
}
