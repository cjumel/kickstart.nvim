-- nvim-dap
--
-- nvim-dap provides a Neovim implementation of the Debug Adapter Protocol (DAP), making possible to debug directly in
-- Neovim in various programming languages.

return {
  "mfussenegger/nvim-dap",
  cond = not require("conf").light_mode,
  dependencies = {
    "williamboman/mason.nvim",
    "rcarriga/cmp-dap",
  },
  lazy = true, -- Dependency of nvim-dap-ui
  init = function()
    local mason_ensure_installed = { "debugpy" }
    vim.g.mason_ensure_installed = vim.list_extend(vim.g.mason_ensure_installed or {}, mason_ensure_installed)
  end,
  config = function()
    -- Define a column sign & text highlight for each type of breakpoints
    vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
    vim.fn.sign_define(
      "DapBreakpointCondition",
      { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
    )
    vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })

    -- Setup language-specific DAP configurations
    local dap_config_dir_path = vim.fn.stdpath("config") .. "/lua/plugins/tools/nvim-dap/configs"
    local dap_config_file_paths = vim.split(vim.fn.glob(dap_config_dir_path .. "/*"), "\n")
    for _, dap_config_file_path in ipairs(dap_config_file_paths) do
      local dap_config_file_path_split = vim.split(dap_config_file_path, "/")
      local dap_config_name = dap_config_file_path_split[#dap_config_file_path_split]:gsub("%.lua$", "")
      local dap_config = require("plugins.tools.nvim-dap.configs." .. dap_config_name)
      dap_config.setup()
    end
  end,
}
