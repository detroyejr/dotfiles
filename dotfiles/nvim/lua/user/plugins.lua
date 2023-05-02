local fn = vim.fn

-- Autolocal
lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Install your plugins here
local plugins = {
  { "folke/lazy.nvim" },       -- Have lazy manage itself
  { "christoomey/vim-tmux-navigator" },
  { "nvim-lua/plenary.nvim" }, -- Useful lua functions used in lots of plugins
  { "nvim-lua/popup.nvim" },   -- An implementation of the Popup API from vim in Neovim
  { 'echasnovski/mini.nvim', version = '*' },
  { "lukas-reineke/indent-blankline.nvim" },
  {
    "mickael-menu/zk-nvim",
    config = function()
      require("zk").setup({
        -- can be "telescope", "fzf" or "select" (`vim.ui.select`)
        -- it's recommended to use "telescope" or "fzf"
        picker = "telescope",
        lsp = {
          -- `config` is passed to `vim.lsp.start_client(config)`
          config = {
            cmd = { "zk", "lsp" },
            name = "zk",
            -- on_attach = ...
            -- etc, see `:h vim.lsp.start_client()`
          },
          -- automatically attach buffers in a zk notebook that match the given filetypes
          auto_attach = {
            enabled = true,
            filetypes = { "markdown", "pandoc", "md" },
          },
        },
      })
    end
  },

  -- UI
  { "folke/tokyonight.nvim" },
  { "EdenEast/nightfox.nvim" },
  { 'navarasu/onedark.nvim' },
  { "NLKNguyen/papercolor-theme" },
  { "rebelot/heirline.nvim" },
  { "goolord/alpha-nvim" },
  {
    "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    }
  },
  { "folke/which-key.nvim" },
  { "folke/zen-mode.nvim" },

  -- cmp plugins
  { "hrsh7th/cmp-buffer" },       -- buffer completions
  { "hrsh7th/cmp-cmdline" },      -- cmdline completions
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-nvim-lua" },
  { "hrsh7th/cmp-path" },         -- path completions
  { "hrsh7th/nvim-cmp" },         -- The completion plugin
  { "saadparwaiz1/cmp_luasnip" }, -- snippet completions
  { "windwp/nvim-autopairs" }, -- Autopairs, integrates with both cmp and treesitter

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
  { "nvim-treesitter/playground" },

  -- NeoTree
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    }
  },

  -- Gitsigns
  { "lewis6991/gitsigns.nvim" },

  -- Toggle Term
  { "akinsho/toggleterm.nvim",   version = "*" }

}
require("lazy").setup(plugins)
