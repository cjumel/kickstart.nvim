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
        print("Stand timer restarting")
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
  },
  opts = {
    minute_interval = 25, -- pomodoro-style default
  },
}
