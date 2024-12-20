-- nvim-dap-ui
--
-- nvim-dap-ui provides a UI for nvim-dap, making the debugging experience in Neovim as good as in an IDE.

local nvim_config = require("nvim_config")

return {
  "rcarriga/nvim-dap-ui",
  cond = not nvim_config.light_mode,
  dependencies = { { "nvim-neotest/nvim-nio", cond = not nvim_config.light_mode } },
  lazy = true, -- Dependency of nvim-dap
  opts = {
    layouts = { -- Remove the "stacks" element, move the "repl" to the sidebar, and move the sidebar on the right
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
        elements = {
          { id = "console", size = 1.0 },
        },
        position = "bottom",
        size = 10,
      },
    },
  },
}
