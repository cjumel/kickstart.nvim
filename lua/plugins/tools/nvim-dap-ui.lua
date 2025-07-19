-- nvim-dap-ui
--
-- A UI for nvim-dap which provides a good out of the box configuration.

return {
  "rcarriga/nvim-dap-ui",
  dependencies = {
    "mfussenegger/nvim-dap",
    "mfussenegger/nvim-dap-python",
    "rcarriga/cmp-dap",
    { "theHamsta/nvim-dap-virtual-text", opts = { commented = true, virt_text_pos = "eol" } },
    "nvim-neotest/nvim-nio",
  },
  lazy = true, -- Lazy-loaded by the nvim-dap hydra
  opts = {
    layouts = {
      {
        elements = {
          { id = "scopes", size = 0.25 },
          { id = "breakpoints", size = 0.25 },
          { id = "watches", size = 0.25 },
          { id = "repl", size = 0.25 },
        },
        position = "right",
        size = 40,
      },
      {
        elements = { { id = "console", size = 1.0 } },
        position = "bottom",
        size = 10,
      },
    },
  },
  config = function(_, opts)
    local dapui = require("dapui")
    dapui.setup(opts)

    local dap = require("dap")

    -- Improve DAP symbols
    vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
    vim.fn.sign_define(
      "DapBreakpointCondition",
      { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
    )
    vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "→", texthl = "DapBreakpoint", linehl = "", numhl = "" })

    -- Enable rerunning last DAP final configuration
    vim.g.dap_last_config = nil
    dap.listeners.after.event_initialized["store_config"] = function(session) vim.g.dap_last_config = session.config end

    -- Open nvim-dap-ui automatically when debugging with nvim-dap
    dap.listeners.before.attach.dapui_config = function() dapui.open() end
    dap.listeners.before.launch.dapui_config = function() dapui.open() end
  end,
}
