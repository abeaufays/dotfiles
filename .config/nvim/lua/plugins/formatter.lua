return {
    {
        'stevearc/conform.nvim',
        config = function()
            require('conform').setup({
                format_on_save = {
                    lsp_format = "fallback"
                },
                formatters_by_ft = {
                    lua = { 'stylua' },
                    python = {
                        "ruff_fix",
                        "ruff_format",
                        "ruff_organize_imports",
                    },
                },
            })
        end
    }
}
