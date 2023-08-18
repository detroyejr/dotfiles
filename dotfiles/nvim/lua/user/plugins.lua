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
  { "folke/lazy.nvim" }, -- Have lazy manage itself
  { "christoomey/vim-tmux-navigator" },
  { "lukas-reineke/indent-blankline.nvim" },

  -- Utilities
  {
    "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    }
  },
  { "famiu/bufdelete.nvim" },
  { "folke/which-key.nvim" },
  { "nvim-lua/plenary.nvim" }, -- Useful lua functions used in lots of plugins
  { "nvim-lua/popup.nvim" },   -- An implementation of the Popup API from vim in Neovim
  { 'echasnovski/mini.nvim',     version = '*' },

  -- UI
  { "EdenEast/nightfox.nvim" },
  { "folke/tokyonight.nvim" },
  { "xiyaowong/transparent.nvim" },

  -- cmp plugins
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-cmdline" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-nvim-lua" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/nvim-cmp" },

  -- Snippets
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
  },
  { "rafamadriz/friendly-snippets" },
  { "saadparwaiz1/cmp_luasnip" },

  -- LSP
  { "jose-elias-alvarez/null-ls.nvim" },
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason-lspconfig.nvim" },
  { "williamboman/mason.nvim" },

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
  { "akinsho/toggleterm.nvim", version = "*" },

  -- Quarto
  { "jmbuhr/otter.nvim" },
  { "quarto-dev/quarto-nvim" },

}
require("lazy").setup(plugins)
