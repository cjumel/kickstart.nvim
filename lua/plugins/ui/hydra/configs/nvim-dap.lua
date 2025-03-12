return {
  key = { "<leader>d", desc = "[D]ebug menu" },
  opts = {
    body = "<leader>d",
    config = {
      desc = "[D]ebug menu",
      color = "pink", -- Allow other keymaps while the Hydra is open
    },
    heads = {
      -- Don't use Neovim arrow keys ("h", "j", "k", "l") or movement keys ("w", "b", "e" and their upper-case variants)
      -- to be able to navigate in the code and preview variables
      {
        "a",
        function() -- Implementation taken from https://github.com/mfussenegger/nvim-dap/issues/1025
          if vim.g.dap_last_config then
            require("dap").run(vim.g.dap_last_config)
          else
            error("No debug configuration found")
          end
        end,
      },
      { "o", function() require("dap").toggle_breakpoint() end }, -- Mnemonic: "o" has the shape of a breakpoint
      { "O", function() require("dap").clear_breakpoints() end }, -- Mnemonic: "o" has the shape of a breakpoint
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
    hint = [[
                                Debug   
   _a_ ➜ Run [A]gain         _p_ ➜ [P]review variable   _s_ ➜ [S]top   
   _o_ ➜ Toggle Breakpoint   _r_ ➜ [R]un                _t_ ➜ [T]erminate   
   _O_ ➜ Clear Breakpoints   _R_ ➜ Toggle [R]EPL        _u_ ➜ Toggle [U]I   
]],
  },
}
