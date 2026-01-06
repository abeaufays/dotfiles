return {
    {
        'nvim-mini/mini.nvim',
        version = false,
        config = function()
            local statusline = require 'mini.statusline'
            statusline.setup { use_icons = true }
            require('mini.move').setup {
                mappings = {
                    -- Remapping to arrow keys as my tiling window manager is already mapped to <M-hjkl>
                    left = '<M-Left>',
                    right = '<M-Right>',
                    down = '<M-Down>',
                    up = '<M-Up>',

                    line_left = '<M-Left>',
                    line_right = '<M-Right>',
                    line_down = '<M-Down>',
                    line_up = '<M-Up>',
                },
            }
        end,
    },
}
