return {
    {
        'nvim-telescope/telescope.nvim',
        event = 'VimEnter',
        dependencies = {
            'nvim-lua/plenary.nvim',
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'make',
                cond = function()
                    return vim.fn.executable 'make' == 1
                end,
            },
            { 'nvim-telescope/telescope-ui-select.nvim' },
            { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
        },
        config = function()
            require('telescope').setup {
                defaults = require('telescope.themes').get_ivy(),
                extensions = {
                    ['ui-select'] = {
                        require('telescope.themes').get_dropdown(),
                    },
                    ['fzf'] = {}
                },
            }
            pcall(require('telescope').load_extension, 'fzf')
            pcall(require('telescope').load_extension, 'ui-select')

            local function is_git_repo()
                vim.fn.system('git rev-parse --is-inside-work-tree')
                return vim.v.shell_error == 0
            end

            -- See `:help telescope.builtin`
            local builtin = require 'telescope.builtin'

            -- File navigation 
            vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = 'Search [F]iles' })
            vim.keymap.set('n', '<leader><leader>', function() builtin.buffers { sort_lastused = true, ignore_current_buffer = true, } end, { desc = '[ ] Find existing buffers'})

            -- vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
            -- vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
            -- vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })

            -- Config
            vim.keymap.set('n', '<leader>sct', builtin.builtin, { desc = '[T]elescope' })
            vim.keymap.set('n', '<leader>scc', function() builtin.colorscheme { enable_preview = true } end, { desc = '[C]olorscheme' })

            -- Git
            if is_git_repo() then
                vim.keymap.set('n', '<leader>sgb', builtin.git_branches, { desc = '[B]ranches' })
                -- vim.keymap.set('n', '<leader>sga', builtin.git_commits
            end

            -- Misc
            vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[H]elp' })
        end,
    }
}
