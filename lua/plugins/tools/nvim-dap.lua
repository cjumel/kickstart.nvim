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
      desc = "[D]AP: [B]reakpoint",
    },
    {
      "<leader>dc",
      function()
        require("dap").continue()
      end,
      desc = "[D]AP: [C]ontinue",
    },
    {
      "<leader>dl",
      function()
        require("dap").run_last()
      end,
      desc = "[D]AP: run [L]ast",
    },
    {
      "<leader>dt",
      function()
        require("dap").terminate()
      end,
      desc = "[D]AP: [T]erminate",
    },
    {
      "<leader>dK",
      function()
        require("dap.ui.widgets").hover()
      end,
      desc = "[D]AP: Hover",
    },
  },
}
