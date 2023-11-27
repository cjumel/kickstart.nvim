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
    },
    {
      "<leader>dc",
      function()
        require("dap").continue()
      end,
      desc = "[D]ebug: [C]ontinue",
    },
    {
      "<leader>dl",
      function()
        require("dap").run_last()
      end,
      desc = "[D]ebug: run [L]ast",
    },
    {
      "<leader>dt",
      function()
        require("dap").terminate()
      end,
      desc = "[D]ebug: [T]erminate",
    },
    {
      "<leader>dh",
      function()
        require("dap.ui.widgets").hover()
      end,
      desc = "[D]ebug: [H]over",
    },
  },
}
