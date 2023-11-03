if vim.g.snippets == "luasnip" then
	return
end

local ls = require("luasnip")
local types = require("luasnip.util.types")

ls.config.set_config({
	-- This tells Luasnip to remember to keep around the last snippet.
	-- You can jump back into it even if you move outside of the selection.
	history = true,
	-- This one is cool cause if you have dynamic snippets, it updates as you type.
	updateEvents = "TextChanged,TextChangedI",

	-- Autosnippets:
	enable_autosnippets = true,

	-- Crazy highlights!!
	-- #vid3
	-- ext_opts = nil
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = { { " « ", "NonTest" } },
			},
		},
	},
})

vim.keymap.set({ "i", "s" }, "<c-k>", function()
	if ls.expand_or_jumpable() then
		ls.expand_or_jump()
	end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<c-j>", function()
	if ls.jumpable(-1) then
		ls.jump(-1)
	end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<c-l>", function()
	if ls.choice_active() then
		ls.change_choice()
	end
end, { silent = true })
