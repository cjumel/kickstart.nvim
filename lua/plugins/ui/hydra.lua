-- Hydra.nvim
--
-- This plugin provides a Neovim implementation of the famous Emacs Hydra package. It makes possible to define sub-menus
-- in Neovim, to make a set of actions a lot simpler to use than through regular keymaps, as there's no need to repeat
-- the common prefix in between the actions.

return {
  "nvimtools/hydra.nvim",
  keys = {
    { "<C-w>", desc = "Window Hydra" },
    { "<leader>d", desc = "[D]ebug Hydra" },
    { "<leader>h", mode = { "n", "v" }, desc = "[H]unk Hydra" },
    { "<leader>x", desc = "Conflict Hydra" },
  },
  opts = {
    invoke_on_body = true,
    hint = { float_opts = { border = "rounded" } }, -- Improve visibility in transparent backgrounds
  },
  config = function(_, opts)
    local Hydra = require("hydra")
    Hydra.setup(opts)

    Hydra({
      body = "<C-w>",
      config = {
        desc = "Window Hydra",
      },
      -- A few keymaps are not re-implemented:
      --  - "d"/"<C-d>" to show the diagnostics under the cursor, as I have re-implemented it with a custom keymap
      --  - "_" to max out the height, as not supported by Hydra
      --  - "|" to max out the width, by consistency with "_"
      hint = [[
                                        Window Hydra
   _h_ ➜ Go to the left window    _s_ ➜ [S]plit window              _+_ ➜ Increase height   
   _j_ ➜ Go to the down window    _T_ ➜ Break window into [T]ab     _-_ ➜ Decrease height   
   _k_ ➜ Go to the up window      _v_ ➜ Split window [V]ertically   _<_ ➜ Decrease width   
   _l_ ➜ Go to the right window   _w_ ➜ Switch windows              _=_ ➜ Equally high and wide   
   _o_ ➜ Close [O]ther windows    _x_ ➜ Swap window with next       _>_ ➜ Increase width   
   _q_ ➜ [Q]uit window   
]],
      heads = {
        { "h", "<C-w>h" },
        { "j", "<C-w>j" },
        { "k", "<C-w>k" },
        { "l", "<C-w>l" },
        { "o", "<C-w>o" },
        { "q", "<C-w>q" },
        { "s", "<C-w>s" },
        { "T", "<C-w>T" },
        { "v", "<C-w>v" },
        { "w", "<C-w>w" },
        { "x", "<C-w>x" },
        { "+", "<C-w>+" },
        { "-", "<C-w>-" },
        { "<", "<C-w><" },
        { "=", "<C-w>=" },
        { ">", "<C-w>>" },
        { "<Esc>", nil, { exit = true, desc = false } },
      },
    })

    Hydra({
      body = "<leader>d",
      config = {
        desc = "[D]ebug Hydra",
        color = "pink", -- Enable other keymaps while the Hydra is open
      },
      -- Let's try to use as few navigation keys (e.g. "h", "j", "k", "l" or even "w", "b", "e") as possible
      -- Keys like "d" or "c", which can take a text-object, introduce a latency when using them as Neovim waits for the
      -- optional text-object before triggering the keymap, so they are not great either
      hint = [[
                              Debug Hydra
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
    })

    Hydra({
      body = "<leader>h",
      config = {
        desc = "[H]unk Hydra",
        color = "pink", -- Enable other keymaps while the Hydra is open
        -- Setting `buffer=true` or `buffer=bufnr` makes the hunk manager keymaps only work in a single buffer, while still
        -- being able to switch buffer. In that case, the Hydra is still opened but the keymaps don't work in the new
        -- buffer, which is quite confusing, so I prefer to use `buffer=nil`.
        buffer = nil,
      },
      mode = { "n", "v" },
      -- Let's keep "h", "j", "k", "l", "w", "e", and "b" for navigation, "v" for visual mode, "a", "i" and "g" for text
      -- objects in visual mode, to still be able to use them while the Hydra is open
      hint = [[
                                    Hunk Hydra
   _p_ ➜ [P]review hunk           _u_ ➜ [U]nstage staged hunk    _,_ ➜ Next hunk   
   _s_ ➜ [S]tage hunk/selection   _x_ ➜ Discard hunk/selection   _;_ ➜ Previous hunk   
]],
      heads = {
        { "p", function() require("gitsigns").preview_hunk() end },
        {
          "s",
          function()
            if vim.fn.mode() == "n" then
              require("gitsigns").stage_hunk()
            else
              require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end
          end,
        },
        { "u", function() require("gitsigns").undo_stage_hunk() end },
        {
          "x",
          function()
            if vim.fn.mode() == "n" then
              require("gitsigns").reset_hunk()
            else
              require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end
          end,
        },
        -- "," & ";" are not made repeatable on purpose, to be able to resume the previous next/previous moves later
        { ",", function() require("gitsigns").nav_hunk("next") end },
        { ";", function() require("gitsigns").nav_hunk("prev") end },
        { "q", nil, { exit = true, mode = "n", desc = false } },
        { "<Esc>", nil, { exit = true, mode = "n", desc = false } },
      },
    })

    Hydra({
      body = "<leader>x",
      config = {
        desc = "Conflict Hydra",
        color = "pink", -- Enable other keymaps while the Hydra is open
      },
      hint = [[
                           Conflict Hydra
   _b_ ➜ Choose [B]oth   _o_ ➜ Choose [O]urs    _,_ ➜ Next conflict   
   _n_ ➜ Choose [N]one   _t_ ➜ Choose [T]eirs   _;_ ➜ Previous conflict   
]],
      heads = {
        { "b", function() require("git-conflict").choose("both") end },
        { "n", function() require("git-conflict").choose("none") end },
        { "o", function() require("git-conflict").choose("ours") end },
        { "t", function() require("git-conflict").choose("theirs") end },
        { ",", function() require("git-conflict").find_next("ours") end },
        { ";", function() require("git-conflict").find_prev("ours") end },

        -- Exit heads
        { "q", nil, { exit = true, mode = "n", desc = false } },
        { "<Esc>", nil, { exit = true, mode = "n", desc = false } },
      },
    })
  end,
}
