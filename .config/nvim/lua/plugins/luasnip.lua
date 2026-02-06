return {
    {
        "L3MON4D3/LuaSnip",
        dependencies = { 'saadparwaiz1/cmp_luasnip' },
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp",
        config = function()
            local luasnip = require("luasnip")

            -- Setup LuaSnip with configuration
            luasnip.setup({
                history = true,
                updateevents = "TextChanged,TextChangedI",
                enable_autosnippets = true,
            })

            -- Keybindings for snippet navigation
            vim.keymap.set({"i", "s"}, "<Tab>", function()
                if luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                end
            end, {silent = true})

            vim.keymap.set({"i", "s"}, "<S-Tab>", function()
                if luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                end
            end, {silent = true})

            vim.keymap.set({"i", "s"}, "<C-e>", function()
                if luasnip.choice_active() then
                    luasnip.change_choice(1)
                end
            end, {silent = true})

            -- Load custom snippets from the custom folder
            require("luasnip.loaders.from_lua").lazy_load({
                paths = { vim.fn.stdpath("config") .. "/lua/customs/snippets" }
            })

            -- You can also load from VSCode-style snippets if needed
            -- require("luasnip.loaders.from_vscode").lazy_load({
            --     paths = { vim.fn.stdpath("config") .. "/custom" }
            -- })

            -- Optional: Configure LuaSnip settings
            -- luasnip.config.set_config({
            --     history = true,
            --     updateevents = "TextChanged,TextChangedI",
            --     enable_autosnippets = true,
            -- })
        end
    }
}
