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
                select = {
                    -- Hunks are line-oriented, which makes deleting a selected
                    -- hunk from `git add -e` behave as expected.
                    selection_modes = {
                        ['@hunk.outer'] = 'V',
                        ['@hunk.inner'] = 'V',
                    },
                },
                move = {
                    set_jumps = true,
                },
            }

            -- Select a complete diff hunk (including its @@ header), or the
            -- hunk body without the header with `ih`.
            vim.keymap.set({ 'x', 'o' }, 'ah', function()
                require('nvim-treesitter-textobjects.select').select_textobject('@hunk.outer', 'textobjects')
            end)
            vim.keymap.set({ 'x', 'o' }, 'ih', function()
                require('nvim-treesitter-textobjects.select').select_textobject('@hunk.inner', 'textobjects')
            end)

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
        end,
    },
}
