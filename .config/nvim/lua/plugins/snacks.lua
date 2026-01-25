return {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
        bigfile = { enabled = true },
        gh = { enabled = true },
        gitbrowse = { enabled = true },
        input = { enabled = true },
        notifier = { enabled = true },
        picker = { enabled = true },
        quickfile = { enabled = true },
        statuscolumn = { enabled = true },
        terminal = { enabled = true },
        words = { enabled = true },
    },
    keys = function()
        local Snacks = require 'snacks'

        local keys = {
            -- File navigation (scoped to Oil directory when browsing)
            {
                '<leader>ff',
                function()
                    Snacks.picker.files { cwd = require('oil').get_current_dir() }
                end,
                desc = '[F]iles',
            },
            -- Buffers
            {
                '<leader><leader>',
                function()
                    Snacks.picker.buffers { current = false }
                end,
                desc = '[ ] Find opened buffer',
            },
            -- Grep
            {
                '<leader>fg',
                function()
                    Snacks.picker.grep { cwd = require('oil').get_current_dir() }
                end,
                desc = '[G]rep',
            },
            -- Resume
            {
                '<leader>fr',
                function()
                    Snacks.picker.resume()
                end,
                desc = '[R]esume',
            },
            -- Search directories and browse in Oil / To improve
            {
                '<leader>fd',
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
                desc = '[D]irectories',
            },
            -- Config
            {
                '<leader>fcb',
                function()
                    Snacks.picker.pickers()
                end,
                desc = '[B]uiltin',
            },
            {
                '<leader>fcc',
                function()
                    Snacks.picker.colorschemes()
                end,
                desc = '[C]olorscheme',
            },
            -- Help
            {
                '<leader>fh',
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
                desc = '[D]iff',
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

                    -- Get line range (handles both normal and visual mode)
                    local line_start = vim.fn.line('.')
                    local line_end = vim.fn.line('.')

                    -- Check if we're coming from visual mode
                    local mode = vim.fn.mode()
                    if mode == 'v' or mode == 'V' or mode == '\22' then
                        line_start = vim.fn.line('v')
                        line_end = vim.fn.line('.')
                        -- Ensure start is before end
                        if line_start > line_end then
                            line_start, line_end = line_end, line_start
                        end
                    end

                    Snacks.gitbrowse {
                        what = 'file',
                        line_start = line_start,
                        line_end = line_end,
                        branch = branch,
                        open = function(url) vim.fn.setreg("+", url) end,
                        notify = false
                    }
                end,
                mode = { 'n', 'v' },
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
