-- Enable local nvim config
vim.o.exrc = true
vim.o.secure = true

-- Show relative numbers in buffer
vim.o.number = true
vim.o.relativenumber = true

-- Use space for tabs with set size
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

-- Ensure the cursor is not stuck on the edge of window
vim.o.scrolloff = 15
vim.o.sidescrolloff = 8

-- Sync vim clipboard with system's
vim.o.clipboard = 'unnamedplus'

-- Enable mouse
vim.o.mouse = 'a'

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.splitright = true
vim.o.signcolumn = 'yes'
