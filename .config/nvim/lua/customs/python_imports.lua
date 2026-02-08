local M = {}

M.transform_python_class_import_to_module = function()
    -- Get inside the word
    -- This is required for <cword> to work even we are not at the end of line
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd("normal! h")
    local class_name = vim.fn.expand("<cword>")
    vim.api.nvim_win_set_cursor(0, { cursor_pos[1], cursor_pos[2] })

    local bufnr = vim.api.nvim_get_current_buf()
    local start_line = cursor_pos[1]

    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local import_idx, package_name, module_name = -1, nil, nil

    -- 1. Find the import line
    for i, line in ipairs(lines) do
        local raw_package = line:match("from%s+(.+)%s+import%s+.*" .. class_name)

        if raw_package then
            -- Split package and module
            package_name, module_name = raw_package:match("(.+)%.([^%.]+)$")
            if package_name and module_name then
                import_idx = i
                break
            end
        end
    end


    if not package_name then
        -- Compensate the normal-mode `h` we used to be sure we capture the word
        return
    end

    -- 2. Look for an existing "import mod as alias" or "import mod"
    local existing_alias = nil
    for _, line in ipairs(lines) do
        -- First try to match "import mod as alias"
        local alias = line:match("from%s+" ..
            package_name:gsub("%.", "%%.") .. "%s+import%s+" .. module_name .. "%s+as%s+([%w_]+)")

        if alias then
            existing_alias = alias
            break
        end

        -- Then try to match plain "import mod" (without as clause)
        local plain_match = line:match("from%s+" ..
            package_name:gsub("%.", "%%.") .. "%s+import%s+.*" .. module_name)

        if plain_match then
            existing_alias = module_name
            break
        end
    end

    if existing_alias then
        -- CASE A: ALREADY EXISTS
        vim.api.nvim_buf_set_lines(bufnr, import_idx - 1, import_idx, false, {})
        -- Adjust line number if import was deleted before our start line
        local adjusted_line = start_line > import_idx and start_line - 1 or start_line
        -- Save cursor position before substitution
        local saved_cursor = vim.api.nvim_win_get_cursor(0)
        vim.cmd(string.format("silent! %ds/\\<%s\\>/%s.%s/g", adjusted_line, class_name, existing_alias, class_name))
        vim.cmd("nohlsearch")
        -- Restore cursor position, adjusting for added prefix (alias + dot)
        local prefix_length = #existing_alias + 1 -- +1 for the dot
        vim.api.nvim_win_set_cursor(0, { saved_cursor[1], saved_cursor[2] + prefix_length })
    else
        -- CASE B: NEW IMPORT NEEDED
        -- Save cursor position before moving to import line
        local saved_cursor = vim.api.nvim_win_get_cursor(0)
        local new_import = string.format("from %s import %s as ", package_name, module_name)
        vim.api.nvim_buf_set_lines(bufnr, import_idx - 1, import_idx, false, { new_import })

        vim.api.nvim_win_set_cursor(0, { import_idx, #new_import })
        vim.ui.input({}, function(alias)
            local prefix_to_add
            if alias == nil or alias == '' then
                -- Replace occurrence on the original line
                vim.cmd(string.format("silent! %ds/%s/%s.%s/g", start_line, class_name, module_name, class_name))
                -- Fix the import line itself (it accidentally got renamed to alias.MyClass)
                vim.cmd(string.format("silent! %ds/ as //g", import_idx))
                prefix_to_add = module_name
            else
                -- Replace occurrence on the original line
                vim.cmd(string.format("silent! %ds/\\<%s\\>/%s.%s/g", start_line, class_name, alias, class_name))
                vim.cmd(string.format("normal %sGA%s", import_idx, alias))
                prefix_to_add = alias
            end
            vim.cmd("nohlsearch")
            -- Restore cursor to original position, adjusting for added prefix (alias/module + dot) and insert mode (+1)
            local prefix_length = #prefix_to_add + 1 -- +1 for the dot
            vim.api.nvim_win_set_cursor(0, { saved_cursor[1], saved_cursor[2] + prefix_length + 1 })
        end)
    end
end

return M
