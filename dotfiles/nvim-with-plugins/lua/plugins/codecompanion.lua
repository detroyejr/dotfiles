return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    return require("codecompanion").setup({
      adapters = {
        ollama = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            env = {
              url = "http://odp-1.lan:11434",
            },
            parameters = {
              sync = true,
            },
          })
        end,
      },
      display = {
        diff = {
          provider = "mini_diff",
        },
      },
      strategies = {
        chat = {
          adapter = "ollama",
        },
        inline = {
          adapter = "ollama",
        },
      },
    })
  end,
  keys = {
    { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", silent = true },
    { "<leader>ap", "<cmd>CodeCompanion<cr>",            silent = true },
  },
}
