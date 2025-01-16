-- nvim-dap-ui
--
-- nvim-dap-ui provides a nice user interface for nvim-dap, making the debugging experience in Neovim as good as in an
-- IDE.

return {
  "rcarriga/nvim-dap-ui",
  cond = not require("conf").light_mode,
  dependencies = {
    "mfussenegger/nvim-dap",
    { "nvim-neotest/nvim-nio", cond = not require("conf").light_mode },
  },
  lazy = true, -- Lazy-loaded by the debug Hydra
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
  config = function(_, opts)
    require("dapui").setup(opts)

    -- Open nvim-dap-ui along with nvim-dap
    require("dap").listeners.after.event_initialized["dapui_config"] = require("dapui").open
  end,
}
