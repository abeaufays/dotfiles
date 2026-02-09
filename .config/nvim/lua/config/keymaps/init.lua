require 'config.keymaps.yank_filename'
local python_imports = require 'customs.python_imports'

vim.keymap.set('n', '<leader>n', function()
    vim.fn.setreg('/', '[A-Z_\\-]')
    vim.cmd('normal n')
end, { desc = '[N]ext partial word' })
vim.keymap.set('n', 'grp', python_imports.transform_python_class_import_to_module,
    { desc = 'Python [I]mports: class to modules' })

vim.keymap.set('n', '<leader>w', '<cmd>update<cr>', { desc = 'Save' })
vim.keymap.set('n', '<leader>q', '<cmd>q<cr>', { desc = 'Quit' })
vim.keymap.set('n', '<leader><Tab>', '<cmd>wq<cr>', { desc = 'Save & Quit' })

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
