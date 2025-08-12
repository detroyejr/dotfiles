-- Default LSP Settings

local lsps = { "ark", "air", "pylsp", "ruff", "nixd", "lua_ls", "clangd" }

for _, lsp in ipairs(lsps) do
  vim.lsp.enable(lsp)
end

vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities()
})

vim.diagnostic.config({
  severity_sort = true,
  underline = true,
  update_in_insert = true,
  virtual_text = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = "󰋼 ",
      [vim.diagnostic.severity.HINT] = "󰌵 ",
    },
  },
})

vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
vim.keymap.set("n", "gj", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
vim.keymap.set("n", "gk", "<cmd>lua vim.lsp.buf.hover()<CR>")
vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
vim.keymap.set("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format({ timeout_ms = 5000 })<CR>")
vim.keymap.set("n", "<leader>lh", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
vim.keymap.set("n", "<leader>li", "<cmd>:checkhealth lsp<CR>")
vim.keymap.set("n", "<leader>ll", "<cmd>lua vim.diagnostic.goto_next()<CR>")
vim.keymap.set("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>")
