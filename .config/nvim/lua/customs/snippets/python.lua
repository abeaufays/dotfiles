local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local sn = ls.snippet_node

return {
    s("__init__", {
        t("def __init__(self"),
        i(1),
        t("):"),
        t({ "", "    " }),
        d(2, function(args)
            local params = args[1][1]
            if params == "" then
                return sn(nil, { i(1) })
            end

            local nodes = {}
            -- Split parameters by comma
            for param in string.gmatch(params, "([^,]+)") do
                -- Trim whitespace and extract parameter name (before any = or :)
                local param_name = param:match("^%s*([%w_]+)")
                if param_name then
                    table.insert(nodes, t({ "self." .. param_name .. " = " .. param_name, "    " }))
                end
            end
            table.insert(nodes, i(1))
            return sn(nil, nodes)
        end, { 1 }),
    }),
}
