local function transform_python_class_import_to_module()
    local cls = vim.fn.expand("<cword>")
    local bufnr = vim.api.nvim_get_current_buf()
    local start_line = vim.api.nvim_win_get_cursor(0)[1]

    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local import_idx, pkg, mod = -1, nil, nil

    -- 1. Find the import line
    for i, line in ipairs(lines) do
        local raw_package = line:match("from%s+(.+)%s+import%s+.*" .. cls)

        if raw_package then
            -- Split package and module
            pkg, mod = raw_package:match("(.+)%.([^%.]+)$")
            if pkg and mod then
                import_idx = i
                break
            end
        end
    end

    if not pkg then return end

    -- 2. Look for an existing "import mod as alias"
    local existing_alias = nil
    for _, line in ipairs(lines) do
        local alias = line:match("from%s+" .. pkg:gsub("%.", "%%.") .. "%s+import%s+" .. mod .. "%s+as%s+([%w_]+)")
        if alias then
            existing_alias = alias
            break
        end
    end

    -- 3. Execution
    if existing_alias then
        -- CASE A: ALREADY EXISTS
        vim.api.nvim_buf_set_lines(bufnr, import_idx - 1, import_idx, false, {})
        -- Adjust line number if import was deleted before our start line
        local adjusted_line = start_line > import_idx and start_line - 1 or start_line
        vim.cmd(string.format("silent! %ds/\\<%s\\>/%s.%s/g", adjusted_line, cls, existing_alias, cls))
        vim.api.nvim_win_set_cursor(0, { adjusted_line, 0 })
        vim.cmd("normal! $")
    else
        -- CASE B: NEW IMPORT NEEDED
        local new_import = string.format("from %s import %s as ", pkg, mod)
        vim.api.nvim_buf_set_lines(bufnr, import_idx - 1, import_idx, false, { new_import })

        -- Move to line and start insert
        vim.api.nvim_win_set_cursor(0, { import_idx, #new_import })
        vim.cmd("startinsert!")

        -- Simple cleanup after typing alias
        vim.api.nvim_create_autocmd("InsertLeave", {
            buffer = bufnr,
            once = true,
            callback = function()
                local alias = vim.api.nvim_get_current_line():match("as%s+([%w_]+)%s*$")
                if alias then
                    -- Replace occurrence on the original line
                    vim.cmd(string.format("silent! %ds/\\<%s\\>/%s.%s/g", start_line, cls, alias, cls))
                    -- Fix the import line itself (it accidentally got renamed to alias.MyClass)
                    vim.cmd(string.format("silent! %ds/%s\\.%s/%s/", import_idx, alias, cls, cls))
                end
                vim.api.nvim_win_set_cursor(0, { start_line, 0 })
                vim.cmd("normal! $")
            end
        })
    end
end
vim.keymap.set('n', '<leader>ri', transform_python_class_import_to_module)
