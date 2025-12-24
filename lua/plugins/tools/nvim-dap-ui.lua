return {
  "rcarriga/nvim-dap-ui",
  dependencies = { "nvim-neotest/nvim-nio" },
  lazy = true, -- Dependency of nvim-dap
  opts = {
    layouts = {
      {
        elements = { { id = "console", size = 0.5 }, { id = "repl", size = 0.5 } },
        position = "bottom",
        size = 10,
      },
      {
        elements = {
          { id = "scopes", size = 0.33 },
          { id = "breakpoints", size = 0.33 },
          { id = "watches", size = 0.33 },
        },
        position = "right",
        size = 40,
      },
    },
  },
}
