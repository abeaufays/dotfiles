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
            local jump2d = require 'mini.jump2d'
            jump2d.setup {
                spotter = jump2d.builtin_opts.word_start.spotter,
                view = { n_steps_ahead = 2 },
                mappings = {
                    start_jumping = '<leader>j',
                },
            }
            require('mini.surround').setup()
            local gen_ai_spec = require('mini.extra').gen_ai_spec
            local gen_spec = require('mini.ai').gen_spec

            -- This is needed so the dah bind to delete a hunk doesn't leave an empty line
            local hunk_spec = gen_spec.treesitter {
                a = '@hunk.outer',
                i = '@hunk.inner',
            }
            local function linewise_hunk_spec(ai_type, ...)
                local regions = hunk_spec(ai_type, ...)
                for _, region in ipairs(regions) do
                    region.vis_mode = 'V'
                end
                return regions
            end

            -- Make a version of assignement linewise
            local assignment_spec = gen_spec.treesitter {
                a = '@assignment.outer',
                i = '@assignment.inner',
            }
            local function assignment_textobject(ai_type, ...)
                local regions = assignment_spec(ai_type, ...)
                if ai_type == 'a' then
                    for _, region in ipairs(regions) do
                        region.vis_mode = 'V'
                    end
                end
                return regions
            end

            require('mini.ai').setup {
                mappings = {
                    around_next = 'aN',
                    inside_next = 'iN',
                    around_last = 'aL',
                    inside_last = 'iL',
                },
                custom_textobjects = {
                    B = gen_ai_spec.buffer(),
                    D = gen_ai_spec.diagnostic(),
                    I = gen_ai_spec.indent(),
                    l = gen_ai_spec.line(),
                    a = gen_spec.argument(),
                    f = gen_spec.treesitter {
                        a = '@function.outer',
                        i = '@function.inner',
                    },
                    k = gen_spec.function_call(),
                    c = gen_spec.treesitter {
                        a = '@class.outer',
                        i = '@class.inner',
                    },
                    h = linewise_hunk_spec,
                    o = gen_spec.treesitter {
                        a = { '@loop.outer', '@conditional.outer' },
                        i = { '@loop.inner', '@conditional.inner' },
                    },
                    s = assignment_textobject,
                },

                n_lines = 500, -- How far to look for the object
                search_method = 'cover_or_next', -- Jumps to next if not inside one
            }
        end,
    },
}
