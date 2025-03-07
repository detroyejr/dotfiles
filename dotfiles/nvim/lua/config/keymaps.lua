-- Keymaps

vim.keymap.set('i', 'jj', '<Esc>', { nowait = true })

-- vim.keymap.set("n", '<leader>e', ':Explore<cr>', { silent = true })
vim.keymap.set("n", '<leader>h', ':noh<cr>')

-- Navigate buffers
vim.keymap.set("n", "<S-h>", ":bprevious<cr>", { silent = true })
vim.keymap.set("n", "<S-l>", ":bnext<cr>", { silent = true })
vim.keymap.set("n", "<leader>c", ":bdelete<cr>", { silent = true })

-- Terminal
local tmux = os.getenv("TMUX")
local wsl = os.getenv("WSL_DISTRO_NAME")

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
else
	vim.keymap.set("n", "<leader>tf", "<cmd>terminal<cr>")
	vim.keymap.set("n", "<leader>th", "<cmd>new term://${SHELL}<cr>")
	vim.keymap.set("n", "<leader>tv", "<cmd>vnew term://${SHELL}<cr>")
end
-- Sending keys to terminal

if tmux and wsl then
	vim.keymap.set(
		"n",
		"<C-A-x>",
		"yy:!tmux if-shell 'test \\#{window_panes} -gt 1' 'last-pane' 'last-window'"
		.. "| win32yank.exe -o"
		.. "| tmux load-buffer - ;"
		.. "tmux paste-buffer<CR>"
	)

	vim.keymap.set(
		"v",
		"<C-A-x>",
		"y:!tmux if-shell 'test \\#{window_panes} -gt 1' 'last-pane' 'last-window'"
		.. "| win32yank.exe -o"
		.. "| tmux load-buffer - ;"
		.. "tmux paste-buffer<CR><CR>"
	)
elseif tmux then
	vim.keymap.set(
		"n",
		"<C-A-x>",
		"yy:!tmux if-shell 'test \\#{window_panes} -gt 1' 'last-pane' 'last-window'"
		.. "| wl-paste"
		.. "| tmux load-buffer - ;"
		.. "tmux paste-buffer<CR><CR>"
	)

	vim.keymap.set(
		"v",
		"<C-A-x>",
		"y:!tmux if-shell 'test \\#{window_panes} -gt 1' 'last-pane' 'last-window'"
		.. "| wl-paste"
		.. "| tmux load-buffer - ;"
		.. "tmux paste-buffer<CR><CR>"
	)
else
	vim.keymap.set("n", "<C-A-x>", "Vy<C-w>wpa<CR><C-\\><C-n><C-w>pj")
	vim.keymap.set("v", "<C-A-x>", "y<C-w>wpa<CR><C-\\><C-n><C-w>p")
end

-- avoid freezing the vim process forever when on windows, see
-- https://github.com/neovim/neovim/issues/6660
if vim.fn.has("win32") == 1 then
	vim.keymap.set("n", "<C-z>", "<Nop>")
end
