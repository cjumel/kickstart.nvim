-- nvim-dap-python
--
-- An extension for nvim-dap, providing default configurations for python and methods to debug individual test methods
-- or classes.

return {
  "mfussenegger/nvim-dap-python",
  dependencies = { "williamboman/mason.nvim" },
  lazy = true, -- Dependency of nvim-dap
  init = function()
    local mason_ensure_installed = { "debugpy" }
    vim.g.mason_ensure_installed = vim.list_extend(vim.g.mason_ensure_installed or {}, mason_ensure_installed)
  end,
  opts = function()
    local python_utils = require("lang_utils.python")
    local function args_dialogue(base_args)
      base_args = base_args or {}
      return function()
        -- We can't use `vim.ui.input` because it's asynchronous and we need a synchronous input
        local args_string = vim.fn.input({ prompt = "Arguments: ", cancelreturn = false })
        if args_string == false then
          error("Dialog was cancelled")
        end
        return vim.list_extend(base_args, vim.split(args_string, " "))
      end
    end
    return {
      include_configs = false,
      _configs = {
        {
          type = "python",
          request = "launch",
          name = "python <file>",
          program = "${file}",
          console = "integratedTerminal",
          args = args_dialogue(),
        },
        {
          type = "python",
          request = "launch",
          name = "python -m <module>",
          module = python_utils.get_module(),
          console = "integratedTerminal",
          args = args_dialogue(),
        },
      },
    }
  end,
  config = function(_, opts)
    require("dap-python").setup("~/.local/share/nvim/mason/packages/debugpy/venv/bin/python", opts)
    vim.g.dap_configs_python = opts._configs
  end,
}
