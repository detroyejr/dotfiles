local opts = { noremap = false, silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- avoid freezing the vim process forever, see
-- https://github.com/neovim/neovim/issues/6660
if vim.fn.has("win32") == 1 then
  keymap("n", "<C-z>", "<Nop>", opts)
end

-- Normal --
-- Transparency
keymap("n", "<A-t>", ":<C-U>TransparentToggle<cr>", { noremap = true, silent = true })

-- TMUX window naviation
vim.g.tmux_navigator_no_mappingsj = 1

keymap("n", "<C-h>", ":<C-U>TmuxNavigateLeft<cr>", { noremap = true, silent = true })
keymap("n", "<C-j>", ":<C-U>TmuxNavigateDown<cr>", { noremap = true, silent = true })
keymap("n", "<C-k>", ":<C-U>TmuxNavigateUp<cr>", { noremap = true, silent = true })
keymap("n", "<C-l>", ":<C-U>TmuxNavigateRight<cr>", { noremap = true, silent = true })
-- keymap("n", "{Previous-Mapping}", ":<C-U>TmuxNavigatePrevious<cr>", { noremap = true, silent = true })

-- keymap("n", "<leader>e", ":Lex 30<cr>", opts)
keymap("n", "<leader>e", ":Sex 30<cr>", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Move text up and down
keymap("n", "<A-j>", "<Esc>:m .+1<CR>==", opts)
keymap("n", "<A-k>", "<Esc>:m .-2<CR>==", opts)

-- Insert --
-- Press jk fast to enter
keymap("i", "jj", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Terminal --
local tmux = os.getenv("TMUX")
local wsl = os.getenv("WSL_DISTRO_NAME")

if tmux and wsl then
  keymap(
    "n",
    "<C-A-x>",
    "yy:!tmux if-shell 'test \\#{window_panes} -gt 1' 'last-pane' 'last-window'"
    .. "| win32yank.exe -o"
    .. "| tmux load-buffer - ;"
    .. "tmux paste-buffer<CR>"
    .. ":NoiceDismiss<CR>",
    opts
  )

  keymap(
    "v",
    "<C-A-x>",
    "y:!tmux if-shell 'test \\#{window_panes} -gt 1' 'last-pane' 'last-window'"
    .. "| win32yank.exe -o"
    .. "| tmux load-buffer - ;"
    .. "tmux paste-buffer<CR>"
    .. ":NoiceDismiss<CR>",
    opts
  )
elseif tmux then
  keymap(
    "n",
    "<C-A-x>",
    "yy:!tmux if-shell 'test \\#{window_panes} -gt 1' 'last-pane' 'last-window'"
    .. "| wl-paste"
    .. "| tmux load-buffer - ;"
    .. "tmux paste-buffer<CR>"
    .. ":NoiceDismiss<CR>",
    opts
  )

  keymap(
    "v",
    "<C-A-x>",
    "y:!tmux if-shell 'test \\#{window_panes} -gt 1' 'last-pane' 'last-window'"
    .. "| wl-paste"
    .. "| tmux load-buffer - ;"
    .. "tmux paste-buffer<CR>"
    .. ":NoiceDismiss<CR>",
    opts
  )
else
  keymap("n", "<C-A-x>", ":ToggleTermSendCurrentLine<CR>", opts)
  keymap("v", "<C-A-x>", ":ToggleTermSendVisualSelection<CR>", opts)
end

-- Explore
keymap("n", "<leader>e", ":Sexplore<CR>", opts)

-- Zenmode
keymap("n", "<C-z>", ":ZenMode<cr>", opts)
