return {
  key = { "<leader>d", desc = "[D]ebug menu" },
  opts = {
    body = "<leader>d",
    config = {
      desc = "[D]ebug menu",
      color = "pink", -- Enable other keymaps while the Hydra is open
    },
    -- Let's try to use as few navigation keys (e.g. "h", "j", "k", "l" or even "w", "b", "e") as possible
    -- Keys like "d" or "c", which can take a text-object, introduce a latency when using them as Neovim waits for the
    -- optional text-object before triggering the keymap, so they are not great either
    hint = [[
                                 Debug   
   _b_ ➜ Toggle [B]reakpoint   _r_ ➜ [R]un         _u_ ➜ Toggle [U]I   
   _p_ ➜ [P]review variable    _t_ ➜ [T]erminate   _z_ ➜ Toggle [Z]oom REPL   
]],
    heads = {
      { "b", function() require("dap").toggle_breakpoint() end },
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
      { "t", function() require("dap").terminate() end },
      { "u", function() require("dapui").toggle() end },
      { "z", function() require("dap").repl.toggle() end },
      { "q", nil, { exit = true, mode = "n", desc = false } },
      { "<Esc>", nil, { exit = true, mode = "n", desc = false } },
    },
  },
}
