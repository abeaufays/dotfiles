return {
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            local config = require 'lualine.config'
            local sections = vim.deepcopy(config.get_config().sections)
            sections.lualine_c = {
                function()
                    local ok, oil = pcall(require, 'oil')
                    if ok then
                        return vim.fn.fnamemodify(oil.get_current_dir(), ':~')
                    else
                        return ''
                    end
                end,
            }

            local oil_extension = { sections = sections, filetypes = { 'oil' } }
            require('lualine').setup {
                extensions = { oil_extension },
            }
        end,
    },
}
