-- stand.nvim
--
-- Time to stand reminders.

return {
  "mvllow/stand.nvim",
  dependencies = {
    "rcarriga/nvim-notify",
  },
  keys = {
    {
      "<leader>sn",
      function()
        print("Stand timer restarting")
        vim.cmd("StandNow")
      end,
      desc = "[S]tand: [N]ow",
    },
    {
      "<leader>sw",
      function()
        vim.cmd("StandWhen")
      end,
      desc = "[S]tand: [W]hen",
    },
    {
      "<leader>sd",
      function()
        vim.cmd("StandDisable")
      end,
      desc = "[S]tand: [D]isable",
    },
    {
      "<leader>se",
      function()
        vim.cmd("StandEnable")
      end,
      desc = "[S]tand: [E]nable",
    },
  },
  opts = {
    minute_interval = 25, -- pomodoro-style default
  },
}
