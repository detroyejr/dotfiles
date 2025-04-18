-- Options

COLORSCHEME = "default"
if vim.fn.has("win32") ~= 1 then
	-- Set colorscheme for linux.
	pcall(require, "config.colorscheme")
	pcall(vim.cmd, "colorscheme " .. COLORSCHEME)

  -- Needed for Transparency in wezterm.
  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })

	SpellFile = "/.config/dotfiles/dotfiles/nvim/spell/en.utf-8.add"
	if not os.rename(SpellFile, SpellFile) then
		SpellFile = vim.opt.spellfile
	end
end

vim.g.tmux_navigator_no_mappings = 1

-- NetRW Options
vim.g.netrw_altv = 1
vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_preview = 1
vim.g.netrw_winsize = 30

local options = {
	autoindent = true,
	backup = false,
	clipboard = "unnamedplus",
	colorcolumn = "88",
	expandtab = true,
	fileencoding = "utf-8",
	fileformat = "unix",
	ignorecase = true,
	relativenumber = true,
	shiftwidth = 2,
	sidescrolloff = 8,
	signcolumn = "yes",
	splitbelow = true,
	splitright = true,
	tabstop = 2,
	wrap = false,
  swapfile = false,
  termguicolors = true,
  timeoutlen = 500,
  undofile = true,
  updatetime = 50,
  writebackup = false,
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

vim.cmd([[
  autocmd filetype r set colorcolumn=80
  autocmd filetype py set colorcolumn=88
  autocmd filetype markdown set wrap
]])
