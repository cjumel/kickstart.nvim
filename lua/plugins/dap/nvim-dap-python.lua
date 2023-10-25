-- nvim-dap-python
--
-- Python integration of nimv-dap. This plugins defines a few configurations and some functions
-- to make debugging Python code easier.

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
      "<leader>dpt",
      function()
        require("dap-python").test_method({ test_runner = "pytest" })
      end,
      ft = "python",
      desc = "[D]ebug [P]ython: [T]est method",
    },
    {
      "<leader>dpT",
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
      desc = "[D]ebug [P]ython: [T]est file",
    },
  },
  config = function()
    require("dap-python").setup(
      "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python",
      { include_configs = false, console = "integratedTerminal" }
    )
  end,
}
