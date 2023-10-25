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
      "<leader>dr",
      function()
        require("dap").run_last()
      end,
      ft = "python",
      desc = "[D]ebug: [R]erun",
    },
    {
      "<leader>dt",
      function()
        require("dapui").toggle()
      end,
      ft = "python",
      desc = "[D]ebug: [T]oggle UI",
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
