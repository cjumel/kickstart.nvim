-- This config is adapted from pieces of:
-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#python
-- https://github.com/mfussenegger/nvim-dap-python/blob/34282820bb713b9a5fdb120ae8dd85c2b3f49b51/lua/dap-python.lua

local M = {}

local function get_python_path()
  local venv_path = os.getenv("VIRTUAL_ENV")
  if venv_path then
    return venv_path .. "/bin/python"
  end
  return nil
end

local function enrich_config(config, on_config)
  if not config.pythonPath and not config.python then
    config.pythonPath = get_python_path()
  end
  on_config(config)
end

M.setup = function()
  local dap = require("dap")

  dap.adapters.python = function(cb, config)
    if config.request == "attach" then
      ---@diagnostic disable-next-line: undefined-field
      local port = (config.connect or config).port
      ---@diagnostic disable-next-line: undefined-field
      local host = (config.connect or config).host or "127.0.0.1"
      cb({
        type = "server",
        port = assert(port, "`connect.port` is required for a python `attach` configuration"),
        host = host,
        enrich_config = enrich_config,
        options = { source_filetype = "python" },
      })
    else
      cb({
        type = "executable",
        command = vim.env.HOME .. "/.local/share/nvim/mason/packages/debugpy/venv/bin/python",
        args = { "-m", "debugpy.adapter" },
        enrich_config = enrich_config,
        options = { source_filetype = "python" },
      })
    end
  end

  dap.providers.configs["dap-python"] = function(bufnr)
    if vim.bo[bufnr].filetype ~= "python" then
      return {}
    end

    local python_utils = require("lang_utils.python")

    -- In the following, we can't use `vim.ui.input` because it's asynchronous and we need a synchronous input
    local configs = {
      {
        type = "python",
        request = "launch",
        name = "python <file>",
        program = "${file}",
        console = "integratedTerminal",
        args = function() return vim.split(vim.fn.input("Arguments: "), " ") end,
      },
      {
        type = "python",
        request = "launch",
        name = "python -m <module>",
        module = python_utils.get_module(),
        console = "integratedTerminal",
        args = function() return vim.split(vim.fn.input("Arguments: "), " ") end,
      },
    }

    if vim.fn.executable("pytest") == 1 and python_utils.is_test_file() then
      table.insert(configs, {
        type = "python",
        request = "launch",
        name = "pytest <file>",
        module = "pytest",
        console = "integratedTerminal",
        args = function() return vim.list_extend({ "${file}" }, vim.split(vim.fn.input("Arguments: "), " ")) end,
      })

      local test_function_name = python_utils.get_test_function_name()
      if test_function_name ~= nil then
        table.insert(configs, {
          type = "python",
          request = "launch",
          name = "pytest <function>",
          module = "pytest",
          console = "integratedTerminal",
          args = function()
            return vim.list_extend({ "${file}::" .. test_function_name }, vim.split(vim.fn.input("Arguments: "), " "))
          end,
        })
      end
    end

    return configs
  end

  -- Enable debugpy to detect errors caught by pytest and break
  dap.listeners.after.event_initialized["dap_exception_breakpoint"] = function()
    dap.set_exception_breakpoints({ "userUnhandled" })
  end
end

return M
