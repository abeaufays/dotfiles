return {
    { 'EdenEast/nightfox.nvim', lazy = false,        priority = 1000 },
    { 'catppuccin/nvim',        name = 'catppuccin', lazy = false,   priority = 1000 },
    { 'rebelot/kanagawa.nvim',  lazy = false,        priority = 1000 },
    {
        'baliestri/aura-theme',
        lazy = false,
        priority = 1000,
        config = function(plugin)
            vim.opt.rtp:append(plugin.dir .. '/packages/neovim')
        end,
    },
    {
        'Mofiqul/vscode.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            require('vscode').setup {
                group_overrides = {
                    ['@property'] = { fg = '#7bc6ed' }, -- slightly darker than classic one
                },
            }
        end,
    },
    {
        'navarasu/onedark.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            require('onedark').setup {
                style = 'darker',
            }
        end,
    },
    {
        'projekt0n/github-nvim-theme',
        name = 'github-theme',
        lazy = false,
        priority = 1000,
    },
    {
        'folke/tokyonight.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            require('tokyonight').setup {
                on_highlights = function(hl, _)
                    -- Between function blue (#82aaff) and type teal (#4fd6be)
                    hl['@lsp.type.namespace.python'] = { fg = '#7dcfe8' }
                    hl['pythonInclude'] = { fg = '#c099ff' } -- keyword purple, same as import keywords
                end,
            }
        end,
    },
}
