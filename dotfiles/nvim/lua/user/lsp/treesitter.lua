require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "css",
    "go",
    "html",
    "javascript",
    "lua",
    "markdown",
    "nix",
    "python",
    "r",
    "rust",
    "vim",
  },
  sync_install = false,
  ignore_install = { "" }, -- List of parsers to ignore installing
  highlight = {
    enable = true,        -- false will disable the whole extension
    disable = { "" },     -- list of language that will be disabled
    additional_vim_regex_highlighting = true,
  },
  indent = { enable = true, disable = { "yaml" } },
  context_commentstring = {
    enable = true,
  },
})
