return {
    { 'tpope/vim-fugitive' },
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            local gitsigns = require 'gitsigns'
            local repeatable_move = require 'nvim-treesitter-textobjects.repeatable_move'

            gitsigns.setup {
                on_attach = function(bufnr)
                    local function map(lhs, rhs, desc)
                        vim.keymap.set('n', lhs, rhs, { buffer = bufnr, desc = desc })
                    end

                    local repeatable_hunk_move = repeatable_move.make_repeatable_move(function(opts)
                        if vim.wo.diff then
                            vim.cmd.normal { opts.forward and ']c' or '[c', bang = true }
                        else
                            gitsigns.nav_hunk(opts.forward and 'next' or 'prev')
                        end
                    end)

                    map(']c', function()
                        repeatable_hunk_move { forward = true }
                    end, 'Next change')

                    map('[c', function()
                        repeatable_hunk_move { forward = false }
                    end, 'Previous change')
                end,
            }

            -- Configs
            vim.keymap.set('n', '<leader>gcb', gitsigns.toggle_current_line_blame, { desc = 'toggle [B]lame' })
            vim.keymap.set('n', '<leader>gB', function()
                local file = vim.fn.expand '%'
                local line = vim.fn.line '.'
                -- Get commit hash from git blame
                local blame = vim.fn.system(string.format('git blame -L %d,%d --porcelain %s', line, line, file))
                local commit = blame:match '^(%x+)'
                if commit and commit ~= '0000000000000000000000000000000000000000' then
                    -- Find and open PR using gh
                    vim.fn.system(string.format('gh pr view --web $(gh pr list --search "%s" --state merged --json number --jq ".[0].number")', commit))
                else
                    print 'No commit found for this line'
                end
            end, { desc = '[B]lame: open PR introducing line' })
            vim.keymap.set('n', '<leader>gd', gitsigns.diffthis, { desc = '[D]iff this file' })
        end,
    },
}
