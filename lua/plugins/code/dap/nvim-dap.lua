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
      ft = "python",
      desc = "[D]ebug: [B]reakpoint",
    },
    {
      "<leader>dc",
      function()
        require("dap").continue()
      end,
      ft = "python",
      desc = "[D]ebug: [C]ontinue",
    },
    {
      "<leader>dl",
      function()
        require("dap").run_last()
      end,
      ft = "python",
      desc = "[D]ebug: rerun [L]ast",
    },
    {
      "<leader>dh",
      function()
        require("dap.ui.widgets").hover()
      end,
      ft = "python",
      desc = "[D]ebug: [H]over",
    },
  },
}
