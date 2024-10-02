-- nvim-dap
--
-- nvim-dap provides a Neovim implemetation of the Debug Adapter Protocol (DAP), enabling a great experience for
-- debugging directly in Neovim, making it a great plugin in my opinion. This plugin is best used with the nvim-dap-ui
-- plugin to provide a great user interface, and with language specific configuration, like nvim-dap-python.

return {
  "mfussenegger/nvim-dap",
  cond = not require("config")["light_mode"],
  dependencies = { "rcarriga/nvim-dap-ui" },
  keys = {
    {
      "<leader>dr",
      function()
        if vim.bo.filetype == "python" and package.loaded["dap-python"] == nil then
          require("dap-python") -- Setup DAP configurations for Python
        end
        require("dap").continue()
      end,
      desc = "[D]AP: [R]un",
    },
    { "<leader>dl", function() require("dap").run_last() end, desc = "[D]AP: run [L]ast" },
    { "<leader>dt", function() require("dap").terminate() end, desc = "[D]AP: [T]erminate" },
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "[D]AP: [B]reakpoint" },
    { "<leader>dK", function() require("dap.ui.widgets").hover() end, desc = "[D]AP: Hover" },
    {
      "<leader>dc",
      function()
        require("dapui").close() -- Close the UI if it's open
        require("dap").repl.toggle()
      end,
      desc = "[D]AP: toggle REPL [C]onsole",
    },
    {
      "<leader>du",
      function()
        require("dap").repl.close() -- Close the REPL console if it's open
        require("dapui").toggle()
      end,
      desc = "[D]AP: toggle [U]I",
    },
    { "<leader>dU", function() require("dapui").open({ reset = true }) end, desc = "[D]AP: reset [U]I" },
  },
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
