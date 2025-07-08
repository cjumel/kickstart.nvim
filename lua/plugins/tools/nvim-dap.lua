-- nvim-dap
--
-- Debug Adapter Protocol client implementation for Neovim

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "rcarriga/cmp-dap",
    "mfussenegger/nvim-dap-python",
  },
  lazy = true, -- Lazy-loaded through the debug Hydra
  config = function()
    local dap = require("dap")
    local dap_repl = require("dap.repl")
    local dapui = require("dapui")

    -- Open nvim-dap-ui automatically when debugging
    dap.listeners.after.event_initialized["dapui_config"] = dapui.open

    -- Improve DAP symbols
    vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
    vim.fn.sign_define(
      "DapBreakpointCondition",
      { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
    )
    vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "→", texthl = "DapBreakpoint", linehl = "", numhl = "" })

    -- Enable rerunning last DAP final configuration
    vim.g.dap_last_config = nil
    dap.listeners.after.event_initialized["store_config"] = function(session) vim.g.dap_last_config = session.config end

    -- Setup language-specific DAP configurations
    dap.configurations.python = vim.g.dap_configs_python or {}

    -- Enable debugpy to detect errors caught by pytest and break
    dap.listeners.after.event_initialized["dap_exception_breakpoint"] = function()
      dap.set_exception_breakpoints({ "userUnhandled" })
    end

    -- Setup keymaps for DAP buffers
    local group = vim.api.nvim_create_augroup("NvimDapKeymaps", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = { "dap-repl", "dapui_watches" },
      callback = function()
        -- Keymaps to go through history like with the arrow keys (<C-n> & <C-p> are taken by nvim-cmp)
        vim.keymap.set("i", "<C-]>", dap_repl.on_up, { desc = "Previous history item", buffer = true }) -- <C-$>
        vim.keymap.set("i", "<C-\\>", dap_repl.on_down, { desc = "Next history item", buffer = true }) -- <C-`>
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
