return {
    { 'tpope/vim-fugitive' },
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            local gitsigns = require 'gitsigns'
            gitsigns.setup {}

            -- Configs
            vim.keymap.set('n', '<leader>gcb', gitsigns.toggle_current_line_blame, { desc = 'toggle [B]lame' })
        end,
    },
}
