-- Autolocal
Lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(Lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    Lazypath,
  })
end
vim.opt.rtp:prepend(Lazypath)

-- Install your plugins here
local plugins = {
  { "folke/lazy.nvim" },       -- Have lazy manage itself
  { "christoomey/vim-tmux-navigator" },
  { "nvim-lua/plenary.nvim" }, -- Useful lua functions used in lots of plugins
  { "nvim-lua/popup.nvim" },   -- An implementation of the Popup API from vim in Neovim
  { 'echasnovski/mini.nvim',              version = '*' },
  { "lukas-reineke/indent-blankline.nvim" },
  { "jmbuhr/otter.nvim" },
  { "quarto-dev/quarto-nvim" },

  -- UI
  { "folke/tokyonight.nvim" },
  { "EdenEast/nightfox.nvim" },
  { "goolord/alpha-nvim" },
  { "xiyaowong/transparent.nvim" },
  {
    "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    }
  },
  { "folke/which-key.nvim" },
  { "famiu/bufdelete.nvim" },

  -- cmp plugins
  { "hrsh7th/cmp-buffer" },  -- buffer completions
  { "hrsh7th/cmp-cmdline" }, -- cmdline completions
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-nvim-lua" },
  { "hrsh7th/cmp-path" },         -- path completions
  { "hrsh7th/nvim-cmp" },         -- The completion plugin
  { "saadparwaiz1/cmp_luasnip" }, -- snippet completions

  -- snippets
  { "L3MON4D3/LuaSnip" },             --snippet engine
  { "rafamadriz/friendly-snippets" }, -- a bunch of snippets to use

  -- LSP
  { "jose-elias-alvarez/null-ls.nvim" },   -- LSP diagnostics and code actions
  { "neovim/nvim-lspconfig" },             -- enable LSP
  { "williamboman/mason-lspconfig.nvim" }, -- simple to use language server installer
  { "williamboman/mason.nvim" },           -- simple to use language server installer

  -- Telescope
  { "nvim-telescope/telescope.nvim" },
  { "nvim-telescope/telescope-media-files.nvim" },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
  },

  -- Gitsigns
  { "lewis6991/gitsigns.nvim" },

  -- Toggle Term
  { "akinsho/toggleterm.nvim",   version = "*" }

}
require("lazy").setup(plugins)
