require('nishanth.globals')
local M = {}

-- function M.setup()
--     print("setting up stack maps, please wait...")
-- end
--


local find_mapping = function(maps, lhs)
    print('Searching for ', lhs)
    for _, value in ipairs(maps) do
        if value.lhs == lhs then
            return value
        end
    end
end
--[[public API ]]
M.pop    = function(name)
    local state = M._stack[name]
    local existing = state.existing
    local mapping = state.mappings
    M._stack[name] = nil


    for lhs, _ in pairs(mapping) do
        if existing[lhs] then
            vim.keymap.set(state.mode, lhs, existing[lhs].rhs)
        else
            vim.keymap.del(state.mode, lhs)
        end
    end
end

M._stack = {}

M.push   = function(name, mode, mappings)
    local maps = vim.api.nvim_get_keymap(mode)

    local existing_maps = {}
    for lhs, rhs in pairs(mappings) do
        local existing = find_mapping(maps, lhs)
        if existing then
            existing_maps[lhs] = existing
        end
    end
    M._stack[name] = {
        mode = mode,
        existing = existing_maps,
        mappings = mappings,
    }

    for lhs, rhs in pairs(mappings) do
        vim.keymap.set(mode, lhs, rhs)
    end
end



M._clear = function()
    M._stack = {}
end

--[[
--
multiline comment
--]]
return M
