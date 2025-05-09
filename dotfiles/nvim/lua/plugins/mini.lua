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
    -- Diff
    { "<leader>dt", "<cmd>lua MiniDiff.toggle_overlay()<CR>", silent = true },

    -- Git
    { "<leader>gs", "<cmd>lua MiniGit.show_at_cursor()<CR>", silent = true },
  }
}
