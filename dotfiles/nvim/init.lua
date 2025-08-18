-- Minimal Lua Config

vim.g.netrw_altv = 1
vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_preview = 1
vim.g.netrw_winsize = 30

vim.opt.backup = false
vim.opt.clipboard = "unnamedplus"
vim.opt.colorcolumn = "89"
vim.opt.completeopt = "menuone,popup,noinsert,fuzzy"
vim.opt.expandtab = true
vim.opt.pumheight = 10
vim.opt.relativenumber = true
vim.opt.shiftwidth = 2
vim.opt.signcolumn = "yes"
vim.opt.softtabstop = 2
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.timeoutlen = 500
vim.opt.undofile = true
vim.opt.updatetime = 50
vim.opt.wrap = false
vim.opt.writebackup = false

local opts = { silent = true }
vim.g.mapleader = " "
vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("n", "<Leader>", " ")
vim.keymap.set("n", "<Leader>e", ":Lexplore<CR>", opts)
vim.keymap.set("n", "<Leader>h", ":noh<CR>", opts)
vim.keymap.set("n", "<Leader>lf", ":lua vim.lsp.buf.format()<CR>", opts)
vim.keymap.set("n", "<Leader>li", ":checkhealth lsp<CR>", opts)
vim.keymap.set("n", "<Leader>th", ":botright terminal<CR>", opts)
vim.keymap.set("n", "<Leader>tv", ":vertical terminal<CR>", opts)
vim.keymap.set("n", "<Leader>ff", ":terminal fzf<CR>i", opts)
vim.keymap.set("n", "<Leader>fF",
  ":terminal fzf --disabled --ansi " ..
  "--bind \"start:reload:rg --column --color=always --smart-case {q}\" " ..
  "--bind \"change:reload:rg --column --color=always --smart-case {q}\" " ..
  "--delimiter : " ..
  "--preview 'bat --style=full --color=always --highlight-line {2} {1}' " ..
  "--preview-window '~4,+{2}+4/3,<80(up)'<CR>i", opts)

vim.keymap.set("n", "<Leader>gA", ":terminal git add -A<CR>")
vim.keymap.set("n", "<Leader>gaa", ":terminal git add '%'<CR>i")
vim.keymap.set("n", "<Leader>gai", ":terminal git ai<CR>i")
vim.keymap.set("n", "<Leader>gc", ":terminal git commit<CR>i")
vim.keymap.set("n", "<Leader>gs", ":terminal git status<CR>i")

local tmux = os.getenv("TMUX")

if tmux then
  vim.keymap.set(
    "n",
    "<leader>tf",
    "<cmd>!tmux display-popup -h 75\\% -w 75\\% -E "
    .. '"tmux new-session -A '
    .. "-s $(tmux display-message "
    .. "-p '\\#{session_name}')-shell\" "
    .. "</dev/null >/dev/null 2>&1 & <CR>"
    .. "<CR>"
  )
  vim.keymap.set("n", "<leader>th", "<cmd>!tmux split-window<CR><CR>")
  vim.keymap.set("n", "<leader>tv", "<cmd>!tmux split-window -h<CR><CR>")
  vim.keymap.set(
    "n",
    "<C-A-x>",
    "yy:!tmux 'last-pane'"
    .. "| wl-paste"
    .. "| tmux load-buffer - ;"
    .. "tmux paste-buffer<CR><CR>"
  )

  vim.keymap.set(
    "v",
    "<C-A-x>",
    "y:!tmux 'last-pane'"
    .. "| wl-paste"
    .. "| tmux load-buffer - ;"
    .. "tmux paste-buffer<CR><CR>"
  )
else
  vim.keymap.set("n", "<C-A-x>", "yy<C-w><C-w><C-\\><C-n>pi<CR><C-\\><CR>")
  vim.keymap.set("v", "<C-A-x>", "y<C-w><C-w><C-\\><C-n>pi<CR><C-\\><CR>")
end

