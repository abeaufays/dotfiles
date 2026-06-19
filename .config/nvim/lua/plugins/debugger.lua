return {
    {
        'mfussenegger/nvim-dap',
        dependencies = {
            'mason-org/mason.nvim',
            'jay-babu/mason-nvim-dap.nvim',
            'igorlfs/nvim-dap-view',
            'theHamsta/nvim-dap-virtual-text',
            'mfussenegger/nvim-dap-python',
        },
        keys = function(_, keys)
            local dap = require 'dap'
            local dapview = require 'dap-view'
            return {
                {
                    '<F5>',
                    dap.continue,
                    desc = 'Debug: Start/Continue',
                },
                {
                    '<F10>',
                    dap.step_into,
                    desc = 'Debug: Step Into',
                },
                {
                    '<F11>',
                    dap.step_over,
                    desc = 'Debug: Step Over',
                },
                {
                    '<F12>',
                    dap.step_out,
                    desc = 'Debug: Step Out',
                },
                {
                    '<leader>b',
                    dap.toggle_breakpoint,
                    desc = 'Debug: Toggle Breakpoint',
                },
                {
                    '<leader>B',
                    function()
                        dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
                    end,
                    desc = 'Debug: Set Breakpoint',
                },
                {
                    '<F7>',
                    dapview.toggle,
                    desc = 'Debug: Toggle debug view',
                },
                unpack(keys),
            }
        end,
        config = function()
            local dap = require 'dap'

            require('mason-nvim-dap').setup {
                -- Makes a best effort to setup the various debuggers with
                -- reasonable debug configurations
                automatic_installation = true,

                -- You can provide additional configuration to the handlers,
                -- see mason-nvim-dap README for more information
                handlers = {},

                -- You'll need to check that you have the required things installed
                -- online, please don't ask me how to install them :)
                ensure_installed = {
                    'debugpy',
                },
            }
            require('dap-view').setup {
                auto_toggle = true,
            }

            require('nvim-dap-virtual-text').setup()
            vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
            vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })

            -- Re-apply highlight groups after colorscheme changes
            vim.api.nvim_create_autocmd('ColorScheme', {
                pattern = '*',
                callback = function()
                    vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
                    vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
                end,
            })

            local breakpoint_icons = vim.g.have_nerd_font
                and {
                    Breakpoint = '',
                    BreakpointCondition = '',
                    BreakpointRejected = '',
                    LogPoint = '',
                    Stopped =
                    ''
                }
                or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
            for type, icon in pairs(breakpoint_icons) do
                local tp = 'Dap' .. type
                local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
                vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
            end

            -- This is useful to make sure I can step over while in the bottom right pane
            dap.listeners.before.event_stopped['fix_winfixbuf'] = function()
                for _, win in ipairs(vim.api.nvim_list_wins()) do
                    if not vim.wo[win].winfixbuf then
                        vim.api.nvim_set_current_win(win)
                        return
                    end
                end
            end

            require('dap-python').setup 'uv'
        end,
    },
}
