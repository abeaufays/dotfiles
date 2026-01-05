vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.number = true
vim.o.relativenumber = true

vim.o.mouse = 'a'

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

vim.o.scrolloff = 15

-- Sync clipboard between OS and neovim
-- Scheduled for performance
vim.schedule(function()
    vim.o.clipboard = 'unnamedplus'
end)

-- Yank current filename
vim.keymap.set('n', '<leader>yf', function()
    local filename = vim.fn.expand('%')
    vim.fn.setreg('+', filename)
    print('Yanked: ' .. filename)
end, { desc = '[y]ank [f]ilename' })

local cwd = vim.uv.cwd()
local config_dir = vim.fn.expand '~/.config'
if cwd and cwd:find(config_dir, 1, true) == 1 then
    vim.keymap.set('n', '<leader>X', '<cmd>source %<CR>', { desc = 'Source file' })
    vim.keymap.set('n', '<leader>x', ':.lua<CR>', { desc = 'Source line' })
    vim.keymap.set('v', '<leader>x', ':lua<CR>', { desc = 'Source selection' })
end

-- Show lines yanked
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Floating windows borders
vim.diagnostic.config { float = { border = 'rounded' } }

pcall(require, 'local.setup')
require 'config.lazy'
