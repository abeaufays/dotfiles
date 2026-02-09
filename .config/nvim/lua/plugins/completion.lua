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
            local types = require "cmp.types"
            cmp.setup {
                enabled = function()
                    return vim.bo.filetype ~= "oil"
                end,
                sources = {
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "cody" },
                    { name = "path" },
                    { name = "buffer" },
                },
                sorting = {
                    priority_weight = 2,
                    comparators = {
                        -- Snippets first
                        function(entry1, entry2)
                            local kind1 = entry1:get_kind()
                            local kind2 = entry2:get_kind()

                            if kind1 == types.lsp.CompletionItemKind.Snippet
                                and kind2 ~= types.lsp.CompletionItemKind.Snippet then
                                return true
                            end

                            if kind2 == types.lsp.CompletionItemKind.Snippet
                                and kind1 ~= types.lsp.CompletionItemKind.Snippet then
                                return false
                            end

                            return nil
                        end,

                        -- then fall back to the defaults
                        cmp.config.compare.offset,
                        cmp.config.compare.exact,
                        cmp.config.compare.score,
                        cmp.config.compare.recently_used,
                        cmp.config.compare.kind,
                        cmp.config.compare.sort_text,
                        cmp.config.compare.length,
                        cmp.config.compare.order,
                    },
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
                        require("luasnip").lsp_expand(args.body)
                    end,
                }
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
