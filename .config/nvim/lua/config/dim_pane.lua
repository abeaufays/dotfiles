local _hl = {}
local _is_dimmed = false
local focus_augroup = vim.api.nvim_create_augroup('tmux-focus-dim', { clear = true })

local function darken(color, factor)
    if not color then return nil end
    local r = math.floor(math.floor(color / 0x10000) * factor)
    local g = math.floor(math.floor((color % 0x10000) / 0x100) * factor)
    local b = math.floor((color % 0x100) * factor)
    return r * 0x10000 + g * 0x100 + b
end

local function save_baseline()
    if not _is_dimmed then
        _hl.Normal = vim.api.nvim_get_hl(0, { name = 'Normal', link = false })
        _hl.NormalNC = vim.api.nvim_get_hl(0, { name = 'NormalNC', link = false })
    end
end

vim.api.nvim_create_autocmd('ColorScheme', {
    group = focus_augroup,
    callback = save_baseline,
})

vim.api.nvim_create_autocmd('FocusLost', {
    group = focus_augroup,
    callback = function()
        save_baseline()
        if not _hl.Normal then return end
        _is_dimmed = true
        vim.api.nvim_set_hl(0, 'Normal', { fg = _hl.Normal.fg, bg = darken(_hl.Normal.bg, 0.75) })
        vim.api.nvim_set_hl(0, 'NormalNC', { fg = _hl.NormalNC.fg, bg = darken(_hl.NormalNC.bg or _hl.Normal.bg, 0.75) })
    end,
})

vim.api.nvim_create_autocmd('FocusGained', {
    group = focus_augroup,
    callback = function()
        _is_dimmed = false
        if _hl.Normal then vim.api.nvim_set_hl(0, 'Normal', _hl.Normal) end
        if _hl.NormalNC then vim.api.nvim_set_hl(0, 'NormalNC', _hl.NormalNC) end
    end,
})
