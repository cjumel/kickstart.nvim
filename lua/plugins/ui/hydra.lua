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

    local filetypes = require("filetypes")

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
              if vim.g.disable_colorcolumn then
                return " on  / [off]"
              else
                return "[on] /  off "
              end
            end,
            sign_column = function()
              if vim.wo.signcolumn == "number" then
                return "[num] /  yes  /  off "
              elseif vim.wo.signcolumn == "yes" then
                return " num  / [yes] /  off "
              else
                return " num  /  yes  / [off]"
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
            hide_concelable_text = function()
              if vim.wo.conceallevel == 2 then
                return "[on] /  off "
              else
                return " on  / [off]"
              end
            end,
            invisible_cursor = function()
              if vim.g.invisible_cursor then
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
   _c_ ^ ^ ➜ Treesitter context:      %{treesitter_context}   
   _n_/_N_ ➜ Line numbering:          %{line_numbering}   
   _r_ ^ ^ ➜ Ruler column:            %{ruler_column}   
   _s_/_S_ ➜ Sign column:             %{sign_column}   
   _h_ ^ ^ ➜ Hide concealable text:   %{hide_concelable_text}
   _i_ ^ ^ ➜ Invisible cursor:        %{invisible_cursor}   

   Plugin options   
   _a_ ^ ^ ➜ Auto-pairs:              %{autopairs}   
   _f_ ^ ^ ➜ Format on save:          %{format_on_save}   
   _g_ ^ ^ ➜ GitHub copilot:          %{copilot}   
   _l_ ^ ^ ➜ Lint:                    %{lint}   

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
            -- This won't apply right away to opened buffers except for the current one
            -- To apply this manually, either use the ":e" (or ":edit") command, reload the buffer manually or toggle
            -- the setting again
            if not vim.g.disable_colorcolumn then
              vim.g.disable_colorcolumn = true
              vim.opt.colorcolumn = "" -- Remove the colorcolumn in current buffer
            else
              vim.g.disable_colorcolumn = false
              if not vim.tbl_contains(filetypes.temporary, vim.bo.filetype) then -- Don't apply to temporary buffers
                vim.cmd("edit") -- Reload the current buffer to apply the colorcolumn
              end
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
            elseif vim.wo.signcolumn == "no" then
              vim.wo.signcolumn = "yes"
            else
              vim.wo.signcolumn = "number"
            end
          end,
        },
        {
          "c",
          function()
            local treesitter_context = require("treesitter-context") -- Load the plugin if necessary
            if treesitter_context.enabled() then
              treesitter_context.disable()
            else
              treesitter_context.enable()
            end
          end,
        },
        {
          "h",
          function()
            if vim.wo.conceallevel == 2 then
              vim.o.conceallevel = 0
            else
              vim.o.conceallevel = 2 -- Hide concealable text almost all the time
            end
          end,
        },
        {
          "i",
          function()
            if vim.g.invisible_cursor then
              vim.g.invisible_cursor = false
              vim.cmd("highlight Cursor blend=0")
            else
              vim.g.invisible_cursor = true
              vim.cmd("highlight Cursor blend=100")
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
          "g",
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
  end,
}
