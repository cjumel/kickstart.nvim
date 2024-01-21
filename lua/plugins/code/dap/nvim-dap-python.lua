-- nvim-dap-python
--
-- Python integration of nvim-dap. This plugins defines a few configurations and some functions
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
      desc = "[D]ebug [P]ython: [R]un",
      ft = "python",
    },

    -- Test with Pytest
    {
      "<leader>dpt",
      function()
        require("dap-python").test_method({ test_runner = "pytest" })
      end,
      desc = "[D]ebug [P]ython: [T]est method",
      ft = "python",
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
      desc = "[D]ebug [P]ython: [T]est file",
      ft = "python",
    },
  },
  config = function()
    local dap = require("dap")
    local dap_python = require("dap-python")

    dap_python.setup(
      "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python",
      { include_configs = false, console = "integratedTerminal" }
    )

    -- Enable debugpy to detect errors caught by pytest and break
    dap.listeners.after.event_initialized["dap_exception_breakpoint"] = function()
      dap.set_exception_breakpoints({ "userUnhandled" })
    end
  end,
}
