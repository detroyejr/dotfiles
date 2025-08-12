return {
  "folke/snacks.nvim",
  lazy = false,
  opts = {
    animate = { enabled = true },
    explorer = {
      enabled = true,
      replace_netrw = true
    },
    image = { enabled = true },
    indent = { enabled = true },
    picker = {
      sources = {
        explorer = { enabled = true },
      },
    },
    terminal = { enabled = true },
    toggle = { enable = true },
    -- dashboard = { enabled = true },
  },
  keys = {
    {
      "<space>e",
      function()
        Snacks.explorer.open()
      end,
      desc = "Explorer Snacks",
    },
    {
      "<space>fp",
      function()
        Snacks.picker()
      end,
      desc = "Picker Snacks",
    },
    {
      "<space>ff",
      function()
        Snacks.picker.files()
      end,
      desc = "Files",
    },
    {
      "<space>fw",
      function()
        Snacks.picker.grep_word()
      end,
      desc = "Words",
    },
    {
      "<space>fF",
      function()
        Snacks.picker.grep()
      end,
      desc = "Grep",
    },
    {
      "<space>fh",
      function()
        Snacks.picker.help()
      end,
      desc = "Picker Snacks",
    },
    {
      "<space>.",
      function()
        Snacks.scratch()
      end,
      desc = "Scratch buffer",
    },
    {
      "<space>S",
      function()
        Snacks.scratch()
      end,
      desc = "Select Scratch Buffer",
    },
    {
      "<leader>uC",
      function()
        Snacks.picker.colorschemes()
      end,
      desc = "Colorschemes",
    },
    {
      "<leader>ug",
      function()
        Snacks.toggle.indent()
      end,
      desc = "Toggle indent",
    },
  },

}
