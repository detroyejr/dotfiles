-- Minimal Lua Config

vim.g.netrw_altv = 1
vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_preview = 1
vim.g.netrw_winsize = 30

vim.opt.autoread = true
vim.opt.backup = false
vim.opt.clipboard = "unnamedplus"
vim.opt.colorcolumn = "89"
vim.opt.completeopt = { "menu", "menuone", "popup", "fuzzy", "noinsert" }
vim.opt.expandtab = true
vim.opt.fileformat = "unix"
vim.opt.fixendofline = true
vim.opt.path = ",,**"
vim.opt.pumheight = 10
vim.opt.relativenumber = true
vim.opt.scrolloff = 10
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

-- Buffers
local makeprg_input = function()
  vim.ui.input({ prompt = "Build command: ", }, function(input)
    vim.cmd("set makeprg=" .. input)
    vim.cmd("make")
  end)
end

vim.keymap.set("n", "<Leader>b", ":buffers<CR>", opts)
vim.keymap.set("n", "<Leader>bl", function() makeprg_input() end, opts)

-- Netrw
vim.keymap.set("n", "<Leader>E", ":Explore<CR>", opts)
vim.keymap.set("n", "<Leader>e", ":Lexplore<CR>", opts)

-- Lsp
vim.keymap.set("n", "<Leader>ld", ":lua vim.diagnostic.setqflist()<CR>", opts)
vim.keymap.set("n", "<Leader>lf", ":lua vim.lsp.buf.format()<CR>", opts)
vim.keymap.set("n", "<Leader>li", ":checkhealth lsp<CR>", opts)
vim.keymap.set("n", '<leader>lh',
  function()
    local bufnr = vim.api.nvim_get_current_buf()
    local filter = { bufnr = bufnr }
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(filter), filter)
  end
)

-- Terminal
vim.keymap.set("n", "<Leader>th", ":botright terminal<CR>", opts)
vim.keymap.set("n", "<Leader>tv", ":vertical terminal<CR>", opts)

-- Fzf
vim.keymap.set("n", "<Leader>fq", ":terminal fzf<CR>i", opts)
vim.keymap.set("n", "<Leader>ff", ":find ")
vim.keymap.set("n", "<Leader>fF",
  ":terminal fzf --disabled --ansi " ..
  "--bind \"start:reload:rg --column --color=always --smart-case {q}\" " ..
  "--bind \"change:reload:rg --column --color=always --smart-case {q}\" " ..
  "--delimiter : " ..
  "--preview 'bat --style=full --color=always --highlight-line {2} {1}' " ..
  "--preview-window '~4,+{2}+4/3,<80(up)'<CR>i", opts)



-- Git
vim.keymap.set("n", "<Leader>gA", ":terminal git add -A<CR>iq")
vim.keymap.set("n", "<Leader>gaa", ":terminal git add '%'<CR>i")
vim.keymap.set("n", "<Leader>gai", ":terminal git ai<CR>i")
vim.keymap.set("n", "<Leader>gc", ":terminal git commit<CR>i")
vim.keymap.set("n", "<Leader>gs", ":terminal git status<CR>i")
vim.keymap.set("n", "<Leader>gd", ":terminal git diff<CR>i")
vim.keymap.set("n", "<Leader>gD", ":terminal git difftool --tool nvimdiff -y<CR>i")
vim.keymap.set("n", "<C-A-x>", "yy<C-w>p<C-\\><C-n>pi<CR><C-\\><CR>")
vim.keymap.set("v", "<C-A-x>", "y<C-w>p<C-\\><C-n>pi<CR><C-\\><CR>")

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

