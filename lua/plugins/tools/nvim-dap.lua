-- nvim-dap
--
-- nvim-dap provides a Neovim implementation of the Debug Adapter Protocol (DAP), making possible to debug directly in
-- Neovim in various programming languages.

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "williamboman/mason.nvim",
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "rcarriga/cmp-dap",
  },
  lazy = true, -- Lazy-loaded through the debug Hydra
  init = function()
    local mason_ensure_installed = { "debugpy" }
    vim.g.mason_ensure_installed = vim.list_extend(vim.g.mason_ensure_installed or {}, mason_ensure_installed)
  end,
  config = function()
    -- Open nvim-dap-ui automatically when debugging
    require("dap").listeners.after.event_initialized["dapui_config"] = require("dapui").open

    -- Improve DAP symbols
    vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
    vim.fn.sign_define(
      "DapBreakpointCondition",
      { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
    )
    vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "→", texthl = "DapBreakpoint", linehl = "", numhl = "" })

    -- Enable rerunning last DAP final configuration (see https://github.com/mfussenegger/nvim-dap/issues/1025)
    vim.g.dap_last_config = nil
    require("dap").listeners.after.event_initialized["store_config"] = function(session)
      vim.g.dap_last_config = session.config
    end

    -- Setup language-specific DAP configurations
    local dap_config_dir_path = vim.fn.stdpath("config") .. "/lua/plugins/tools/nvim-dap/configs"
    local dap_config_file_paths = vim.split(vim.fn.glob(dap_config_dir_path .. "/*"), "\n")
    for _, dap_config_file_path in ipairs(dap_config_file_paths) do
      local dap_config_file_path_split = vim.split(dap_config_file_path, "/")
      local dap_config_name = dap_config_file_path_split[#dap_config_file_path_split]:gsub("%.lua$", "")
      local dap_config = require("plugins.tools.nvim-dap.configs." .. dap_config_name)
      dap_config.setup()
    end

    -- Setup keymaps for DAP buffers
    local group = vim.api.nvim_create_augroup("NvimDapKeymaps", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = { "dap-repl", "dapui_watches" },
      callback = function()
        -- Keymaps to go through history like with the arrow keys (<C-n> & <C-p> are taken by nvim-cmp)
        vim.keymap.set("i", "<C-]>", require("dap.repl").on_up, { desc = "Previous history item", buffer = true }) -- <C-$>
        vim.keymap.set("i", "<C-\\>", require("dap.repl").on_down, { desc = "Next history item", buffer = true }) -- <C-`>
        -- Fix delete word keymaps
        vim.keymap.set("i", "<C-w>", "<C-S-w>", { desc = "Delete word", buffer = true })
        vim.keymap.set("i", "<M-BS>", "<C-S-w>", { desc = "Delete word", buffer = true })
      end,
    })
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = { "dap-float" },
      callback = function() vim.keymap.set("n", "q", "<cmd>:q<CR>", { desc = "Close", buffer = true }) end,
    })
  end,
}
