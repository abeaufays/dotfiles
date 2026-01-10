return {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
    config = function()
        require('oil').setup {
            keymaps = {
                ['<C-p>'] = {
                    'actions.preview',
                    opts = {
                        split = 'belowright',
                    },
                },
            },
        }
        vim.keymap.set('n', '<leader>-', '<cmd>Oil<CR>', { desc = '[-] directory view' })
    end,
}
