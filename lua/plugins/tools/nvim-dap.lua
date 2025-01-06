-- nvim-dap
--
-- nvim-dap provides a Neovim implementation of the Debug Adapter Protocol (DAP), making possible to debug directly in
-- Neovim in various programming languages.

return {
  "mfussenegger/nvim-dap",
  cond = not require("conf").get("light_mode"),
  dependencies = { "williamboman/mason.nvim" },
  lazy = true, -- Dependency of nvim-dap-ui
  init = function()
    local mason_ensure_installed = { "debugpy" }
    vim.g.mason_ensure_installed = vim.list_extend(vim.g.mason_ensure_installed or {}, mason_ensure_installed)
  end,
  config = function()
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
