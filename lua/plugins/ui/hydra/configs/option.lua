-- The option Hydra provides a simple interface to view and change Neovim-level settings.

-- [[ Plugin options ]]
-- All the plugin options rely on a `vim.g.disable_` variable. The display functions display the relevant setting based
-- directly on it, while the toggle functions switch its value &, when necessary & if the plugin is loaded, apply the
-- new option to the plugin settings.

local function autopairs_display()
  if vim.g.disable_autopairs then
    return " on  / [off]"
  end
  return "[on] /  off "
end
local function autopairs_toggle()
  vim.g.disable_autopairs = not vim.g.disable_autopairs

  local autopairs = package.loaded["nvim-autopairs"]
  if autopairs ~= nil then
    if vim.g.disable_autopairs then
      autopairs.disable()
    else
      autopairs.enable()
    end
  end
end

local function format_on_save_display()
  if vim.g.disable_format_on_save then
    return " on  / [off]"
  end
  return "[on] /  off "
end
local function format_on_save_toggle() vim.g.disable_format_on_save = not vim.g.disable_format_on_save end

local function github_copilot_display()
  if vim.g.disable_github_copilot then
    return " on  / [off]"
  end
  return "[on] /  off "
end
local function github_copilot_toggle()
  vim.g.disable_github_copilot = not vim.g.disable_github_copilot

  local copilot = package.loaded["_copilot"]
  if copilot ~= nil then
    if vim.g.disable_github_copilot then
      vim.cmd("Copilot disable")
    else
      vim.cmd("Copilot enable")
    end
  end
end

local function lint_display()
  if vim.g.disable_lint then
    return " on  / [off]"
  end
  return "[on] /  off "
end
local function lint_toggle()
  vim.g.disable_lint = not vim.g.disable_lint

  local lint = package.loaded["lint"]
  if lint ~= nil then
    if vim.g.disable_lint then
      vim.diagnostic.reset() -- Remove existing diagnostics
    else
      lint.try_lint() -- Manually trigger linting right away
    end
  end
end

local function treesitter_context_display()
  if vim.g.disable_treesitter_context then
    return " on  / [off]"
  end
  return "[on] /  off "
end
local function treesitter_context_toggle()
  vim.g.disable_treesitter_context = not vim.g.disable_treesitter_context

  local treesitter_context = package.loaded["treesitter-context"]
  if treesitter_context ~= nil then
    if vim.g.disable_treesitter_context then
      treesitter_context.disable()
    else
      treesitter_context.enable()
    end
  end
end

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
        concealing = function()
          if vim.g.disable_concealing then
            return " on  / [off]"
          else
            return "[on] /  off "
          end
        end,

        -- Plugin options
        autopairs = autopairs_display,
        format_on_save = format_on_save_display,
        github_copilot = github_copilot_display,
        lint = lint_display,
        treesitter_context = treesitter_context_display,
      },
    },
  },
  hint = [[
                        Option Hydra                          

   Window options   
   _h_ ^ ^ ➜ Hide concealable text:   %{concealing}   
   _n_/_N_ ➜ Line numbering:          %{line_numbering}   
   _r_ ^ ^ ➜ Ruler column:            %{ruler_column}   
   _s_/_S_ ➜ Sign column:             %{sign_column}   

   Plugin options   
   _a_ ^ ^ ➜ Auto-pairs:              %{autopairs}   
   _f_ ^ ^ ➜ Format on save:          %{format_on_save}   
   _g_ ^ ^ ➜ GitHub copilot:          %{github_copilot}   
   _l_ ^ ^ ➜ Lint:                    %{lint}   
   _t_ ^ ^ ➜ Treesitter context:      %{treesitter_context}   

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
    { "a", autopairs_toggle },
    { "f", format_on_save_toggle },
    { "g", github_copilot_toggle },
    { "l", lint_toggle },
    { "t", treesitter_context_toggle },

    { "<Esc>", nil, { exit = true, desc = false } },
  },
}
