return {
    {
        "hrsh7th/nvim-cmp",
        lazy = false,
        priority = 100,
        dependencies = {
            "onsails/lspkind.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-buffer",
            { "L3MON4D3/LuaSnip", build = "make install_jsregexp" },
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require "cmp"

            cmp.setup {
                sources = {
                    { name = "nvim_lsp" },
                    { name = "cody" },
                    { name = "path" },
                    { name = "buffer" },
                },
                mapping = {
                    ["<down>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
                    ["<up>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
                    ["<cr>"] = cmp.mapping(
                        cmp.mapping.confirm {
                            behavior = cmp.ConfirmBehavior.Insert,
                            select = true,
                        },
                        { "i", "c" }
                    ),
                    ["<left>"] = cmp.mapping.abort()
                },

                -- Enable luasnip to handle snippet expansion for nvim-cmp
                snippet = {
                    expand = function(args)
                        vim.snippet.expand(args.body)
                    end,
                },
            }
        end,
    }
}