-- NOTE: A poor man's TODO highlights.
CommentString = function(name)
  vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI', 'BufEnter' }, {
    group = vim.api.nvim_create_augroup(name, {}),
    callback = function(args)
      if vim.bo[args.buf].buftype == "terminal" then return end
      local comment
      local lines
      local prefix

      lines = vim.api.nvim_buf_get_lines(args.buf, 0, -1, true)
      comment = string.gsub(string.format(vim.opt.commentstring:get(), ""), " ", "")
      if comment == "--" then prefix = "\\" else prefix = "" end

      for n, l in ipairs(lines) do
        local j, k = string.find(l, string.upper(name) .. ":")
        if k then
          vim.api.nvim_buf_set_extmark(args.buf, 1, n - 1, j - 1, { end_col = k, hl_group = name })
          while lines[n] and string.find(lines[n], prefix .. comment) do
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

local group = vim.api.nvim_create_augroup("autocmdgroup", { clear = true })

vim.api.nvim_create_autocmd('TermClose', {
  group = group,
  once = false,
  callback = function(args)
    local out = vim.api.nvim_buf_get_lines(0, 0, 1, 2)[1]
    if string.find(args.file, "fzf") then
      if string.find(out, ":") then
        out = string.sub(out, 1, string.find(out, ":") - 1)
      end
      vim.cmd.edit(out)
      -- NOTE: Force a refresh or we won't get syntax highlighting. There's probably an autocmd
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":edit<CR>", true, false, true), "n", true)
    end
    -- Suppress "Process exit 0" message
    vim.api.nvim_input("<CR>")
  end

})


vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp', {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end
    if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion, bufnr) then
      vim.lsp.inline_completion.enable(true, { bufnr = bufnr })

      vim.keymap.set(
        'i',
        '<C-F>',
        vim.lsp.inline_completion.get,
        { desc = 'LSP: accept inline completion', buffer = bufnr }
      )
      vim.keymap.set(
        'i',
        '<C-G>',
        vim.lsp.inline_completion.select,
        { desc = 'LSP: switch inline completion', buffer = bufnr }
      )
    end
  end
})

vim.lsp.enable({
  "air",
  "ark",
  "clangd",
  "jarl",
  "lua_ls",
  "nixd",
  "pylsp",
  "ruff",
  "rust_analyzer",
  "snippets_lsp",
})


vim.lsp.inlay_hint.enable()

vim.diagnostic.config({ virtual_text = true })


-- Plugins
require 'nvim-treesitter'.install({
  "c", "csv", "cpp", "nix", "python", "r", "rust", "javascript", "json", "lua", "vim",
  "vimdoc", "query", "markdown", "markdown_inline"
}):wait(300000)


local makeprg_map = {
  py = "python3 %",
  python = "python3 %",
  quarto = "quarto render %",
  r = "Rscript --no-restore %",
}

-- function to set makeprg
local function set_makeprg()
  local cmd = makeprg_map[vim.bo.filetype]
  vim.o.makeprg = cmd or ""
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = set_makeprg,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'c', 'h', 'cpp', 'nix', 'py', 'r', 'rs', 'js', 'json', 'lua', 'vim', 'md' },
  callback = function()
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    vim.treesitter.start()
    set_makeprg()
  end,
})


-- Setup for opencode
require("snacks").setup({
  styles = { enabled = true },
  input = { enabled = true },
  picker = { enabled = true },
  bigfile = { enabled = true },
  terminal = { enabled = true },
})

vim.g.opencode_opts = {
  provider = {
    enabled = "terminal",
  }
}

vim.keymap.set('i', '<Tab>', function()
  if not vim.lsp.inline_completion.get() then
    return '<Tab>'
  end
end, { expr = true, desc = 'Accept the current inline completion' })


vim.keymap.set(
  "n",
  "<Leader>aa",
  function() require("opencode").toggle() end,
  opts
)

vim.keymap.set(
  { "x", "n" },
  "<leader>at",
  function() require("opencode").ask("@this: ", { submit = true }) end,
  opts
)

vim.keymap.set(
  { "x", "n" },
  "<leader>ac",
  function() require("opencode").ask("", { submit = true }) end,
  opts
)

vim.keymap.set(
  { "x", "n" },
  "<leader>ap",
  function() require("opencode").select() end,
  opts
)
