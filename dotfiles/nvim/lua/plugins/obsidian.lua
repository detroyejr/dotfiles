return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  lazy = false,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    ui = {
      enable = false
    },
    legacy_commands = false,
    workspaces = {
      {
        name = "Personal",
        path = "~/Personal",
      },
    },
    picker = {
      name = "snacks.pick",
    },
  },
  keys = {
    { "<leader>bs", "<CMD>Obsidian quick_switch<CR>", desc = "Obsidian Quick Switch", },
    { "<leader>bS", "<CMD>Obsidian search<CR>",       desc = "Obsidian Search Notes", },
    { "<leader>bt", "<CMD>Obsidian today<CR>",        desc = "Obsidian Today", },
    { "<leader>by", "<CMD>Obsidian yesterday<CR>",    desc = "Obsidian Yesterday", },
  }
}
