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
                enabled = function()
                    return vim.bo.filetype ~= "oil"
                end,
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
                    ["<left>"] = cmp.mapping.abort(),
                    ["<C-Space>"] = cmp.mapping.complete { behavior = cmp.SelectBehavior.Insert }
                },

                -- Enable luasnip to handle snippet expansion for nvim-cmp
                snippet = {
                    expand = function(args)
                        vim.snippet.expand(args.body)
                    end,
                },
            }

            cmp.event:on("confirm_done", function(evt)
                local item = evt.entry:get_completion_item()
                -- only react to python auto-imports
                if vim.bo.filetype ~= "python" then return end

                -- heuristic: completion inserted a class
                if item.kind == cmp.lsp.CompletionItemKind.Class or item.kind == cmp.lsp.CompletionItemKind.Function then
                    -- defer so LSP edits are applied first
                    vim.defer_fn(function()
                        require("customs.python_imports").transform_python_class_import_to_module()
                    end, 50)
                end
            end)
        end,
    }
}
