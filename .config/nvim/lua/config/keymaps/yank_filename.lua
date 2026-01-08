-- Yank current filename
vim.keymap.set('n', '<leader>yp', ":let @+=expand('%:.')<CR>", { desc = 'Relative [p]ath' })
vim.keymap.set('n', '<leader>yP', ":let @+=expand('%:p')<CR>", { desc = 'Absolute [P]ath' })
vim.keymap.set('n', '<leader>yn', ":let @+=expand('%:t')<CR>", { desc = 'File [n]ame' })
vim.keymap.set('n', '<leader>yN', ":let @+=expand('%:t:r')<CR>", { desc = 'File base[N]ame' })

vim.keymap.set({ 'n', 'v' }, '<Leader>yi', function()
    local item = { file = vim.fn.expand '%:p' } -- or however you get the file path

    if not item or not item.file then
        return
    end

    local vals = {
        ['BASENAME'] = vim.fn.fnamemodify(item.file, ':t:r'),
        ['FILENAME'] = vim.fn.fnamemodify(item.file, ':t'),
        ['PATH (REL)'] = vim.fn.fnamemodify(item.file, ':.'),
        ['PATH (HOME)'] = vim.fn.fnamemodify(item.file, ':~'),
        ['PYTHON IMPORT'] = (function()
            local rel_path = vim.fn.fnamemodify(item.file, ':.')
            if not rel_path:match '%.py$' then
                return ''
            end

            -- Strip leading "src/" if present
            rel_path = rel_path:gsub('^src[\\/]', '')

            local without_ext = rel_path:gsub('%.py$', '')
            local module_path = without_ext:gsub('/', '.'):gsub('\\', '.')

            local last_dot = module_path:match '.*()%.'
            if not last_dot then
                return 'import ' .. module_path
            else
                local base = module_path:sub(1, last_dot - 1)
                local mod = module_path:sub(last_dot + 1)
                return ('from %s import %s'):format(base, mod)
            end
        end)(),
    }

    -- Define keys in desired order
    local ordered_keys = {
        'PATH (REL)',
        'PYTHON IMPORT',
        'PATH (HOME)',
        'FILENAME',
        'BASENAME',
    }

    -- Filter while preserving order
    local options = {}
    for _, key in ipairs(ordered_keys) do
        if vals[key] and vals[key] ~= '' then
            table.insert(options, key)
        end
    end

    if vim.tbl_isempty(options) then
        vim.notify('No values to copy', vim.log.levels.WARN)
        return
    end

    vim.ui.select(options, {
        prompt = 'Choose to copy to clipboard:',
        format_item = function(list_item)
            return ('%s: %s'):format(list_item, vals[list_item])
        end,
    }, function(choice)
        local result = vals[choice]
        if result then
            -- Yank to unnamed register (for use with `p`/`P`)
            vim.fn.setreg('"', result)

            -- Yank to system clipboard
            vim.fn.setreg('+', result)

            vim.notify('Copy-yanked ' .. result, vim.log.levels.INFO)
        end
    end)
end, { noremap = true, silent = true, desc = '[I]nteractive' })
