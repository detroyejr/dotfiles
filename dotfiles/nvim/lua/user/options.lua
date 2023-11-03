-- Toggleterm specific settings for powershell.

if vim.fn.has("win32") == 1 then
	local powershell_options = {
		shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell",
		shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
		shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
		shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
		shellquote = "",
		shellxquote = "",
	}

	for option, value in pairs(powershell_options) do
		vim.opt[option] = value
	end
end

-- :help options
local options = {
	backup = false,
	clipboard = "unnamedplus", -- Use the system clipboard.
	cmdheight = 0,
	colorcolumn = "88",
	completeopt = { "menuone", "noselect" },
	conceallevel = 0,
	cursorline = false,
	expandtab = true, -- tabs to spaces.
	fileencoding = "utf-8",
	fileformat = "unix",
	guifont = "monospace:h17",
	hlsearch = true,
	ignorecase = true,
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
vim.g.netrw_banner = 0
vim.g.netrw_altv = 1
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 4
vim.g.netrw_winsize = 20

vim.cmd([[
  " generic
  autocmd filetype r set colorcolumn=80
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
