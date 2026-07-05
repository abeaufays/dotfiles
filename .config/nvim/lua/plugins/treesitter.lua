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
            require('nvim-treesitter').install { 'python', 'htmldjango', 'html', 'css', 'toml', 'yaml', 'json', 'bash', 'gitcommit', 'diff', 'markdown_inline', 'markdown', 'rust', 'javascript', 'lua', 'vimdoc' }

            -- Sticky scroll (treesitter-context)
            require('treesitter-context').setup {
                enable = true,
                max_lines = 3,
                multiline_threshold = 1,
            }

            -- Highlight stickyscroll differently from rest of code
            vim.api.nvim_set_hl(0, 'TreesitterContext', { link = 'StatusLine' })

            -- Custom Remap
            vim.api.nvim_set_hl(0, '@lsp.type.namespace.python', { link = '@namespace' })
        end,
    },
}
