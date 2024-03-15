-- LSP Config

local servers = {
  "clangd",
  "lua_ls",
  "nixd",
  "pylsp",
  "r_language_server",
  "rust_analyzer",
}

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
  return
end

local opts = {}

for _, server in pairs(servers) do
  opts = {
    on_attach = require("user.lsp.handlers").on_attach,
    capabilities = require("user.lsp.handlers").capabilities,
  }

  server = vim.split(server, "@")[1]

  local require_ok, conf_opts = pcall(require, "user.lsp.settings." .. server)
  if require_ok then
    opts = vim.tbl_deep_extend("force", conf_opts, opts)
  end

  lspconfig[server].setup(opts)
end

-- Completion, snippets.
require("user.lsp.cmp")

-- LSP handlers, documentation keymaps
require("user.lsp.handlers").setup()

-- Treesitter
require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "css",
    "go",
    "html",
    "javascript",
    "lua",
    "markdown",
    "nix",
    "python",
    "r",
    "rust",
    "vim",
  },
  sync_install = false,
  highlight = {
    enable = true,
    disable = { "" },
    additional_vim_regex_highlighting = true,
  },
  indent = { enable = true, disable = { "yaml" } },
  context_commentstring = {
    enable = true,
    enable_autocmd = true,
  },
})

-- Conform formatters
require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "isort", "black", "ruff" },
    ["*"] = { "trim_whitespace" },
  },
})

require("quarto").setup({
  debug = false,
  closePreviewOnExit = true,
  lspFeatures = {
    enabled = true,
    languages = { "r", "python" },
    chunks = "curly", -- 'curly' or 'all'
    diagnostics = {
      enabled = true,
      triggers = { "BufWritePost" },
    },
    completion = {
      enabled = true,
    },
  },
  keymap = {
    hover = "K",
    definition = "gd",
    rename = "<leader>lR",
    references = "gr",
  },
})
