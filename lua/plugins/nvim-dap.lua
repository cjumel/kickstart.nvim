-- nvim-dap
--
-- Neovim implemetation of the Debug Adapter Protocol (DAP).

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "mfussenegger/nvim-dap-python",
  },
  lazy = true,
  keys = {
    {
      "<leader>dr",
      function()
        require("dap").run_last()
      end,
      desc = "[D]ebug: [R]erun",
    },
    {
      "<leader>db",
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "[D]ebug: [B]reakpoint",
    },

    -- Debugging setup
    {
      "<leader>dc",
      function()
        require("dap").continue()
      end,
      desc = "[D]ebug: [C]ontinue",
    },

    -- State inspection
    {
      "<leader>dK",
      function()
        require("dap.ui.widgets").hover()
      end,
      desc = "[D]ebug: [K] hover",
    },
    {
      "<leader>do",
      function()
        require("dap").repl.open()
      end,
      desc = "[D]ebug: [O]pen console",
    },
  },
}
