-- nvim-dap
--
-- Neovim implemetation of the Debug Adapter Protocol (DAP).

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
  },
  keys = {
    {
      "<leader>db",
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "[D]ebug: [B]reakpoint",
      ft = "*",
    },
    {
      "<leader>dc",
      function()
        require("dap").continue()
      end,
      desc = "[D]ebug: [C]ontinue",
      ft = "*",
    },
    {
      "<leader>dl",
      function()
        require("dap").run_last()
      end,
      desc = "[D]ebug: run [L]ast",
      ft = "*",
    },
    {
      "<leader>dt",
      function()
        require("dap").terminate()
      end,
      desc = "[D]ebug: [T]erminate",
      ft = "*",
    },
    {
      "<leader>dK",
      function()
        require("dap.ui.widgets").hover()
      end,
      desc = "[D]ebug: Hover",
      ft = "*",
    },
  },
}
