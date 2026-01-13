return {
    { 'tpope/vim-fugitive' },
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            local gitsigns = require 'gitsigns'
            gitsigns.setup {}

            -- Configs
            vim.keymap.set('n', '<leader>gcb', gitsigns.toggle_current_line_blame, { desc = 'toggle [B]lame' })
            vim.keymap.set('n', '<leader>gd', '<cmd>Gvdiff<cr>', { desc = '[D]iff' })
            vim.keymap.set('n', '<leader>gp', function()
                local file = vim.fn.expand '%'
                local line = vim.fn.line '.'
                -- Get commit hash from git blame
                local blame = vim.fn.system(string.format('git blame -L %d,%d --porcelain %s', line, line, file))
                local commit = blame:match '^(%x+)'
                if commit and commit ~= '0000000000000000000000000000000000000000' then
                    -- Find and open PR using gh
                    vim.fn.system(string.format(
                    'gh pr view --web $(gh pr list --search "%s" --state merged --json number --jq ".[0].number")',
                        commit))
                else
                    print 'No commit found for this line'
                end
            end, { desc = 'open [P]R introducing line' })
            vim.keymap.set('n', '<leader>gy', function()
                local file = vim.fn.expand '%:~:.'
                local line = vim.fn.line '.'
                -- Get remote URL
                local remote_url = vim.fn.system('git config --get remote.origin.url'):gsub('%s+$', '')
                -- Convert SSH/HTTPS URL to web URL
                local web_url = remote_url:gsub('git@github%.com:', 'https://github.com/'):gsub('%.git$', '')
                -- Get current commit hash
                local commit = vim.fn.system('git rev-parse HEAD'):gsub('%s+$', '')
                -- Construct GitHub permalink
                local github_link = string.format('%s/blob/%s/%s#L%d', web_url, commit, file, line)
                -- Yank to system clipboard
                vim.fn.setreg('+', github_link)
                print('Yanked: ' .. github_link)
            end, { desc = '[Y]ank github link to line' })
        end,
    },
}
