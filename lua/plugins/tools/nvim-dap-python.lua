return {
  "mfussenegger/nvim-dap-python",
  dependencies = {
    "mfussenegger/nvim-dap",
    "mason-org/mason.nvim",
  },
  lazy = true, -- Lazy-loaded by nvim-dap
  opts = {
    include_configs = false,
  },
  config = function(_, opts)
    local dap_python = require("dap-python")
    dap_python.setup("~/.local/share/nvim/mason/packages/debugpy/venv/bin/python", opts)

    -- Make sure all required dependencies can be installed with the `MasonInstallAll` command
    local mason_ensure_installed = { "debugpy" }
    vim.g.mason_ensure_installed = vim.list_extend(vim.g.mason_ensure_installed or {}, mason_ensure_installed)

    local dap = require("dap")

    -- Setup custom DAP configs
    dap.providers.configs["dap-python"] = function(bufnr)
      if vim.bo[bufnr].filetype ~= "python" then
        return {}
      end

      local python_utils = require("config.lang_utils.python")
      local function args_dialogue(base_args)
        base_args = base_args or {}
        return function()
          if vim.g.dap_prompt_parameters then
            -- We can't use `vim.ui.input` because it's asynchronous and we need a synchronous input
            local args_string = vim.fn.input({ prompt = "Arguments: ", cancelreturn = false })
            if not args_string then
              error("Dialog was cancelled")
            end
            return vim.list_extend(base_args, vim.split(args_string, " "))
          else
            return base_args
          end
        end
      end

      local configs = {}
      if not python_utils.is_test_file() then
        local absolute_file_path = vim.fn.expand("%:p")
        local absolute_cwd_path = vim.fn.fnamemodify(vim.fn.getcwd(), ":p")
        local file_is_in_cwd = string.sub(absolute_file_path, 1, #absolute_cwd_path) == absolute_cwd_path
        local module = python_utils.get_module()

        table.insert(configs, {
          type = "python",
          request = "launch",
          name = "python (auto)",
          module = file_is_in_cwd and module or "${file}",
          console = "integratedTerminal",
          args = args_dialogue(),
        })
        table.insert(configs, {
          type = "python",
          request = "launch",
          name = "python (module)",
          module = module,
          console = "integratedTerminal",
          args = args_dialogue(),
        })
        table.insert(configs, {
          type = "python",
          request = "launch",
          name = "python (file)",
          program = "${file}",
          console = "integratedTerminal",
          args = args_dialogue(),
        })
      else
        if vim.fn.executable("pytest") == 1 then
          local test_function_name = python_utils.get_test_function_name()
          if test_function_name ~= nil then
            table.insert(configs, {
              type = "python",
              request = "launch",
              name = "pytest (function)",
              module = "pytest",
              console = "integratedTerminal",
              args = args_dialogue({ "${file}::" .. test_function_name }),
            })
          end
          table.insert(configs, {
            type = "python",
            request = "launch",
            name = "pytest (file)",
            module = "pytest",
            console = "integratedTerminal",
            args = args_dialogue({ "${file}" }),
          })
        end
      end
      if not vim.g.dap_prompt_parameters then
        return { configs[1] }
      end
      return configs
    end

    -- Enable debugpy to detect errors caught by pytest and break
    dap.listeners.after.event_initialized["dap_exception_breakpoint"] = function()
      dap.set_exception_breakpoints({ "userUnhandled" })
    end
  end,
}
