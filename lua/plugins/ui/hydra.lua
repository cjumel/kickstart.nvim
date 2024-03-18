-- Hydra.nvim
--
-- Neovim implementation of the famous Emacs Hydra package.

return {
  "nvimtools/hydra.nvim",
  keys = {
    { "<C-w>", desc = "Window manager" },
    { "<leader>,", desc = "Option manager" },
  },
  opts = {
    invoke_on_body = true,
    hint = {
      float_opts = {
        border = "rounded", -- Improve visibility with transparent background
      },
    },
  },
  config = function(_, opts)
    local Hydra = require("hydra")

    Hydra.setup(opts)

    -- The window manager uses builtin keymaps and the descriptions provided by WhichKey
    Hydra({
      body = "<C-w>",
      config = {
        desc = "Window manager",
      },
      hint = [[
   Window manager
   _+_ ➜ Increase height         _h_ ➜ Go to the left window    _q_ ➜ [Q]uit window   
   _-_ ➜ Decrease height         _j_ ➜ Go to the down window    _s_ ➜ [S]plit window   
   _>_ ➜ Increase width          _k_ ➜ Go to the up window      _v_ ➜ [V]ertically split window   
   _<_ ➜ Decrease width          _l_ ➜ Go to the right window   _w_ ➜ Switch windows   
   _=_ ➜ Equally high and wide   _o_ ➜ Close [O]ther windows    _x_ ➜ Swap current window with next   
]],
      heads = {
        { "+", "<C-w>+" },
        { "-", "<C-w>-" },
        { "<", "<C-w><" },
        { "=", "<C-w>=" },
        { ">", "<C-w>>" },
        -- { "_", "<C-w>_" }, -- Not supported by Hydra hint, but not important
        -- { "|", "<C-w>|" }, -- Not important as well, and disabled by consistency with "_"
        { "h", "<C-w>h" },
        { "j", "<C-w>j" },
        { "k", "<C-w>k" },
        { "l", "<C-w>l" },
        { "o", "<C-w>o" },
        { "q", "<C-w>q" },
        { "s", "<C-w>s" },
        -- { "T", "<C-w>T" }, -- I don't use tabs so it's not useful
        { "v", "<C-w>v" },
        { "w", "<C-w>w" },
        { "x", "<C-w>x" },
        { "<Esc>", nil, { exit = true, desc = false } },
      },
    })

    Hydra({
      body = "<leader>,",
      config = {
        desc = "Option manager",
        hint = {
          position = "middle",
          funcs = {

            -- Window option
            line_numbering = function()
              if vim.wo.number and not vim.wo.relativenumber then
                return "[abs] /  rel  /  off "
              elseif vim.wo.number and vim.wo.relativenumber then
                return " abs  / [rel] /  off "
              else
                return " abs  /  rel  / [off]"
              end
            end,
            ruler_column = function()
              if vim.o.colorcolumn == "101" then
                return "[100] /  off "
              else
                return " 100  / [off]"
              end
            end,
            sign_column = function()
              if vim.wo.signcolumn == "number" then
                return "[mix] /  on  /  off "
              elseif vim.wo.signcolumn == "yes" then
                return " mix  / [on] /  off "
              else
                return " mix  /  on  / [off]"
              end
            end,
            treesitter_context = function()
              local treesitter_context = require("treesitter-context")
              if treesitter_context.enabled() then
                return "[on] /  off "
              else
                return " on  / [off]"
              end
            end,

            -- External tools
            autopairs = function()
              local autopairs = require("nvim-autopairs")
              if autopairs.state.disabled then
                return " on  / [off]"
              else
                return "[on] /  off "
              end
            end,
            copilot = function()
              if vim.g.disable_copilot then
                return " on  / [off]"
              else
                return "[on] /  off "
              end
            end,
            format_on_save = function()
              if vim.g.disable_autoformat then
                return " on  / [off]"
              else
                return "[on] /  off "
              end
            end,
            lint = function()
              if vim.g.disable_lint then
                return " on  / [off]"
              else
                return "[on] /  off "
              end
            end,
          },
        },
      },
      hint = [[
                       Options                        

   Window options   
   _n_/_N_ ➜ Line numbring:         %{line_numbering}   
   _r_ ^ ^ ➜ Ruler column:          %{ruler_column}   
   _s_/_S_ ➜ Sign column:           %{sign_column}   
   _t_ ^ ^ ➜ Treesitterr context:   %{treesitter_context}   

   External tools   
   _a_ ➜ Auto-pairs:       %{autopairs}   
   _c_ ➜ Copilot:          %{copilot}   
   _f_ ➜ Format on save:   %{format_on_save}   
   _l_ ➜ Lint:             %{lint}   

]],
      heads = {

        -- Window options
        {
          "n",
          function()
            if vim.wo.number and not vim.wo.relativenumber then
              vim.wo.number = true
              vim.wo.relativenumber = true
            elseif vim.wo.number and vim.wo.relativenumber then
              vim.wo.number = false
              vim.wo.relativenumber = false
            else
              vim.wo.number = true
              vim.wo.relativenumber = false
            end
          end,
        },
        {
          "N",
          function()
            if vim.wo.number and not vim.wo.relativenumber then
              vim.wo.number = false
              vim.wo.relativenumber = false
            elseif vim.wo.number and vim.wo.relativenumber then
              vim.wo.number = true
              vim.wo.relativenumber = false
            else
              vim.wo.number = true
              vim.wo.relativenumber = true
            end
          end,
        },
        {
          "r",
          function()
            if vim.o.colorcolumn == "101" then
              vim.o.colorcolumn = ""
            else
              vim.o.colorcolumn = "101"
            end
          end,
        },
        {
          "s",
          function()
            if vim.wo.signcolumn == "number" then
              vim.wo.signcolumn = "yes"
            elseif vim.wo.signcolumn == "yes" then
              vim.wo.signcolumn = "no"
            else
              vim.wo.signcolumn = "number"
            end
          end,
        },
        {
          "S",
          function()
            if vim.wo.signcolumn == "number" then
              vim.wo.signcolumn = "no"
            elseif vim.wo.signcolumn == "yes" then
              vim.wo.signcolumn = "number"
            else
              vim.wo.signcolumn = "yes"
            end
          end,
        },
        {
          "t",
          function()
            local treesitter_context = require("treesitter-context")
            if treesitter_context.enabled() then
              treesitter_context.disable()
            else
              treesitter_context.enable()
            end
          end,
        },

        -- External tools
        {
          "a",
          function()
            local autopairs = require("nvim-autopairs")
            if autopairs.state.disabled then
              autopairs.enable()
            else
              autopairs.disable()
            end
          end,
        },
        {
          "c",
          function()
            if not vim.g.disable_copilot then
              vim.cmd("Copilot disable")
              vim.g.disable_copilot = true
            else
              vim.cmd("Copilot enable")
              vim.g.disable_copilot = false
            end
          end,
        },
        {
          "f",
          function()
            if not vim.g.disable_autoformat then
              vim.g.disable_autoformat = true
            else
              vim.g.disable_autoformat = false
            end
          end,
        },
        {
          "l",
          function()
            if not vim.g.disable_lint then
              vim.g.disable_lint = true
              vim.diagnostic.reset() -- Remove existing diagnostics
            else
              vim.g.disable_lint = false
              require("lint").try_lint() -- Manually trigger linting
            end
          end,
        },

        { "<Esc>", nil, { exit = true, desc = false } },
      },
    })
  end,
}
