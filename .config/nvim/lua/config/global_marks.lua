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
    mark_global "'"
end, { desc = 'Jump to global mark line' })

-- Save marks and history in a local .nvim.shada file per project
vim.opt.shadafile = '.nvim.shada'
