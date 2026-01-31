return {
    {
        'nvim-mini/mini.nvim',
        version = false,
        config = function()
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
            require('mini.surround').setup()
            local gen_ai_spec = require('mini.extra').gen_ai_spec
            local gen_spec = require('mini.ai').gen_spec
            require('mini.ai').setup({
                custom_textobjects = {

                    B = gen_ai_spec.buffer(),
                    D = gen_ai_spec.diagnostic(),
                    I = gen_ai_spec.indent(),
                    L = gen_ai_spec.line(),
                    N = gen_ai_spec.number(),
                    a = gen_spec.argument(),
                    f = gen_spec.treesitter({
                        a = '@function.outer',
                        i = '@function.inner',
                    }),
                    k = gen_spec.function_call(),
                    c = gen_spec.treesitter({
                        a = '@class.outer',
                        i = '@class.inner',
                    }),
                    o = gen_spec.treesitter({
                        a = { '@loop.outer', '@conditional.outer' },
                        i = { '@loop.inner', '@conditional.inner' },
                    }),
                },

                -- Module options
                n_lines = 500,                   -- How far to look for the object
                search_method = 'cover_or_next', -- Jumps to next if not inside one
            })
        end,
    },
}
