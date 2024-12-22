-- nvim-dap
--
-- nvim-dap provides a Neovim implemetation of the Debug Adapter Protocol (DAP), enabling a great experience for
-- debugging directly in Neovim, making it a great plugin in my opinion. This plugin is best used with the nvim-dap-ui
-- plugin to provide a great user interface, and with language specific configuration, handled manually or with a plugin
-- like nvim-dap-python.

return {
  "mfussenegger/nvim-dap",
  cond = not require("conf").get("light_mode"),
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "williamboman/mason.nvim",
  },
  lazy = true, -- Loaded by keymaps in the debug Hydra
  init = function()
    local mason_ensure_installed = { "debugpy" }
    vim.g.mason_ensure_installed = vim.list_extend(vim.g.mason_ensure_installed or {}, mason_ensure_installed)
  end,
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    -- Open nvim-dap-ui along with nvim-dap
    dap.listeners.after.event_initialized["dapui_config"] = dapui.open

    -- Define a column sign & text highlight for each type of breakpoints
    vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
    vim.fn.sign_define(
      "DapBreakpointCondition",
      { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
    )
    vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })

    -- Setup language-specific DAP configurations
    local dap_python = require("plugins.tools.nvim-dap.python")
    dap_python.setup()
  end,
}
