local find_mapping = function(maps, lhs)
    print('Searching for ', lhs)
    for _, value in ipairs(maps) do
        if value.lhs == lhs then
            return value
        end
    end
end

describe("mapstack", function()
    before_each(function()
        require("stackmap")._clear()
    end)
    it("can be required", function()
        require("stackmap")
    end)


    it("can push single mapping", function()
        require("stackmap").push("test1", "n", { asdf = "echo 'This is a test'", })


        local maps = vim.api.nvim_get_keymap('n')
        local found = find_mapping(maps, "asdf")
        assert.are.same(found.rhs, "echo 'This is a test'")
    end)

    it("can push multiple mapping", function()
        require("stackmap").push("test1", "n", {
            ["asdf_1"] = "echo 'This is a test1'",
            ["asdf_2"] = "echo 'This is a test2'",
        })

        local maps = vim.api.nvim_get_keymap('n')
        local found = find_mapping(maps, "asdf_1")
        assert.are.same(found.rhs, "echo 'This is a test1'")

        local found2 = find_mapping(maps, "asdf_2")
        assert.are.same(found2.rhs, "echo 'This is a test2'")
    end)

    it("can pop single mapping", function()
        require("stackmap").push("test2", "n", { asdf2 = "echo 'This is a test2'", })


        local maps = vim.api.nvim_get_keymap('n')
        local found = find_mapping(maps, "asdf2")
        assert.are.same(found.rhs, "echo 'This is a test2'")

        require("stackmap").pop("test2")

        local after_pop_maps = vim.api.nvim_get_keymap('n')
        local after_pop = find_mapping(after_pop_maps, "asdf2")
        assert.are.same(nil, after_pop)
    end)

    it("can pop single mapping and restore", function()
        require("stackmap").push("test1", "n", { ['\\nd'] = "echo 'This is a test pop'", })


        local maps = vim.api.nvim_get_keymap('n')
        local found = find_mapping(maps, "\\nd")
        assert.are.same(found.rhs, "echo 'This is a test pop'")

        require("stackmap").pop("test1")

        local after_pop_maps = vim.api.nvim_get_keymap('n')
        local after_pop = find_mapping(after_pop_maps, "\\nd")
        assert.are.same(nil, after_pop)
    end)
end)
