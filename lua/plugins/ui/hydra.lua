-- Hydra.nvim
--
-- Neovim implementation of the famous Emacs Hydra package.

return {
  "nvimtools/hydra.nvim",
  keys = {
    { "<C-w>", desc = "Window manager" },
    { "<leader>,", desc = "Option manager" },
    { "<leader>h", desc = "Hunk manager" },
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

    local actions = require("actions")

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

            -- In the following, when the setting depends on a plugin which is not loaded, let's
            -- try to display the setting without loading the plugin when possible, or display
            -- the default setting value without loading the plugin

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
                return " on  / [num] /  off "
              elseif vim.wo.signcolumn == "yes" then
                return "[on] /  num  /  off "
              else
                return " on  /  num  / [off]"
              end
            end,
            treesitter_context = function()
              local treesitter_context = package.loaded["treesitter-context"]
              if treesitter_context == nil then
                return " on  / [off]" -- default value
              end

              if treesitter_context.enabled() then
                return "[on] /  off "
              else
                return " on  / [off]"
              end
            end,

            -- Plugin options
            autopairs = function()
              local autopairs = package.loaded["nvim-autopairs"]
              if autopairs == nil then
                return "[on] /  off " -- default value
              end

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

   Plugin options   
   _a_ ^ ^ ➜ Auto-pairs:            %{autopairs}   
   _c_ ^ ^ ➜ Copilot:               %{copilot}   
   _f_ ^ ^ ➜ Format on save:        %{format_on_save}   
   _l_ ^ ^ ➜ Lint:                  %{lint}   

]],
      heads = {

        -- In the following, when the setting depends on a plugin which is not loaded, let's
        -- try to change the setting without loading the plugin when possible, otherwise load the
        -- plugin and change the setting afterwards

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
              vim.wo.signcolumn = "no"
            elseif vim.wo.signcolumn == "yes" then
              vim.wo.signcolumn = "number"
            else
              vim.wo.signcolumn = "yes"
            end
          end,
        },
        {
          "S",
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
          "t",
          function()
            local treesitter_context = require("treesitter-context") -- Load the plugin if necessary

            if treesitter_context.enabled() then
              treesitter_context.disable()
            else
              treesitter_context.enable()
            end
          end,
        },

        -- Plugin options
        {
          "a",
          function()
            local autopairs = require("nvim-autopairs") -- Load the plugin if necessary

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
              vim.cmd("Copilot disable") -- Load the plugin if necessary
              vim.g.disable_copilot = true
            else
              vim.cmd("Copilot enable") -- Load the plugin if necessary
              vim.g.disable_copilot = false
            end
          end,
        },
        {
          "f",
          function()
            -- Plugin doesn't need to be loaded
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
              -- Plugin doesn't need to be loaded
              vim.g.disable_lint = true
              vim.diagnostic.reset() -- Remove existing diagnostics
            else
              -- Load the plugin if necessary
              vim.g.disable_lint = false
              require("lint").try_lint() -- Manually trigger linting right away
            end
          end,
        },

        { "<Esc>", nil, { exit = true, desc = false } },
      },
    })

    Hydra({
      body = "<leader>h",
      config = {
        desc = "[H]unk manager",
        color = "pink", -- For synchron buffer actions
        on_exit = actions.clear_window, -- Leave hunk preview when leaving the hunk manager
        -- Setting `buffer=true` or `buffer=bufnr` makes the hunk manager keymaps only work in a
        -- single buffer, while still being able to switch buffer (as `foreign_keys="run"` can't
        -- be overriden for pink Hydra). In that case, the Hydra is still opened but the keymaps
        -- don't work in the new buffer, which is quite confusing.
        buffer = nil,
      },
      mode = { "n", "v" },
      hint = [[
   ^ ^                            ^ ^        Hunk manager           ^ ^                            
   _,_ ➜ Next hunk                _p_ ➜ [P]review hunk              _u_ ➜ [U]ndo stage   
   _;_ ➜ Previous hunk            _s_ ➜ [S]tage hunk/selection      _x_ ➜ Discard hunk/selection   
   _d_ ➜ Toggle [D]eleted hunks   
]],
      heads = {
        { ",", actions.next_hunk },
        { ";", actions.prev_hunk },
        {
          "d",
          function()
            require("gitsigns").toggle_deleted()
          end,
        },
        {
          "p",
          function()
            require("gitsigns").preview_hunk()
          end,
        },
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
        {
          "u",
          function()
            require("gitsigns").undo_stage_hunk()
          end,
        },
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
        -- Exist must be with <Esc> for compatibility with clear window action
        { "<Esc>", nil, { exit = true, desc = false } },
      },
    })
  end,
}
