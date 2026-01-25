return {
    "TheNoeTrevino/haunt.nvim",
    -- default config: change to your liking, or remove it to use defaults
    ---@class HauntConfig
    opts = {
        sign = "󱙝",
        sign_hl = "DiagnosticInfo",
        virt_text_hl = "HauntAnnotation", -- links to DiagnosticVirtualTextHint
        annotation_prefix = " 󰆉 ",
        line_hl = nil,
        virt_text_pos = "eol",
        data_dir = nil,
        per_branch_bookmarks = true,
        picker = "snacks", -- "auto", "snacks", "telescope", or "fzf"
        picker_keys = {    -- picker agnostic, we got you covered
            delete = { key = "d", mode = { "n" } },
            edit_annotation = { key = "a", mode = { "n" } },
        },
    },
    -- recommended keymaps, with a helpful prefix alias
    init = function()
        local haunt = require("haunt.api")
        local haunt_picker = require("haunt.picker")
        local map = vim.keymap.set
        local prefix = "<leader>h"

        -- annotations
        map("n", prefix .. "a", function()
            haunt.annotate()
        end, { desc = "[A]nnotate" })

        map("n", prefix .. "t", function()
            haunt.toggle_annotation()
        end, { desc = "[T]oggle annotation" })

        map("n", prefix .. "T", function()
            haunt.toggle_all_lines()
        end, { desc = "[T]oggle all annotations" })

        map("n", prefix .. "d", function()
            haunt.delete()
        end, { desc = "[D]elete bookmark" })

        map("n", prefix .. "D", function()
            haunt.clear_all()
        end, { desc = "[D]elete all bookmarks" })

        -- move
        map("n", prefix .. "p", function()
            haunt.prev()
        end, { desc = "[P]revious bookmark" })

        map("n", prefix .. "n", function()
            haunt.next()
        end, { desc = "[N]ext bookmark" })

        -- picker
        map("n", "<leader>fh", function()
            haunt_picker.show()
        end, { desc = "bookmarks from [H]aunt" })

        -- quickfix
        map("n", prefix .. "q", function()
            haunt.to_quickfix()
        end, { desc = "Send bookmarks to [Q]uickFix List (from buffer)" })

        map("n", prefix .. "Q", function()
            haunt.to_quickfix({ current_buffer = true })
        end, { desc = "Send bookmarks to [Q]uickFix List (all)" })
    end,
}
