-- Use ark with nvim-lspconfig.

local lsp = require 'lspconfig'
local configs = require 'lspconfig.configs'

local rpattern = lsp.util.root_pattern(
  "DESCRIPTION",
  "NAMESPACE",
  ".Rbuildignore",
  ".RProj",
  ".Rproj",
  ".rproj"
)

if not configs.ark then
  configs.ark = {
    default_config = {
      cmd = { "ark-lsp.py", "--timeout", "2" },
      filetypes = { 'r', 'R' },
      single_file_support = true,
      root_dir = function(fname)
        return rpattern(fname) or vim.loop.os_homedir()
      end,
    },
  }
end

lsp.ark.setup {}
