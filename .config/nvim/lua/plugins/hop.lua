return {
    'smoka7/hop.nvim',
    version = '*',
    config = function()
        -- place this in one of your configuration file(s)
        local hop = require 'hop'
        hop.setup {
            keys = 'sadfjklewcmpgh',
        }

        vim.keymap.set('', '<leader>h', function()
            hop.hint_words {}
        end, { remap = true })
    end,
}
