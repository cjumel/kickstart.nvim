-- nvim-dap
--
-- Neovim implemetation of the Debug Adapter Protocol (DAP).

return {
  "mfussenegger/nvim-dap",
  keys = {
    {
      "<leader>dr",
      function()
        require("dap").run_last()
      end,
      ft = "python",
      desc = "[D]ebug: [R]erun",
    },
    {
      "<leader>db",
      function()
        require("dap").toggle_breakpoint()
      end,
      ft = "python",
      desc = "[D]ebug: [B]reakpoint",
    },

    -- Debugging setup
    {
      "<leader>dc",
      function()
        require("dap").continue()
      end,
      ft = "python",
      desc = "[D]ebug: [C]ontinue",
    },

    -- State inspection
    {
      "<leader>dK",
      function()
        require("dap.ui.widgets").hover()
      end,
      ft = "python",
      desc = "[D]ebug: [K] hover",
    },
    {
      "<leader>do",
      function()
        require("dap").repl.open()
      end,
      ft = "python",
      desc = "[D]ebug: [O]pen console",
    },
  },
}
