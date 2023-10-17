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
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup()

    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end
  end,
}
