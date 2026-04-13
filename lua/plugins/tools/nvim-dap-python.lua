return {
  "mfussenegger/nvim-dap-python",
  dependencies = { "mason-org/mason.nvim" },
  lazy = true, -- Dependency of nvim-dap
  opts = {
    include_configs = false, -- Prefer custom configurations
  },
  config = function(_, opts)
    local dap_python = require("dap-python")
    dap_python.setup("~/.local/share/nvim/mason/packages/debugpy/venv/bin/python", opts)
  end,
}
