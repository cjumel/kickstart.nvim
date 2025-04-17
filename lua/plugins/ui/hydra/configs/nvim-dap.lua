return {
  key = { "<leader>d", desc = "[D]ebug menu" },
  opts = {
    body = "<leader>d",
    config = {
      desc = "[D]ebug menu",
      color = "pink", -- Allow other keymaps while the Hydra is open (e.g. move cursor to preview variables)
    },
    heads = {
      { "b", function() require("dap").toggle_breakpoint() end },
      {
        "B",
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
      },
      { "c", function() require("dap").clear_breakpoints() end },
      { "p", function() require("dap.ui.widgets").hover() end },
      { "r", function() require("dap").continue() end },
      {
        "R",
        function() -- Taken from https://github.com/mfussenegger/nvim-dap/issues/1025
          if vim.g.dap_last_config then
            require("dap").run(vim.g.dap_last_config)
          else
            error("No debug configuration found")
          end
        end,
      },
      { "s", function() require("dap").pause() end },
      { "t", function() require("dap").terminate() end },
      { "u", function() require("dapui").toggle() end },
      { "v", function() require("nvim-dap-virtual-text").toggle() end },
      { "<Esc>", nil, { exit = true, mode = "n", desc = false } },
    },
    hint = [[
                                   Debug   
   _b_ ➜ Toggle [B]reakpoint        _r_ ➜ [R]un     _t_ ➜ [T]erminate   
   _B_ ➜ Set complex [B]reakpoint   _R_ ➜ [R]erun   _u_ ➜ Toggle [U]I   
   _c_ ➜ [C]lear breakpoints        _s_ ➜ [S]top    _v_ ➜ Toggle [V]irtual text   
   _p_ ➜ [P]review variable   
]],
  },
}
