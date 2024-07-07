-- nvim-dap
--
-- Neovim implemetation of the Debug Adapter Protocol (DAP).

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
  },
  keys = function()
    local dap = require("dap")
    local dapui = require("dapui")
    local widgets = require("dap.ui.widgets")

    return {
      {
        "<leader>dr",
        function()
          if vim.bo.filetype == "python" and package.loaded["dap-python"] == nil then
            require("dap-python") -- Setup DAP configurations for Python
          end
          dap.continue()
        end,
        desc = "[D]AP: [R]un",
      },
      { "<leader>dl", dap.run_last, desc = "[D]AP: run [L]ast" },
      { "<leader>dt", dap.terminate, desc = "[D]AP: [T]erminate" },
      { "<leader>db", dap.toggle_breakpoint, desc = "[D]AP: [B]reakpoint" },
      { "<leader>dK", widgets.hover, desc = "[D]AP: Hover" },
      {
        "<leader>dc",
        function()
          dapui.close() -- Close the UI if it's open
          dap.repl.toggle()
        end,
        desc = "[D]AP: toggle REPL [C]onsole",
      },
      {
        "<leader>du",
        function()
          dap.repl.close() -- Close the REPL console if it's open
          dapui.toggle()
        end,
        desc = "[D]AP: toggle [U]I",
      },
      { "<leader>dU", function() require("dapui").open({ reset = true }) end, desc = "[D]AP: reset [U]I" },
    }
  end,
  init = function()
    local temporary_filetypes = { "dap-repl" }
    vim.g.temporary_filetypes = vim.list_extend(vim.g.temporary_filetypes or {}, temporary_filetypes)
  end,
  config = function(_, _)
    local dap = require("dap")
    local dapui = require("dapui")

    -- Setup DAP-UI to open with DAP
    dap.listeners.after.event_initialized["dapui_config"] = dapui.open

    -- Define a column sign & a highlight for each type of breakpoint
    local sign = vim.fn.sign_define
    sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
    sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
    sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
  end,
}
