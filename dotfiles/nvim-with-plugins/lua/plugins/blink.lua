return {
  'saghen/blink.cmp',
  dependencies = { 'rafamadriz/friendly-snippets' },

  version = '1.*',
  opts = {
    keymap = { preset = 'default' },

    appearance = {
      nerd_font_variant = 'mono'
    },
    completion = { documentation = { auto_show = false }, list = { selection = { preselect = false } } },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    fuzzy = {
      implementation = "lua",
      sorts = {
        -- Always prioritize exact matches, case-sensitive.
        "exact",

        -- Sort by `sortText` field from LSP server, defaults to `label`.
        -- `sortText` often differs from `label`.
        "sort_text",

        -- Sort by Fuzzy matching score.
        "score",

        -- Sort by `label` field from LSP server, i.e. name in completion menu.
        -- Needed to sort results from LSP server by `label`,
        -- even though protocol specifies default value of `sortText` is `label`.
        "label",
      }
    },
  },
  opts_extend = { "sources.default" }
}
