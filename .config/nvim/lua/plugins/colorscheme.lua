return {
    { "EdenEast/nightfox.nvim" },
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    { "rebelot/kanagawa.nvim" },
    {
        "baliestri/aura-theme",
        config = function(plugin)
            vim.opt.rtp:append(plugin.dir .. "/packages/neovim")
        end
    },
    {
        "Mofiqul/vscode.nvim"
    },
    {
        'folke/tokyonight.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme tokyonight-night]])
        end
    },
}
