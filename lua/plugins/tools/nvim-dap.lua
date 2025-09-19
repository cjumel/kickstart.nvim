return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "rcarriga/cmp-dap",
  },
  keys = {
    { "<leader>dd", function() require("dapui").toggle() end, desc = "[D]ebug: toggle UI" },
    {
      "<leader>dr",
      function()
        if not vim.g.dap_python_loaded and vim.bo.filetype == "python" then
          require("lazy").load({ plugins = { "nvim-dap-python" } })
          vim.g.dap_python_loaded = true
        end
        vim.g.dap_prompt_parameters = false
        require("dap").continue()
      end,
      desc = "[D]ebug: [R]un",
    },
    {
      "<leader>dR",
      function()
        if not vim.g.dap_python_loaded and vim.bo.filetype == "python" then
          require("lazy").load({ plugins = { "nvim-dap-python" } })
          vim.g.dap_python_loaded = true
        end
        vim.g.dap_prompt_parameters = true
        require("dap").continue()
      end,
      desc = "[D]ebug: [R]un with parameters",
    },
    {
      "<leader>dl",
      function() -- Taken from https://github.com/mfussenegger/nvim-dap/issues/1025
        if vim.g.dap_last_config then
          require("dap").run(vim.g.dap_last_config)
        else
          error("No debug configuration found")
        end
      end,
      desc = "[D]ebug: run [L]ast",
    },
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "[D]ebug: toggle [B]reakpoint" },
    {
      "<leader>dB",
      function()
        vim.ui.select(
          { "Condition breakpoint", "Hit breakpoint", "Logpoint" },
          { prompt = "Select the kind of breakpoint" },
          function(selected)
            if selected == "Condition breakpoint" then
              local condition = vim.fn.input("Condition (code): ")
              require("dap").set_breakpoint(condition, nil, nil)
            elseif selected == "Hit breakpoint" then
              local hit_count = vim.fn.input("Hit count (integer): ")
              require("dap").set_breakpoint(nil, hit_count, nil)
            elseif selected == "Logpoint" then
              local log_message = vim.fn.input("Log message (variables must be inside `{…}`): ")
              require("dap").set_breakpoint(nil, nil, log_message)
            end
          end
        )
      end,
      desc = "[D]ebug: set complex [B]reakpoint",
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

    -- Enable rerunning last DAP final configuration
    vim.g.dap_last_config = nil
    dap.listeners.after.event_initialized["store_config"] = function(session) vim.g.dap_last_config = session.config end

    -- Open nvim-dap-ui automatically when debugging with nvim-dap
    local dapui = require("dapui")
    dap.listeners.before.attach.dapui_config = function() dapui.open() end
    dap.listeners.before.launch.dapui_config = function() dapui.open() end
  end,
}
