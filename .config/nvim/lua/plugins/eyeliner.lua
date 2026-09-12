return {
    'jinh0/eyeliner.nvim',
    config = function()
        require('eyeliner').setup {
            highlight_on_key = true,
            -- f/F/t/T are provided by nvim-treesitter-textobjects so they
            -- can participate in repeatable motions.
            default_keymaps = false,
        }
        vim.api.nvim_set_hl(0, 'EyelinerPrimary', { bold = true, underline = true })
        vim.api.nvim_set_hl(0, 'EyelinerSecondary', { underline = true })
    end,
}
