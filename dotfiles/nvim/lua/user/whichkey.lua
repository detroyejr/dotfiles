local status_ok, wk = pcall(require, "which-key")
if not status_ok then
  return
end

wk.setup()

-- Top level
wk.add({
  { "<leader>e", "<cmd>Explore<cr>", desc = "Explorer" },
  { "<leader>h", "<cmd>noh<cr>",     desc = "Remove highlight" },
  { "<leader>c", "<cmd>bd<cr>",      desc = "Close Buffer" },
})

-- Telescope
wk.add({
  { "<leader>f",  group = "Search" },
  { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File", mode = "n" },
  { "<leader>fF", "<cmd>Telescope live_grep<cr>",  desc = "Find Text", mode = "n" },
})

-- LSP
wk.add({
  { "<leader>l",  group = "LSP" },
  { "<leader>li", "<cmd>LspInfo<cr>", desc = "Info" },
  {
    "<leader>lf",
    "<cmd>lua require('conform').format({ lsp_fallback = 'always', async = true })<cr>",
    desc = "Format",
    mode = "n",
  },
  { "<leader>ll", "<cmd>lua vim.diagnostic.goto_next()<cr>", desc = "Next Diagnostic" },
  { "<leader>lh", "<cmd>lua vim.diagnostic.goto_prev()<cr>", desc = "Prev Diagnostic" },
  { "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>",       desc = "Rename" },
})

-- Git
wk.add({
  { "<leader>g",  group = "Git" },
  { "<leader>gj", "<cmd>lua require 'gitsigns'.next_hunk()<cr>",       desc = "Next Hunk" },
  { "<leader>gk", "<cmd>lua require 'gitsigns'.prev_hunk()<cr>",       desc = "Prev Hunk" },
  { "<leader>gl", "<cmd>lua require 'gitsigns'.blame_line()<cr>",      desc = "Blame Line" },
  { "<leader>gp", "<cmd>lua require 'gitsigns'.preview_hunk()<cr>",    desc = "Preview Hunk" },
  { "<leader>gr", "<cmd>lua require 'gitsigns'.reset_hunk()<cr>",      desc = "Reset Hunk" },
  { "<leader>gR", "<cmd>lua require 'gitsigns'.reset_buffer()<cr>",    desc = "Reset Buffer" },
  { "<leader>gs", "<cmd>lua require 'gitsigns'.stage_hunk()<cr>",      desc = "Stage Hunk" },
  { "<leader>gu", "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", desc = "Undo Stage Hunk" },
  { "<leader>gd", "<cmd>lua require 'gitsigns'.diffthis HEAD<cr>",     desc = "Checkout commits" },
})

-- Terminal
if os.getenv("TMUX") then
  wk.add({
    { "<leader>t",  group = "Terminal" },
    {
      "<leader>tf",
      "<cmd>!tmux display-popup -h 75\\% -w 75\\% -E "
      .. '"tmux new-session -A '
      .. "-s $(tmux display-message "
      .. "-p '\\#{session_name}')-shell\" "
      .. "</dev/null >/dev/null 2>&1 & <CR>"
      .. "<CR>",
      desc = "Float",
    },
    { "<leader>th", "<cmd>!tmux split-window<CR><CR>",    desc = "Horizontal" },
    { "<leader>tv", "<cmd>!tmux split-window -h<CR><CR>", desc = "Vertical" },
  })
else
  wk.add({
    { "<leader>tf", "<cmd>terminal<cr>",             desc = "Float" },
    { "<leader>th", "<cmd>new term://${SHELL}<cr>",  desc = "Horizontal" },
    { "<leader>tv", "<cmd>vnew term://${SHELL}<cr>", desc = "Vertical" },
  })
end

-- TODO: ADD git back.
--   g = {
--     name = "Git",
--     j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
--     k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
--     l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
--     p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
--     r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
--     R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
--     s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
--     u = {
--       "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
--       "Undo Stage Hunk",
--     },
--     o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
--     b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
--     -- c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
--     d = {
--       "<cmd>Gitsigns diffthis HEAD<cr>",
--       "Diff",
--     },
--   },
--   l = {
--     name = "LSP",
--     a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
--     D = { "<cmd>Telescope diagnostics<cr>", "Document Diagnostics" },
--     d = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Document Diagnostics" },
--     k = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Document Diagnostics" },
--     j = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Document Diagnostics" },
--     f = { "<cmd>lua require('conform').format({ lsp_fallback = 'always', async = true })<cr>", "Format" },
--     i = { "<cmd>LspInfo<cr>", "Info" },
--     I = { "<cmd>LspInstallInfo<cr>", "Installer Info" },
--     l = { "<cmd>lua vim.diagnostic.goto_next()<CR>", "Next Diagnostic" },
--     h = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Prev Diagnostic" },
--     q = { "<cmd>lua vim.diagnostic.setloclist()<cr>", "Quickfix" },
--     r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
--     s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
--     S = { "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Workspace Symbols" },
