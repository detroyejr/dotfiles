-- Use ark with builtin nvim lsp.

vim.lsp.config["ark"] = {
  cmd = { "ark-lsp.py" },
  filetypes = { 'r', 'R' },
  root_markers = {
    '.rproj',
    '.Rproj',
    '.RPROJ',
    '.RProj',
    'DESCRIPTION',
    'NAMESPACE',
    '.git'
  },
}

vim.lsp.config["air"] = {
  cmd = { "air", "language-server" },
  filetypes = { 'r', 'R' },
  root_markers = {
    '.rproj',
    '.Rproj',
    '.RPROJ',
    '.RProj',
    'DESCRIPTION',
    'NAMESPACE',
    '.git'
  },
}

vim.lsp.enable("ark")
vim.lsp.enable("air")
