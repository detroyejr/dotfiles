return {
  "folke/snacks.nvim",
  opts = {
    explorer = {
      replace_netrw = true
    },
    picker = {
      sources = {
        explorer = { enabled = true },
      },
    },
    image = {},
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
      desc = "Picker Snacks",
    },
    {
      "<space>fF",
      function()
        Snacks.picker.grep()
      end,
      desc = "Picker Snacks",
    },
    {
      "<space>fh",
      function()
        Snacks.picker.help()
      end,
      desc = "Picker Snacks",
    },
  },
}
