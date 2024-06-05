-- The option Hydra provides a simple interface to view and change Neovim-level settings.

return {
  body = "<leader>,",
  config = {
    desc = "Option Hydra",
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
        concealing = function()
          if vim.g.disable_concealing then
            return " on  / [off]"
          else
            return "[on] /  off "
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
                        Option Hydra                          

   Window options   
   _c_ ^ ^ ➜ Treesitter context:      %{treesitter_context}   
   _h_ ^ ^ ➜ Hide concealable text:   %{concealing}   
   _n_/_N_ ➜ Line numbering:          %{line_numbering}   
   _r_ ^ ^ ➜ Ruler column:            %{ruler_column}   
   _s_/_S_ ➜ Sign column:             %{sign_column}   

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
          if not utils.buffer.is_temporary() then
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
        local treesitter_context = package.loaded["treesitter-context"]
        if treesitter_context == nil then
          require("treesitter-context") -- Load the plugin, it will be enabled by default
        elseif treesitter_context.enabled() then
          treesitter_context.disable()
        else
          treesitter_context.enable()
        end
      end,
    },
    {
      "h",
      function()
        if vim.g.disable_concealing then
          vim.g.disable_concealing = false
          if not utils.buffer.is_temporary() then
            vim.cmd("edit") -- Reload the current buffer to apply the conceal level setting
          end
        else
          vim.g.disable_concealing = true
          if vim.bo.filetype == "markdown" then -- Apply the conceal level setting when relevant
            vim.opt_local.conceallevel = 0
          end
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
}
