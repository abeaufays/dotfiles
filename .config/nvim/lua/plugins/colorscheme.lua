return {
    { "EdenEast/nightfox.nvim", lazy = false, priority = 1000, },
    { "catppuccin/nvim", name = "catppuccin", lazy=false, priority = 1000 },
    { "rebelot/kanagawa.nvim", lazy = false, priority = 1000, },
    { "baliestri/aura-theme", lazy = false, priority = 1000, config = function(plugin) vim.opt.rtp:append(plugin.dir .. "/packages/neovim") end },
    { "Mofiqul/vscode.nvim", lazy = false, priority = 1000, },
    {
        "navarasu/onedark.nvim", lazy = false, priority = 1000,
        config = function()
            require('onedark').setup {
                style = 'darker'
            }
        end
    },
    {
        'projekt0n/github-nvim-theme', name = 'github-theme', lazy = false, priority = 1000,
    },
    {
        'folke/tokyonight.nvim', lazy = false, priority = 1000,
        config = function()
            vim.cmd([[colorscheme tokyonight-night]])
        end
    },
}
