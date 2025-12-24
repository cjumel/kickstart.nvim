return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "mfussenegger/nvim-dap-python",
  },
  keys = {
    { "<leader>dd", function() require("dapui").toggle() end, desc = "[D]ebug: toggle UI" },
    { "<leader>dr", function() require("dap").continue() end, desc = "[D]ebug: [R]un" },
    { "<leader>dl", function() require("dap").run_last() end, desc = "[D]ebug: run [L]ast" },
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "[D]ebug: toggle [B]reakpoint" },
    {
      "<leader>dB",
      function() require("dap").set_breakpoint(vim.fn.input("Condition (code):")) end,
      desc = "[D]ebug: set conditional [B]reakpoint",
    },
    {
      "<leader>d<C-b>",
      function() require("dap").set_breakpoint(nil, vim.fn.input("Hit count (integer):")) end,
      desc = "[D]ebug: set hit [B]reakpoint",
    },
    {
      "<leader>d<M-b>",
      function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log message (variables: `{…}`): ")) end,
      desc = "[D]ebug: set log [B]reakpoint",
    },
    { "<leader>dc", function() require("dap").clear_breakpoints() end, desc = "[D]ebug: [C]lear breakpoints" },
    { "<leader>dp", function() require("dap.ui.widgets").hover() end, desc = "[D]ebug: [P]review variable" },
    { "<leader>dt", function() require("dap").terminate() end, desc = "[D]ebug: [T]erminate" },
  },
  config = function()
    local dap = require("dap")

    -- Improve DAP symbols
    vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
    vim.fn.sign_define(
      "DapBreakpointCondition",
      { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
    )
    vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "→", texthl = "DapBreakpoint", linehl = "", numhl = "" })

    -- Open nvim-dap-ui automatically when debugging with nvim-dap
    local dapui = require("dapui")
    dap.listeners.before.attach.dapui_config = function() dapui.open() end
    dap.listeners.before.launch.dapui_config = function() dapui.open() end

    -- Python setup
    -- Enable debugpy to detect errors caught by pytest and break
    dap.listeners.after.event_initialized["dap_exception_breakpoint"] = function()
      dap.set_exception_breakpoints({ "userUnhandled" })
    end
    -- Add custom configurations
    dap.providers.configs["dap-python"] = function(bufnr)
      if vim.bo[bufnr].filetype ~= "python" then
        return {}
      end
      local python_utils = require("config.lang_utils.python")
      local module = python_utils.get_module()
      return {
        {
          type = "python",
          request = "launch",
          name = "python -m <module>",
          module = module,
          console = "integratedTerminal",
        },
        {
          type = "python",
          request = "launch",
          name = "python <file>",
          program = "${file}",
          console = "integratedTerminal",
        },
      }
    end
  end,
}
