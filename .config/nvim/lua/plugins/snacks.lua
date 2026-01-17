return {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
        bigfile = { enabled = true },
        notifier = { enabled = true },
        quickfile = { enabled = true },
        statuscolumn = { enabled = true },
        words = { enabled = true },
        picker = { enabled = true },
        gh = { enabled = true },
        gitbrowse = { enabled = true },
    },
    keys = function()
        local Snacks = require 'snacks'

        local keys = {
            -- File navigation (scoped to Oil directory when browsing)
            {
                '<leader>f',
                function()
                    Snacks.picker.files { cwd = require('oil').get_current_dir() }
                end,
                desc = 'Search [F]iles',
            },
            -- Buffers
            {
                '<leader><leader>',
                function()
                    Snacks.picker.buffers { current = false }
                end,
                desc = '[ ] Find existing buffers',
            },
            -- Grep
            {
                '<leader>sg',
                function()
                    Snacks.picker.grep { cwd = require('oil').get_current_dir() }
                end,
                desc = '[G]rep',
            },
            -- Resume
            {
                '<leader>ss',
                function()
                    Snacks.picker.resume()
                end,
                desc = 'Re[S]ume',
            },
            -- Search directories and browse in Oil / To improve
            {
                '<leader>sd',
                function()
                    local cwd = require('oil').get_current_dir() or vim.loop.cwd()
                    Snacks.picker.pick {
                        cwd = cwd,
                        format = 'file',
                        finder = function(opts, ctx)
                            return require('snacks.picker.source.proc').proc(
                                ctx:opts {
                                    cmd = 'fd',
                                    args = { '--type', 'd', '--hidden', '--exclude', '.git' },
                                    transform = function(item)
                                        item.file = item.text
                                        item.dir = true
                                    end,
                                },
                                ctx
                            )
                        end,
                        confirm = function(picker, item)
                            if item and item.file then
                                vim.cmd('Oil ' .. vim.fn.fnameescape(item.file))
                            end
                        end,
                    }
                end,
                desc = 'Search [D]irectories',
            },
            -- Config
            {
                '<leader>scb',
                function()
                    Snacks.picker.pickers()
                end,
                desc = '[B]uiltin',
            },
            {
                '<leader>scc',
                function()
                    Snacks.picker.colorschemes()
                end,
                desc = '[C]olorscheme',
            },
            -- Help
            {
                '<leader>sh',
                function()
                    Snacks.picker.help()
                end,
                desc = '[H]elp',
            },
            -- Git
            -- Branches
            {
                '<leader>gb',
                function()
                    Snacks.picker.git_branches()
                end,
                desc = '[B]ranches',
            },
            -- Diff
            {
                '<leader>gd',
                function()
                    Snacks.picker.git_diff()
                end,
                desc = '[S]tatus',
            },
            -- File history
            {
                '<leader>gf',
                function()
                    Snacks.picker.git_log_file()
                end,
                desc = '[F]ile history',
            },
            {
                '<leader>gp',
                function()
                    Snacks.picker.gh_pr({ author = "@me" })
                end,
                desc = 'Browse my PRs'
            },
            {
                '<leader>gy',
                function()
                    -- Check if current branch has been pushed to remote
                    local branch = vim.fn.system('git rev-parse --abbrev-ref HEAD'):gsub('\n', '')
                    local remote_check = vim.fn.system(
                        'git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null')

                    if vim.v.shell_error ~= 0 or remote_check == '' then
                        branch = vim.fn.system('git get-main-branch')
                    end

                    Snacks.gitbrowse {
                        what = 'file',
                        line_start = vim.fn.line('.'),
                        line_end = vim.fn.line('.'),
                        branch = branch,
                        open = function(url) vim.fn.setreg("+", url) end,
                        notify = false
                    }
                end,
                desc = '[Y]ank github link to line'
            }
        }

        return keys
    end,
    init = function()
        vim.api.nvim_create_autocmd('User', {
            pattern = 'VeryLazy',
            callback = function()
                -- Setup other snacks features here if needed
                _G.dd = function(...)
                    Snacks.debug.inspect(...)
                end
                _G.bt = function()
                    Snacks.debug.backtrace()
                end
                vim.print = _G.dd
            end,
        })
    end,
}
