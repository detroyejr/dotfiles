return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lspconfig = require('lspconfig')

    local servers = {
      "clangd",
      "lua_ls",
      "nixd",
      "pylsp",
      -- "r_language_server",
      "ruff",
    }

    local opts = {
      capabilities = require('cmp_nvim_lsp').default_capabilities()
    }

    local signs = {
      { name = "DiagnosticSignError", text = "" },
      { name = "DiagnosticSignWarn", text = "" },
      { name = "DiagnosticSignHint", text = "" },
      { name = "DiagnosticSignInfo", text = "" },
    }

    local config = {
      virtual_text = true,
      signs = {
        active = signs,
      },
      update_in_insert = true,
      underline = true,
      severity_sort = true,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    }
    vim.diagnostic.config(config)

    for _, server in pairs(servers) do
      local ok, setting = pcall(require, "plugins.settings." .. server)
      if ok then
        opts = vim.tbl_deep_extend("force", opts, setting)
        lspconfig[server].setup(opts)
      else
        lspconfig[server].setup(opts)
      end
    end

    for _, sign in ipairs(signs) do
      vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
    end
  end,
  keys = {
    { "gD",         "<cmd>lua vim.lsp.buf.declaration()<CR>",           silent = true },
    { "gd",         ":lua vim.lsp.buf.definition()<cr>",                silent = true },
    { "gi",         "<cmd>lua vim.lsp.buf.implementation()<CR>",        silent = true },
    { "gj",         "<cmd>lua vim.lsp.buf.signature_help()<CR>",        silent = true },
    { "gk",         "<cmd>lua vim.lsp.buf.hover()<CR>",                 silent = true },
    { "gr",         "<cmd>lua vim.lsp.buf.references()<CR>",            silent = true },
    { "<leader>lf", ":lua vim.lsp.buf.format({timeout_ms = 5000})<cr>", silent = true },
    { "<leader>lh", "<cmd>lua vim.diagnostic.goto_prev()<CR>",          silent = true, noremap = true },
    { "<leader>li", "<cmd>LspInfo<cr>", },
    { "<leader>ll", "<cmd>lua vim.diagnostic.goto_next()<CR>",          silent = true, noremap = true },
    { "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>",                silent = true, noremap = true },
  }
}
