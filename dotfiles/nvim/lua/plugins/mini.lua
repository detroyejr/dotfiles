return {
  'echasnovski/mini.nvim',
  lazy = false,
  version = false,
  config = function()
    require('mini.bufremove').setup()
    require('mini.comment').setup()
    require('mini.diff').setup()
    require('mini.git').setup()
    require('mini.icons').setup()
    require('mini.statusline').setup()
  end,
  keys = {
    { "<leader>dt", "<cmd>lua MiniDiff.toggle_overlay()<CR>", silent = true },
  }
}
