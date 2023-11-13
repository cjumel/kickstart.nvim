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
      "<leader>dd",
      function()
        require("dapui").toggle()
      end,
      ft = "python",
      desc = "[D]ebug: toggle [D]ebug UI",
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
