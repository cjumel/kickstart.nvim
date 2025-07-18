-- nvim-dap-ui
--
-- A UI for nvim-dap which provides a good out of the box configuration.

return {
  "rcarriga/nvim-dap-ui",
  dependencies = {
    "mfussenegger/nvim-dap",
    "mfussenegger/nvim-dap-python",
    "rcarriga/cmp-dap",
    { "theHamsta/nvim-dap-virtual-text", opts = { commented = true, virt_text_pos = "eol" } },
    "nvim-neotest/nvim-nio",
  },
  lazy = true, -- Lazy-loaded by the nvim-dap hydra
  opts = {
    layouts = {
      {
        elements = {
          { id = "scopes", size = 0.25 },
          { id = "breakpoints", size = 0.25 },
          { id = "watches", size = 0.25 },
          { id = "repl", size = 0.25 },
        },
        position = "right",
        size = 40,
      },
      {
        elements = { { id = "console", size = 1.0 } },
        position = "bottom",
        size = 10,
      },
    },
  },
  config = function(_, opts)
    local dapui = require("dapui")
    dapui.setup(opts)

    local dap = require("dap")
    local dap_repl = require("dap.repl")

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

    -- Open nvim-dap-ui automatically when debugging with nvim-dap
    dap.listeners.before.attach.dapui_config = function() dapui.open() end
    dap.listeners.before.launch.dapui_config = function() dapui.open() end

    -- Setup keymaps for nvim-dap-ui buffers
    local group = vim.api.nvim_create_augroup("NvimDapuiKeymaps", { clear = true })
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
