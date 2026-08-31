local function mark_global(operator)
    local char = vim.fn.getcharstr()
    -- If it's a letter, force it to uppercase for a global mark
    if char:match '%a' then
        char = char:upper()
    end
    vim.cmd('normal! ' .. operator .. char)
end

vim.keymap.set('n', 'm', function()
    mark_global 'm'
end, { desc = 'Set global mark' })
vim.keymap.set('n', '`', function()
    mark_global '`'
end, { desc = 'Jump to global mark' })
vim.keymap.set('n', "'", function()
    local char = vim.fn.getcharstr()
    if char:match '%a' then
        char = char:upper()
    end

    local mark = "'" .. char
    local current_file = vim.api.nvim_buf_get_name(0)
    for _, item in ipairs(vim.fn.getmarklist()) do
        if item.mark == mark then
            if item.file == current_file then
                vim.notify('Already in file marked ' .. char, vim.log.levels.INFO)
            else
                vim.cmd.edit(vim.fn.fnameescape(item.file))
            end
            return
        end
    end

    vim.notify('Mark ' .. char .. ' is not set', vim.log.levels.WARN)
end, { desc = 'Edit file marked globally' })

-- Save marks and history in a local .nvim.shada file per project
vim.opt.shadafile = '.nvim.shada'
