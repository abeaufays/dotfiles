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
    },
    keys = function()
        local Snacks = require 'snacks'

        local function is_git_repo()
            vim.fn.system 'git rev-parse --is-inside-work-tree'
            return vim.v.shell_error == 0
        end

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
            -- Search directories and browse in Oil
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
        }

        -- Add Git keymaps if in a git repo
        if is_git_repo() then
            table.insert(keys, {
                '<leader>gb',
                function()
                    Snacks.picker.git_branches()
                end,
                desc = '[B]ranches',
            })
            table.insert(keys, {
                '<leader>gs',
                function()
                    Snacks.picker.git_status()
                end,
                desc = '[S]tatus',
            })
            table.insert(keys, {
                '<leader>gf',
                function()
                    Snacks.picker.git_log_file()
                end,
                desc = '[F]ile history',
            })
        end

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
