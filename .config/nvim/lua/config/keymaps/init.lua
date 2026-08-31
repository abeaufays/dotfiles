require 'config.keymaps.yank_filename'
local python_imports = require 'customs.python_imports'

vim.keymap.set('n', 'grp', python_imports.transform_python_class_import_to_module,
    { desc = 'Python [I]mports: class to modules' })

vim.keymap.set('n', '<leader>w', '<cmd>update<cr>', { desc = 'Save' })
vim.keymap.set('n', '<leader>q', function()
    if vim.bo.modified then
        vim.ui.select(
            { 'Save & quit', 'Quit without saving', 'Cancel' },
            { prompt = 'Unsaved changes' },
            function(choice)
                if choice == 'Save & quit' then vim.cmd('wq')
                elseif choice == 'Quit without saving' then vim.cmd('q!')
                end
            end
        )
    else
        vim.cmd('q')
    end
end, { desc = 'Quit' })
vim.keymap.set('n', '<leader><Tab>', '<cmd>wq<cr>', { desc = 'Save & Quit' })

-- Make it easy to exit terminal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Make identing in visual mode stay in visual mode
vim.keymap.set('v', '<', '<gv', { desc = 'Indent left and reselect' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent right and reselect' })

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
