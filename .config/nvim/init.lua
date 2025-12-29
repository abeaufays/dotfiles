vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.number = true
vim.o.relativenumber = true

vim.o.mouse = 'a'

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

-- Sync clipboard between OS and neovim
-- Scheduled for performance
vim.schedule(function()
    vim.o.clipboard = 'unnamedplus'
end)


vim.keymap.set("n", "<leader>p", vim.cmd.Ex, {desc = "[p]roject view"})

-- Show lines yanked
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})

pcall(require, "local.setup")
require("config.lazy")

