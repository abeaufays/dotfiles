return {
    {
        'milanglacier/minuet-ai.nvim',
        dependencies = {
            { 'nvim-lua/plenary.nvim' },
            -- -- optional, if you are using virtual-text frontend, blink is not required.
            -- { 'Saghen/blink.cmp' },
        },
        config = function()
            require('minuet').setup {
                -- Your configuration options here
                virtualtext = {
                    auto_trigger_ft = {},
                    keymap = {
                        -- accept whole completion
                        accept = '<A-A>',
                        -- accept one line
                        accept_line = '<A-a>',
                        -- accept n lines (prompts for number)
                        -- e.g. "A-z 2 CR" will accept 2 lines
                        accept_n_lines = '<A-z>',
                        -- Cycle to prev completion item, or manually invoke completion
                        prev = '<A-[>',
                        -- Cycle to next completion item, or manually invoke completion
                        next = '<A-]>',
                        dismiss = '<A-e>',
                    },
                }
            }
        end,
    },
    {
        "NickvanDyke/opencode.nvim",
        dependencies = {
            -- Recommended for `ask()` and `select()`.
            -- Required for `snacks` provider.
            ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
            { "folke/snacks.nvim", opts = { input = {}, picker = {} } },
        },
        config = function()
            vim.g.opencode_opts = {
                provider = {
                    enabled = "tmux",
                    tmux = {
                        -- ...
                    }
                }
            }
            -- Required for `opts.events.reload`
            vim.o.autoread = true
            vim.keymap.set({ "n", "x" }, "<leader>ca", function() return require("opencode").operator("@this ") end,
                { desc = "Add range to opencode", expr = true })
            vim.keymap.set({ "n", "x" }, "<leader>cb", function() return require("opencode").operator("@buffer ") end,
                { desc = "Add range to opencode", expr = true })
        end,
    }
}
