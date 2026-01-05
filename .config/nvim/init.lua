vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require 'config.options'

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
