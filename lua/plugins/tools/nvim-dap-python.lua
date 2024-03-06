-- nvim-dap-python
--
-- Python integration of nvim-dap. This plugins defines a few configurations and some functions
-- to make debugging Python code easier.

return {
  "mfussenegger/nvim-dap-python",
  dependencies = {
    "mfussenegger/nvim-dap",
  },
  cmd = {
    "DapPythonFile",
    "DapPytestFunction",
    "DapPytestFile",
  },
  opts = {
    mason_ensure_installed = { -- Custom option to automatically install missing Mason packages
      "debugpy",
    },
    include_configs = false,
    console = "integratedTerminal",
  },
  config = function(_, opts)
    local ensure_installed = require("plugins.core.mason.ensure_installed")
    ensure_installed(opts.mason_ensure_installed)

    local dap_python = require("dap-python")
    dap_python.setup("~/.local/share/nvim/mason/packages/debugpy/venv/bin/python", opts)

    -- Enable debugpy to detect errors caught by pytest and break
    local dap = require("dap")
    dap.listeners.after.event_initialized["dap_exception_breakpoint"] = function()
      dap.set_exception_breakpoints({ "userUnhandled" })
    end

    vim.api.nvim_create_user_command("DapPythonFile", function()
      require("dap").run({
        type = "python",
        request = "launch",
        name = "Run file",
        program = "${file}",
        console = "integratedTerminal",
      })
    end, { desc = "Run Python on file with DAP." })
    vim.api.nvim_create_user_command("DapPytestFunction", function()
      require("dap-python").test_method({ test_runner = "pytest" })
    end, { desc = "Run Pytest on function with DAP." })
    vim.api.nvim_create_user_command("DapPytestFile", function()
      require("dap").run({
        type = "python",
        request = "launch",
        name = "Test file",
        module = "pytest",
        args = { "${file}" },
        console = "integratedTerminal",
      })
    end, { desc = "Run Pytest on file with DAP." })
  end,
}
