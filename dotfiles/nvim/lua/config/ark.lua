# Configure nvim-lspconfig to use ark.

M = {}

local lsp = require 'lspconfig'
local configs = require 'lspconfig.configs'

M.setup = function()
  if not configs.ark then
    configs.ark = {
      default_config = {
        cmd = { os.getenv("HOME") .. "/.config/dotfiles/dotfiles/bash/ark-lsp.py" },
        filetypes = { 'r', 'R' },
        single_file_support = true,
        root_dir = function(fname)
          return lsp.util.root_pattern("DESCRIPTION", "NAMESPACE", ".Rbuildignore", ".RProj", ".Rproj", ".rproj")(
                fname) or
              vim.loop.os_homedir()
        end,
      },
    }
  end
  lsp.ark.setup {}
end

M.setup()
