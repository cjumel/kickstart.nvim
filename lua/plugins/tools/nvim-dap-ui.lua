-- nvim-dap-ui
--
-- nvim-dap-ui provides a nice user interface for nvim-dap, making the debugging experience in Neovim as good as in any
-- IDE.

return {
  "rcarriga/nvim-dap-ui",
  cond = not Metaconfig.light_mode,
  dependencies = { "nvim-neotest/nvim-nio" },
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
