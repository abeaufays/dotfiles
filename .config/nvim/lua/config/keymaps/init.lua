require 'config.keymaps.yank_filename'

-- Make it easy to exit terminal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Make identing in visual mode stay in visual mode
vim.keymap.set('v', '<', '<gv', { desc = 'Indent left and reselect' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent right and reselect' })

-- Source keymaps (only in config directory)
local cwd = vim.uv.cwd()
local config_dir = vim.fn.expand '~/.config'
if cwd and cwd:find(config_dir, 1, true) == 1 then
    vim.keymap.set('n', '<leader>X', '<cmd>source %<CR>', { desc = 'Source file' })
    vim.keymap.set('n', '<leader>x', ':.lua<CR>', { desc = 'Source line' })
    vim.keymap.set('v', '<leader>x', ':lua<CR>', { desc = 'Source selection' })
end

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
