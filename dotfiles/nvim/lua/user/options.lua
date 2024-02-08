-- Location of the spellfile.
if vim.fn.has("win32") ~= 1 then
  -- Set colorscheme for linux.
  require("user.colorscheme")

  SpellFile = "/.config/dotfiles/dotfiles/nvim/spell/en.utf-8.add"
  if not os.rename(SpellFile, SpellFile) then
    SpellFile = vim.opt.spellfile
  end
end

-- :help options
local options = {
  backup = false,
  clipboard = "unnamedplus",
  cmdheight = 0,
  colorcolumn = "88",
  completeopt = { "menuone", "noselect" },
  conceallevel = 0,
  cursorline = false,
  expandtab = true,
  fileencoding = "utf-8",
  fileformat = "unix",
  guifont = "monospace:h17",
  hlsearch = true,
  ignorecase = true,
  linebreak = true,
  mouse = "a",
  number = true,
  numberwidth = 4,
  pumheight = 10,
  relativenumber = true,
  scrolloff = 8,
  shiftwidth = 2,
  showmode = false,
  showtabline = 2,
  sidescrolloff = 8,
  signcolumn = "yes",
  smartcase = true,
  smartindent = true,
  spell = true,
  spellfile = SpellFile,
  spelllang = "en_us",
  splitbelow = true,
  splitright = true,
  swapfile = false,
  tabstop = 2,
  termguicolors = true,
  timeoutlen = 200,
  undofile = true,
  updatetime = 50,
  wrap = false,
  writebackup = false,
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.opt.shortmess:append("c")

-- NetRW Options
vim.g.netrw_altv = 1
vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 4
vim.g.netrw_liststyle = 3
vim.g.netrw_preview = 1
vim.g.netrw_winsize = 30

vim.cmd([[
  colorscheme nightfox

  " generic
  autocmd filetype r set colorcolumn=80
  autocmd filetype markdown set wrap
  autocmd VimLeave * set guicursor=a:ver20

  " terminal
  " autocmd BufWinEnter,WinEnter term://* startinsert

  set iskeyword+=-
  set path+=**
  set whichwrap+=<,>,[,],h,l
  set wildmenu

  " netrw
  augroup netrw_mapping
    autocmd!
    autocmd filetype netrw call NetrwMapping()
  augroup END

  function! NetrwMapping()
    nnoremap <silent> <buffer> <c-l> :TmuxNavigateRight<CR>
  endfunction
]])
