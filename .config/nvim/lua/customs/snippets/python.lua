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
                -- Trim whitespace
                param = param:match("^%s*(.-)%s*$")
                
                -- Extract parameter name and type hint
                -- Handle cases: "name", "name: type", "name: type = default", "name = default"
                local param_name, type_hint = param:match("^([%w_]+)%s*:%s*([^=]+)")
                
                if not param_name then
                    -- No type hint found, just extract the name (before =)
                    param_name = param:match("^([%w_]+)")
                end
                
                if param_name then
                    local assignment
                    if type_hint then
                        -- Clean up type hint (remove trailing whitespace and default value)
                        type_hint = type_hint:match("^%s*(.-)%s*$")
                        assignment = "self." .. param_name .. ": " .. type_hint .. " = " .. param_name
                    else
                        assignment = "self." .. param_name .. " = " .. param_name
                    end
                    table.insert(nodes, t({ assignment, "    " }))
                end
            end
            table.insert(nodes, i(1))
            return sn(nil, nodes)
        end, { 1 }),
    }),
}
