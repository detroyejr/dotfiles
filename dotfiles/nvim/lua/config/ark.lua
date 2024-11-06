# Configure nvim-lspconfig to use ark.

M = {}

local lsp = require 'lspconfig'
local configs = require 'lspconfig.configs'

if not configs.ark then
  configs.ark = {
    default_config = {
      cmd = vim.lsp.rpc.connect('127.0.0.1', M.on_attach()),
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

M.setup = function()
  lsp.ark.setup {
    on_attach = M.on_attach
  }
end

M.on_attach = function()
  local f = assert(io.popen('ark-lsp', 'r'))
  local lsp_port = assert(f:read('*a')); f:close()
  return tonumber(lsp_port)
end

M.setup()
