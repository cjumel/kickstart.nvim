-- nvim-dap-ui
--
-- A UI for nvim-dap which provides a good out of the box configuration.

return {
  "rcarriga/nvim-dap-ui",
  dependencies = {
    "mfussenegger/nvim-dap",
  },
  keys = {
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
  end,
}
