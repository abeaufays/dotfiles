return {
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            local sections = {
                lualine_a = { 'mode' },
                lualine_b = { 'diagnostics' },
                lualine_c = {
                    { 'filename', path = 1, file_status = true, newfile_status = true },
                },
                lualine_x = {},
                lualine_y = { 'diff', 'branch' },
                lualine_z = { 'location' },
            }

            local oil_sections = vim.deepcopy(sections)
            oil_sections.lualine_c = {
                function()
                    local ok, oil = pcall(require, 'oil')
                    if ok then
                        return vim.fn.fnamemodify(oil.get_current_dir(), ':~')
                    else
                        return ''
                    end
                end,
            }

            local oil_extension = { sections = oil_sections, filetypes = { 'oil' } }
            require('lualine').setup {
                extensions = { oil_extension },
                sections = sections,
            }
        end,
    },
}
