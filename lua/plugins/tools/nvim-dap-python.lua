-- nvim-dap-python
--
-- nvim-dap-python provides a Python extension for nvim-dap, with default configurations for Python and some methods
-- to debug individual test methods or classes.

return {
  "mfussenegger/nvim-dap-python",
  cond = not require("config")["light_mode"],
  dependencies = {
    "mfussenegger/nvim-dap",
    "williamboman/mason.nvim",
  },
  lazy = true, -- Lazy-loaded by nvim-dap
  init = function()
    local mason_ensure_installed = { "debugpy" }
    vim.g.mason_ensure_installed = vim.list_extend(vim.g.mason_ensure_installed or {}, mason_ensure_installed)
  end,
  opts = {
    custom_configurations = { -- Custom option to define Python configurations
      {
        type = "python",
        request = "launch",
        name = "Run file",
        program = "${file}",
        console = "integratedTerminal",
      },
      {
        type = "python",
        request = "launch",
        name = "Pytest file",
        module = "pytest",
        args = { "${file}" },
        console = "integratedTerminal",
      },
      {
        type = "python",
        request = "launch",
        name = "Pytest file with arguments",
        module = "pytest",
        args = function()
          return coroutine.create(function(dap_run_co)
            vim.ui.input(
              { prompt = "Additional arguments: " },
              function(input) coroutine.resume(dap_run_co, { "${file}", input }) end
            )
          end)
        end,
        console = "integratedTerminal",
      },
      {
        type = "python",
        request = "launch",
        name = "Pytest function",
        module = "pytest",
        args = function()
          --- Output the name of the current function using Treesitter.
          ---@return string|nil
          local function get_function_name()
            local node = vim.treesitter.get_node() -- Get the node under the cursor
            while node ~= nil do
              if node:type() == "function_definition" then -- Node is a function definition
                local name_nodes = node:field("name")
                assert(#name_nodes == 1, "Expected exactly one name node")
                local name_node = name_nodes[1] -- Get the name node
                return vim.treesitter.get_node_text(name_node, vim.api.nvim_get_current_buf())
              end
              node = node:parent()
            end
          end

          local function_name = get_function_name()
          if function_name == nil then
            error("No function found")
          end
          return { "${file}::" .. function_name }
        end,
        console = "integratedTerminal",
      },
    },
    include_configs = false, -- Don't add builtin configurations
  },
  config = function(_, opts)
    local dap = require("dap")
    local dap_python = require("dap-python")

    -- Setup DAP-Python
    dap_python.setup("~/.local/share/nvim/mason/packages/debugpy/venv/bin/python", opts)

    -- Add custom configurations
    local configs = dap.configurations.python or {}
    for _, configuration in ipairs(opts.custom_configurations) do
      table.insert(configs, configuration)
    end
    dap.configurations.python = configs

    -- Enable debugpy to detect errors caught by pytest and break
    dap.listeners.after.event_initialized["dap_exception_breakpoint"] = function()
      dap.set_exception_breakpoints({ "userUnhandled" })
    end
  end,
}
