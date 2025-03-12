-- Let's try to use as few navigation keys (e.g. "h", "j", "k", "l" or even "w", "b", "e") as possible
local hint = [[
                                 Debug   
   _b_ ➜ Toggle [B]reakpoint   _p_ ➜ [P]review variable   _s_ ➜ [S]top   
   _B_ ➜ Clear [B]reakpoints   _r_ ➜ [R]un                _t_ ➜ [T]erminate   
   _l_ ➜ Run [L]ast            _R_ ➜ Toggle [R]EPL        _u_ ➜ Toggle [U]I   
]]

return {
  key = { "<leader>d", desc = "[D]ebug menu" },
  opts = {
    body = "<leader>d",
    config = {
      desc = "[D]ebug menu",
      color = "pink", -- Enable other keymaps while the Hydra is open
    },
    hint = hint,
    heads = {
      { "b", function() require("dap").toggle_breakpoint() end },
      { "B", function() require("dap").clear_breakpoints() end },
      {
        "l",
        function() -- Implementation taken from https://github.com/mfussenegger/nvim-dap/issues/1025
          if vim.g.dap_last_config then
            require("dap").run(vim.g.dap_last_config)
          else
            error("No debug configuration found")
          end
        end,
      },
      { "p", function() require("dap.ui.widgets").hover() end },
      {
        "r",
        function()
          if not package.loaded.dapui then -- Lazy-load dapui if necessary
            require("dapui")
          end
          require("dap").continue()
        end,
      },
      { "R", function() require("dap").repl.toggle() end },
      { "s", function() require("dap").pause() end },
      { "t", function() require("dap").terminate() end },
      { "u", function() require("dapui").toggle() end },
      { "q", nil, { exit = true, mode = "n", desc = false } },
      { "<Esc>", nil, { exit = true, mode = "n", desc = false } },
    },
  },
}
