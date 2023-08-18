require("luasnip.loaders.from_vscode").lazy_load()
local ls = require 'luasnip'

-- This is a snippets creator
-- s('<trigger>', <nodes>)
local s, i, t, c = ls.s, ls.i, ls.text_node, ls.choice_node

-- This is a format node.
-- It takes a format string and a list of nodes.
-- fmt(<fmt string>, {...nodes})
local fmt = require("luasnip.extras.fmt").fmt

-- Repeat a node.
local rep = require("luasnip.extras").rep

-- Lua specific snippets go here.
ls.add_snippets("lua", {
  s("req", fmt("local {} = require('{}')", { i(1), i(2) }))
})


ls.add_snippets("markdown", {
  s("header", fmt(
    [[
      ---
      title: {}
      date: {}
      {}
      ---
    ]],
    { i(1), os.date("%Y-%m-%d"), c(2, { fmt("keywords: [{}]", i(1)), t "" }) }
  ))
})
