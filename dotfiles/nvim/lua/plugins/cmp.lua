return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',
    'hrsh7th/nvim-cmp',
  },
  config = function()
    local cmp = require("cmp")
    local ls = require('luasnip')

    require('luasnip.loaders.from_lua').load({
      paths = { '~/.config/nvim/lua/snippets/' },
    })

    local kind_icons = {
      Text = "",
      Method = "m",
      Function = "󰊕",
      Constructor = "",
      Field = "",
      Variable = "",
      Class = "",
      Interface = "",
      Module = "",
      Property = "",
      Unit = "",
      Value = "",
      Enum = "",
      Keyword = "",
      Snippet = "",
      Color = "",
      File = "",
      Reference = "",
      Folder = "",
      EnumMember = "",
      Constant = "",
      Struct = "",
      Event = "",
      Operator = "",
      TypeParameter = "",
    }
    cmp.setup({
      snippet = {
        expand = function(args)
          ls.lsp_expand(args.body)
          -- With native snippets.
          -- vim.snippet.expand(args.body)
        end,
      },
      sources = {
        { name = 'nvim_lsp' },
        { name = 'buffers' },
        {
          name = "path",
          option = {
            get_cwd = function(params)
              local first_active = vim.lsp.get_active_clients()[1]
              local default_path = vim.fn.expand(("#%d:p:h"):format(params.context.bufnr))
              -- R path completion is relative to the file open. We'd rather use
              -- the project directory as defined by the .RProj file.
              if first_active and first_active.name == "ark" then
                return vim.fs.dirname(vim.fs.find(function(name)
                  if name:match(".*%.[rR][pP]roj$") then
                    return name:match(".*%.[rR][pP]roj$")
                  elseif name:match(".[rR][eE]nviron") then
                    return name:match(".[rR][eE]nviron")
                  else
                    return default_path
                  end
                end, { upward = true, type = "file" })[1])
              end
              return default_path
            end,
          },
        },
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<C-k>'] = cmp.mapping(function() ls.expand_or_jump() end),
      }),
      window = {
        documentation = cmp.config.window.bordered()
      },
      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
          -- Kind icons
          vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
          vim_item.menu = ({
            nvim_lsp = "[LSP]",
            nvim_lua = "[NVIM_LUA]",
            luasnip = "[Snippet]",
            buffer = "[Buffer]",
            path = "[Path]",
          })[entry.source.name]
          return vim_item
        end,
      },
    })
  end,
}
