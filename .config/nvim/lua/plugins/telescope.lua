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
            vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[F]ind [F]iles' })
            vim.keymap.set('n', '<leader><leader>', function() builtin.buffers { sort_lastused = true, ignore_current_buffer = true, } end, { desc = '[ ] Find existing buffers'})

            -- vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
            -- vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
            -- vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })

            -- Config
            vim.keymap.set('n', '<leader>fct', builtin.builtin, { desc = '[F]ind [C]onfig [T]elescope' })
            vim.keymap.set('n', '<leader>fcc', function() builtin.colorscheme { enable_preview = true } end, { desc = '[F]ind [C]onfig [C]olorscheme' })

            -- Git
            if is_git_repo() then
                vim.keymap.set('n', '<leader>fgb', builtin.git_branches, { desc = '[F]ind [G]it [B]ranch' })
                -- vim.keymap.set('n', '<leader>fga', builtin.git_commits
            end

            -- Misc
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[F]ind [H]elp' })
        end,
    }
}
