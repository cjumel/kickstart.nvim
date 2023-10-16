-- stand.nvim
--
-- Time to stand reminders.

return {
  "mvllow/stand.nvim",
  dependencies = {
    "rcarriga/nvim-notify",
  },
  cmd = {
    "StandNow",
    "StandWhen",
    "StandEvery",
    "StandDisable",
    "StandEnable",
  },
  keys = {
    {
      "<leader>sn",
      function()
        vim.cmd("StandNow")
      end,
      desc = "[S]tand [N]ow",
    },
    {
      "<leader>sw",
      function()
        vim.cmd("StandWhen")
      end,
      desc = "[S]tand [W]hen",
    },
    {
      "<leader>sd",
      function()
        vim.cmd("StandDisable")
      end,
      desc = "[S]tand [D]isable",
    },
  },
  opts = {
    minute_interval = 50,
  },
}
