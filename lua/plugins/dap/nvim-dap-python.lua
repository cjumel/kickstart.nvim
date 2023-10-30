-- nvim-dap-python
--
-- Python integration of nvim-dap. This plugins defines a few configurations and some functions
-- to make debugging Python code easier.

-- ISSUE: The debugger with pytest don't stop on failures, we need to use a breakpoint to make it stop.
-- TODO: Try neotest (https://github.com/nvim-neotest/neotest), this could solve the issue above, or
-- bring additional features.

return {
  "mfussenegger/nvim-dap-python",
  dependencies = {
    "mfussenegger/nvim-dap",
  },
  keys = {
    -- Run Python
    {
      "<leader>dpr",
      function()
        require("dap").run({
          type = "python",
          request = "launch",
          name = "Run file",
          program = "${file}",
          console = "integratedTerminal",
        })
      end,
      ft = "python",
      desc = "[D]ebug [P]ython: [R]un",
    },

    -- Test with Pytest
    {
      "<leader>dpm",
      function()
        require("dap-python").test_method({ test_runner = "pytest" })
      end,
      ft = "python",
      desc = "[D]ebug [P]ython: test [M]ethod",
    },
    {
      "<leader>dpf",
      function()
        require("dap").run({
          type = "python",
          request = "launch",
          name = "Test file",
          module = "pytest",
          args = { "${file}" },
          console = "integratedTerminal",
        })
      end,
      ft = "python",
      desc = "[D]ebug [P]ython: test [F]ile",
    },
  },
  config = function()
    require("dap-python").setup(
      "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python",
      { include_configs = false, console = "integratedTerminal" }
    )
  end,
}