local palette = {
  _nc = "#16141f",
  base = "#191724",
  foam = "#9ccfd8",
  gold = "#f6c177",
  highlight_high = "#524f67",
  highlight_low = "#21202e",
  highlight_med = "#403d52",
  iris = "#c4a7e7",
  leaf = "#95b1ac",
  love = "#eb6f92",
  muted = "#6e6a86",
  none = "NONE",
  overlay = "#26233a",
  pine = "#31748f",
  rose = "#ebbcba",
  subtle = "#908caa",
  surface = "#1f1d2e",
  text = "#e0def4",
}

-- NOTE: Custom highlights need two versions to work with CommentString
local highlights = {
  ColorColumn = { bg = palette.surface },
  Comment = { fg = palette.subtle, italic = true },
  Function = { ctermfg = 14, fg = palette.rose },
  Normal = { fg = palette.text, bg = palette.none },
  Pmenu = { fg = palette.subtle, bg = palette.surface },
  PmenuExtra = { fg = palette.muted, bg = palette.surface },
  PmenuExtraSel = { fg = palette.subtle, bg = palette.overlay },
  PmenuKind = { fg = palette.foam, bg = palette.surface },
  PmenuKindSel = { fg = palette.subtle, bg = palette.overlay },
  PmenuSbar = { bg = palette.surface },
  PmenuSel = { fg = palette.text, bg = palette.overlay },
  PmenuThumb = { bg = palette.muted },
  StatusLine = { fg = palette.subtle, cterm = { bold, underline } },
  StatusLineNC = { fg = palette.subtle, cterm = { bold, underline } },
  String = { ctermfg = 10, fg = palette.gold },
  Visual = { bg = palette.highlight_med, blend = 15 },

  Fixme = { fg = palette.base, bg = palette.love, bold = true },
  FixmeText = { fg = palette.love },
  Hack = { fg = palette.base, bg = palette.warn, bold = true },
  HackText = { fg = palette.warn },
  Note = { fg = palette.base, bg = palette.pine, bold = true },
  NoteText = { fg = palette.pine },
  Todo = { fg = palette.base, bg = palette.rose, bold = true },
  TodoText = { fg = palette.rose },
}

for group, highlight in pairs(highlights) do
  vim.api.nvim_set_hl(0, group, highlight)
end

-- NOTE: TODO highlights.
CommentString = function(name)
  vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI', 'BufEnter' }, {
    group = vim.api.nvim_create_augroup(name, {}),
    callback = function(args)
      local lines = vim.api.nvim_buf_get_lines(args.buf, 0, -1, true)
      for n, l in ipairs(lines) do
        local j, k = string.find(l, string.upper(name) .. ":")
        if k then
          vim.api.nvim_buf_set_extmark(args.buf, 1, n - 1, j - 1, { end_col = k, hl_group = name })
          while string.find(lines[n], "\\" .. string.format(vim.opt.commentstring:get(), "")) do
            vim.api.nvim_buf_set_extmark(args.buf, 1, n - 1, 0,
              { end_col = string.len(lines[n]), hl_group = name .. "Text" })
            n = n + 1
          end
        end
      end
    end
  })
end

for _, name in ipairs({ "Fixme", "Hack", "Note", "Todo" }) do
  CommentString(name)
end

vim.api.nvim_create_autocmd('TermClose', {
  once = false,
  callback = function(args)
    local out = vim.api.nvim_buf_get_lines(0, 0, 1, 2)[1]
    if string.find(args.file, "fzf") then
      if string.find(out, ":") then
        out = string.sub(out, 1, string.find(out, ":") - 1)
      end
      vim.cmd.edit(out)
      -- NOTE: Force a refresh or we won't get syntax highlighting.
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":edit<CR>", true, false, true), "n", true)
    end
  end
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp', {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = false })
    end
  end
})

vim.lsp.enable({ "ark", "air", "clangd", "lua_ls", "nixd", "pylsp", "ruff" })
