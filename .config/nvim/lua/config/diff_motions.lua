local M = {}

function M.setup()
    vim.api.nvim_create_autocmd('FileType', {
        pattern = 'diff',
        callback = function(args)
            -- Use the usual change motions to navigate between contiguous
            -- chunks of added/removed lines, including in `git add -e`
            -- buffers.
            local change_query = vim.treesitter.query.parse('diff', [[
[
  (addition) @change
  (deletion) @change
]
]])

            local function get_change_chunks()
                local root = vim.treesitter.get_parser(args.buf, 'diff'):parse()[1]:root()
                local chunks = {}

                for _, node in change_query:iter_captures(root, args.buf, 0, -1) do
                    local start_row, _, end_row = node:range()
                    local chunk = chunks[#chunks]
                    -- Diff line nodes end on the same row they start on, so
                    -- the next row is still contiguous.
                    if chunk and start_row <= chunk.end_row + 1 then
                        chunk.end_row = end_row
                    else
                        table.insert(chunks, { start_row = start_row, end_row = end_row })
                    end
                end
                return chunks
            end

            local function move_to_chunk(opts)
                local direction = opts.forward and 'next' or 'previous'
                local chunks = get_change_chunks()
                for _ = 1, vim.v.count1 do
                    local row = vim.fn.line('.') - 1
                    local target

                    for _, chunk in ipairs(chunks) do
                        if direction == 'next' and chunk.start_row > row then
                            target = chunk.start_row
                            break
                        elseif direction == 'previous' and chunk.end_row <= row then
                            target = chunk.start_row
                        end
                    end

                    if not target then
                        return
                    end
                    vim.api.nvim_win_set_cursor(0, { target + 1, 0 })
                end
            end

            local repeatable_move = require('nvim-treesitter-textobjects.repeatable_move')
            local repeatable_chunk_move = repeatable_move.make_repeatable_move(move_to_chunk)

            vim.keymap.set({ 'n', 'x', 'o' }, '[c', function()
                repeatable_chunk_move { forward = false }
            end, { buffer = args.buf, desc = 'Previous diff chunk' })
            vim.keymap.set({ 'n', 'x', 'o' }, ']c', function()
                repeatable_chunk_move { forward = true }
            end, { buffer = args.buf, desc = 'Next diff chunk' })
        end,
    })
end

return M
