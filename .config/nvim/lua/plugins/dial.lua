return {
    'monaqa/dial.nvim',
    keys = {
        {
            '<C-a>',
            function()
                return require('dial.map').inc_normal()
            end,
            expr = true,
            desc = 'Dial increment',
        },
        {
            '<C-x>',
            function()
                return require('dial.map').dec_normal()
            end,
            expr = true,
            desc = 'Dial decrement',
        },
    },
    config = function()
        local augend = require 'dial.augend'
        require('dial.config').augends:register_group {
            default = {
                augend.integer.alias.decimal,
                augend.integer.alias.hex,
                augend.date.alias['%Y/%m/%d'],
                augend.date.alias['%Y-%m-%d'],
                augend.date.alias['%m/%d'],
                augend.date.alias['%H:%M'],
                augend.constant.alias.bool,
                augend.constant.alias.Bool,
                augend.constant.alias.ja_weekday_full,
            },
        }
    end,
}
