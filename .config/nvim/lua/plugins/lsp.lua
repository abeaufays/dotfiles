return {
    {
        "neovim/nvim-lspconfig",
    },
    {
        "mason-org/mason.nvim",
        opts = {},
    },
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = { "neovim/nvim-lspconfig" },
        opts = {
            ensure_installed = { "lua_ls" },
            handlers = {
                function(server_name)
                    -- Instead of the old .setup{}, we use the new enable()
                    vim.lsp.enable(server_name)
                end,
                lua_ls = function()
                    vim.lsp.config('lua_ls', {
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { 'vim' }
                                },
                            },
                        },
                    })
                    vim.lsp.enable('lua_ls')
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
