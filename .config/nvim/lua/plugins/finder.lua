return {
    -- FZF-LUA CONFIG
    {
        'ibhagwan/fzf-lua',
        event = 'VimEnter',
        dependencies = {
            { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
        },
        config = function()
            local fzf = require 'fzf-lua'

            -- Setup with ivy-like theme (bottom position)
            fzf.setup {
                winopts = {
                    height = 0.40,
                    width = 1.0,
                    row = 1.0,
                    preview = {
                        layout = 'horizontal',
                        horizontal = 'right:50%',
                    },
                },
                fzf_opts = {
                    ['--layout'] = 'reverse',
                },
            }

            local function is_git_repo()
                vim.fn.system 'git rev-parse --is-inside-work-tree'
                return vim.v.shell_error == 0
            end

            -- File navigation (scoped to Oil directory when browsing)
            vim.keymap.set('n', '<leader>f', function()
                fzf.files { cwd = require('oil').get_current_dir() }
            end, { desc = 'Search [F]iles' })

            vim.keymap.set('n', '<leader><leader>', function()
                fzf.buffers()
            end, { desc = '[ ] Find existing buffers' })

            vim.keymap.set('n', '<leader>sg', fzf.live_grep, { desc = '[G]rep' })
            vim.keymap.set('n', '<leader>ss', fzf.resume, { desc = 'Re[S]ume' })

            -- Search directories and browse in Oil
            -- NOTE: Custom Oil integration with directory filtering is non-trivial in fzf-lua
            -- This provides a basic implementation - may need refinement for exact parity
            vim.keymap.set('n', '<leader>sd', function()
                fzf.files {
                    cwd = require('oil').get_current_dir(),
                    cmd = 'fd -t d --hidden --exclude .git',
                    actions = {
                        ['default'] = function(selected)
                            if selected and selected[1] then
                                -- Strip emoji and formatting, extract just the path
                                local path = selected[1]:gsub('^[^%w/%.]+%s*', '')
                                vim.cmd('Oil ' .. vim.fn.fnameescape(path))
                            end
                        end,
                    },
                }
            end, { desc = 'Search [D]irectories' })

            -- Config
            vim.keymap.set('n', '<leader>scb', fzf.builtin, { desc = '[B]uiltin' })
            vim.keymap.set('n', '<leader>scc', fzf.colorschemes, { desc = '[C]olorscheme' })

            -- Git
            if is_git_repo() then
                vim.keymap.set('n', '<leader>gb', fzf.git_branches, { desc = '[B]ranches' })
                vim.keymap.set('n', '<leader>gs', fzf.git_status, { desc = '[S]tatus' })
                vim.keymap.set('n', '<leader>gf', fzf.git_bcommits, { desc = '[F]ile history' })
            end

            -- Misc
            vim.keymap.set('n', '<leader>sh', fzf.help_tags, { desc = '[H]elp' })
        end,
    },
}
