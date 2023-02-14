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
  { "folke/lazy.nvim" }, -- Have lazy manage itself

  { "nvim-lua/popup.nvim" }, -- An implementation of the Popup API from vim in Neovim
  { "nvim-lua/plenary.nvim" }, -- Useful lua functions used in lots of plugins
  { "lewis6991/impatient.nvim" },
  { "lukas-reineke/indent-blankline.nvim" },
  { "mickael-menu/zk-nvim",
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
  { "NLKNguyen/papercolor-theme" },
  { "akinsho/bufferline.nvim" },
  { "moll/vim-bbye" },
  { "goolord/alpha-nvim" },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "kyazdani42/nvim-web-devicons", opt = true }
  },
  { "folke/which-key.nvim" },
  { "folke/zen-mode.nvim" },
  
  -- cmp plugins
  { "hrsh7th/nvim-cmp" }, -- The completion plugin
  { "hrsh7th/cmp-buffer" }, -- buffer completions
  { "hrsh7th/cmp-path" }, -- path completions
  { "hrsh7th/cmp-cmdline" }, -- cmdline completions
  { "saadparwaiz1/cmp_luasnip" }, -- snippet completions
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-nvim-lua" },
  { "windwp/nvim-autopairs" }, -- Autopairs, integrates with both cmp and treesitter
  { "numToStr/Comment.nvim" }, -- Easily comment stuff.

  -- snippets
  { "L3MON4D3/LuaSnip" }, --snippet engine
  { "rafamadriz/friendly-snippets" }, -- a bunch of snippets to use

	-- LSP
  { "neovim/nvim-lspconfig" }, -- enable LSP
  { "williamboman/mason.nvim" }, -- simple to use language server installer
  { "williamboman/mason-lspconfig.nvim" }, -- simple to use language server installer
  { "jose-elias-alvarez/null-ls.nvim" }, -- LSP diagnostics and code actions
  
  -- Telescope
  { "nvim-telescope/telescope.nvim" },
  { "nvim-telescope/telescope-media-files.nvim" },
  
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
  },
  { "nvim-treesitter/playground" },
  { "JoosepAlviste/nvim-ts-context-commentstring" },

  -- NeoTree
  {
  "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    requires = { 
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    }
  },
   
  -- Gitsigns
  { "lewis6991/gitsigns.nvim" },

  -- Toggle Term
  { "akinsho/toggleterm.nvim", version = "*" }

}
require("lazy").setup(plugins)

