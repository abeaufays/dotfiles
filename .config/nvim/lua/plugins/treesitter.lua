return {
    {
        'nvim-treesitter/nvim-treesitter',
        branch = 'main',
        lazy = false,
        build = ':TSUpdate',
        dependencies = {
            'neovim-treesitter/treesitter-parser-registry',
            'nvim-treesitter/nvim-treesitter-context',
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        config = function()
            -- markdown_inline has no filetype of its own (it's injected inside markdown),
            -- so it would never be picked up by the FileType autocmd below.
            local filetypes = {
                'python',
                'htmldjango',
                'html',
                'css',
                'toml',
                'yaml',
                'json',
                'bash',
                'gitcommit',
                'diff',
                'markdown',
                'rust',
                'javascript',
                'lua',
                'vimdoc',
            }

            require('nvim-treesitter').install {
                'markdown_inline',
                unpack(filetypes),
            }

            vim.api.nvim_create_autocmd('FileType', {
                pattern = filetypes,
                callback = function(args)
                    vim.treesitter.start(args.buf)
                end,
            })

            -- Sticky scroll (treesitter-context)
            require('treesitter-context').setup {
                enable = true,
                max_lines = 3,
                multiline_threshold = 1,
            }

            -- Highlight stickyscroll differently from rest of code
            vim.api.nvim_set_hl(0, 'TreesitterContext', { link = 'StatusLine' })

            -- Text Objects config, see also mini config for mini.ai
            require('nvim-treesitter-textobjects').setup {
                move = {
                    set_jumps = true,
                },
            }

            -- functions
            vim.keymap.set({ 'n', 'x', 'o' }, '[f', function()
                require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects')
            end)
            vim.keymap.set({ 'n', 'x', 'o' }, ']f', function()
                require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects')
            end)

            -- arguments
            vim.keymap.set({ 'n', 'x', 'o' }, '[a', function()
                require('nvim-treesitter-textobjects.move').goto_previous_start('@parameter.inner', 'textobjects')
            end)
            vim.keymap.set({ 'n', 'x', 'o' }, ']a', function()
                require('nvim-treesitter-textobjects.move').goto_next_start('@parameter.inner', 'textobjects')
            end)

            -- From the README enable ; and , with those jumps:
            local ts_repeat_move = require 'nvim-treesitter-textobjects.repeatable_move'

            -- Repeat movement with ; and ,
            -- ensure ; goes forward and , goes backward regardless of the last direction
            -- vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move_next)
            -- vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_previous)

            -- vim way: ; goes to the direction you were moving.
            vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move)
            vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_opposite)

            -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
            vim.keymap.set({ 'n', 'x', 'o' }, 'f', ts_repeat_move.builtin_f_expr, { expr = true })
            vim.keymap.set({ 'n', 'x', 'o' }, 'F', ts_repeat_move.builtin_F_expr, { expr = true })
            vim.keymap.set({ 'n', 'x', 'o' }, 't', ts_repeat_move.builtin_t_expr, { expr = true })
            vim.keymap.set({ 'n', 'x', 'o' }, 'T', ts_repeat_move.builtin_T_expr, { expr = true })
        end,
    },
}
