-- Yank current filename
vim.keymap.set('n', '<leader>yp', ":let @+=expand('%:.')<CR>", { desc = 'Relative [p]ath' })
vim.keymap.set('n', '<leader>yP', ":let @+=expand('%:p')<CR>", { desc = 'Absolute [P]ath' })
vim.keymap.set('n', '<leader>yn', ":let @+=expand('%:t')<CR>", { desc = 'File [n]ame' })
vim.keymap.set('n', '<leader>yN', ":let @+=expand('%:t:r')<CR>", { desc = 'File base[N]ame' })

local function get_dotted_path()
    local item = { file = vim.fn.expand '%:p' }
    local rel_path = vim.fn.fnamemodify(item.file, ':.')
    if not rel_path:match '%.py$' then
        return ''
    end

    -- Strip leading "src/" if present
    rel_path = rel_path:gsub('^src[\\/]', '')

    local without_ext = rel_path:gsub('%.py$', '')
    return without_ext:gsub('/', '.'):gsub('\\', '.')
end

vim.keymap.set('n', '<leader>yI',
    function()
        local module_path = get_dotted_path()
        local last_dot = module_path:match '.*()%.'
        local import
        if not last_dot then
            import = 'import ' .. module_path
        else
            local base = module_path:sub(1, last_dot - 1)
            local mod = module_path:sub(last_dot + 1)
            import = ('from %s import %s'):format(base, mod)
        end
        vim.fn.setreg('"', import)

        -- Yank to system clipboard
        vim.fn.setreg('+', import)

        vim.notify('Copy-yanked ' .. import, vim.log.levels.INFO)
    end, { desc = 'python [I]mport' })

vim.keymap.set('n', '<leader>yi',
    function()
        local module_path = get_dotted_path()
        vim.fn.setreg('"', module_path)

        -- Yank to system clipboard
        vim.fn.setreg('+', module_path)

        vim.notify('Copy-yanked ' .. module_path, vim.log.levels.INFO)
    end, { desc = 'python [I]mport' })
