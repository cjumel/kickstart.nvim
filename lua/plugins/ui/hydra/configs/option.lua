-- The option Hydra provides a simple interface to view and change Neovim-level settings.

local utils = require("utils")

-- [[ Neovim options ]]

local function color_column_display()
  if vim.g.color_column_mode == "auto" then
    return "[auto] /  88   /  100  /  120  /  140  /  off "
  elseif vim.g.color_column_mode == "88" then
    return " auto  / [88]  /  100  /  120  /  140  /  off "
  elseif vim.g.color_column_mode == "100" then
    return " auto  /  88   / [100] /  120  /  140  /  off "
  elseif vim.g.color_column_mode == "120" then
    return " auto  /  88   /  100  / [120] /  140  /  off "
  elseif vim.g.color_column_mode == "140" then
    return " auto  /  88   /  100  /  120  / [140] /  off "
  else
    return " auto  /  88   /  100  /  120  /  140  / [off]"
  end
end
local function color_column_switch_next()
  if vim.g.color_column_mode == "auto" then
    vim.g.color_column_mode = "88"
  elseif vim.g.color_column_mode == "88" then
    vim.g.color_column_mode = "100"
  elseif vim.g.color_column_mode == "100" then
    vim.g.color_column_mode = "120"
  elseif vim.g.color_column_mode == "120" then
    vim.g.color_column_mode = "140"
  elseif vim.g.color_column_mode == "140" then
    vim.g.color_column_mode = "off"
  else
    vim.g.color_column_mode = "auto"
  end

  if vim.g.color_column_mode == "auto" or vim.g.color_column_mode == "off" then
    vim.opt.colorcolumn = "" -- No colorcolumn (for "auto", ftplugins will change it)
  else
    vim.opt.colorcolumn = vim.g.color_column_mode
  end
  if not utils.buffer.is_temporary() then
    vim.cmd("edit") -- Reload the current buffer to apply the new colorcolumn setting
  end
end
local function color_column_switch_prev()
  if vim.g.color_column_mode == "auto" then
    vim.g.color_column_mode = "off"
  elseif vim.g.color_column_mode == "off" then
    vim.g.color_column_mode = "140"
  elseif vim.g.color_column_mode == "140" then
    vim.g.color_column_mode = "120"
  elseif vim.g.color_column_mode == "120" then
    vim.g.color_column_mode = "100"
  elseif vim.g.color_column_mode == "100" then
    vim.g.color_column_mode = "88"
  else
    vim.g.color_column_mode = "auto"
  end

  if vim.g.color_column_mode == "auto" or vim.g.color_column_mode == "off" then
    vim.opt.colorcolumn = "" -- No colorcolumn (for "auto", ftplugins will change it)
  else
    vim.opt.colorcolumn = vim.g.color_column_mode
  end
  if not utils.buffer.is_temporary() then
    vim.cmd("edit") -- Reload the current buffer to apply the new colorcolumn setting
  end
end

local function number_column_display()
  if vim.g.number_column_mode == "absolute" then
    return "[abs] /  rel  /  off "
  elseif vim.g.number_column_mode == "relative" then
    return " abs  / [rel] /  off "
  else
    return " abs  /  rel  / [off]"
  end
end
local function number_column_switch_next()
  if vim.g.number_column_mode == "absolute" then
    vim.g.number_column_mode = "relative"
  elseif vim.g.number_column_mode == "relative" then
    vim.g.number_column_mode = "off"
  else
    vim.g.number_column_mode = "absolute"
  end

  if vim.g.number_column_mode == "absolute" then
    vim.wo.number = true
    vim.wo.relativenumber = false
  elseif vim.g.number_column_mode == "relative" then
    vim.wo.number = true
    vim.wo.relativenumber = true
  else
    vim.wo.number = false
    vim.wo.relativenumber = false
  end
end
local function number_column_switch_prev()
  if vim.g.number_column_mode == "absolute" then
    vim.g.number_column_mode = "off"
  elseif vim.g.number_column_mode == "off" then
    vim.g.number_column_mode = "relative"
  else
    vim.g.number_column_mode = "absolute"
  end

  if vim.g.number_column_mode == "absolute" then
    vim.wo.number = true
    vim.wo.relativenumber = false
  elseif vim.g.number_column_mode == "relative" then
    vim.wo.number = true
    vim.wo.relativenumber = true
  else
    vim.wo.number = false
    vim.wo.relativenumber = false
  end
end

local function concealing_display()
  if vim.g.concealing_mode == "auto" then
    return "[auto] /  on   /  off "
  elseif vim.g.concealing_mode == "on" then
    return " auto  / [on]  /  off "
  else
    return " auto  /  on   / [off]"
  end
end
local function concealing_switch_next()
  if vim.g.concealing_mode == "auto" then
    vim.g.concealing_mode = "on"
  elseif vim.g.concealing_mode == "on" then
    vim.g.concealing_mode = "off"
  else
    vim.g.concealing_mode = "auto"
  end

  if vim.g.concealing_mode == "auto" or vim.g.concealing_mode == "off" then
    vim.opt.conceallevel = 0 -- No concealing (for "auto", ftplugins will change it)
  else
    vim.opt.conceallevel = 2
  end
  if not utils.buffer.is_temporary() then
    vim.cmd("edit") -- Reload the current buffer to apply the conceal level setting
  end
end
local function concealing_switch_prev()
  if vim.g.concealing_mode == "auto" then
    vim.g.concealing_mode = "off"
  elseif vim.g.concealing_mode == "off" then
    vim.g.concealing_mode = "on"
  else
    vim.g.concealing_mode = "auto"
  end

  if vim.g.concealing_mode == "auto" or vim.g.concealing_mode == "off" then
    vim.opt.conceallevel = 0 -- No concealing (for "auto", ftplugins will change it)
  else
    vim.opt.conceallevel = 2
  end
  if not utils.buffer.is_temporary() then
    vim.cmd("edit") -- Reload the current buffer to apply the conceal level setting
  end
end

local function sign_column_display()
  if vim.g.sign_column_mode == "number" then
    return "[num] /  yes  /  off "
  elseif vim.g.sign_column_mode == "yes" then
    return " num  / [yes] /  off "
  else
    return " num  /  yes  / [off]"
  end
end
local function sign_column_switch_next()
  if vim.g.sign_column_mode == "number" then
    vim.g.sign_column_mode = "yes"
  elseif vim.g.sign_column_mode == "yes" then
    vim.g.sign_column_mode = "off"
  else
    vim.g.sign_column_mode = "number"
  end

  if vim.g.sign_column_mode == "off" then
    vim.wo.signcolumn = "no"
  else
    vim.wo.signcolumn = vim.g.sign_column_mode
  end
end
local function sign_column_switch_prev()
  if vim.g.sign_column_mode == "number" then
    vim.g.sign_column_mode = "off"
  elseif vim.g.sign_column_mode == "off" then
    vim.g.sign_column_mode = "yes"
  else
    vim.g.sign_column_mode = "number"
  end

  if vim.g.sign_column_mode == "off" then
    vim.wo.signcolumn = "no"
  else
    vim.wo.signcolumn = vim.g.sign_column_mode
  end
end

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
        -- Neovim options
        color_column = color_column_display,
        number_column = number_column_display,
        concealing = concealing_display,
        sign_column = sign_column_display,
        -- Plugin options
        autopairs = autopairs_display,
        format_on_save = format_on_save_display,
        github_copilot = github_copilot_display,
        lint = lint_display,
        treesitter_context = treesitter_context_display,
      },
    },
  },
  -- The way "Option Hydra" is centered is determined empirically, as the content of the Hydra body depends on functions
  hint = [[
                                   Option Hydra                          

   Neovim options   
   _c_/_C_ ➜ Color column:            %{color_column}   
   _n_/_N_ ➜ Number column:           %{number_column}   
   _o_/_O_ ➜ Concealing:              %{concealing}   
   _s_/_S_ ➜ Sign column:             %{sign_column}   

   Plugin options   
   _a_ ^ ^ ➜ Auto-pairs:              %{autopairs}   
   _f_ ^ ^ ➜ Format on save:          %{format_on_save}   
   _g_ ^ ^ ➜ GitHub copilot:          %{github_copilot}   
   _l_ ^ ^ ➜ Lint:                    %{lint}   
   _t_ ^ ^ ➜ Treesitter context:      %{treesitter_context}   

]],
  heads = {
    -- Neovim options
    { "c", color_column_switch_next },
    { "C", color_column_switch_prev },
    { "n", number_column_switch_next },
    { "N", number_column_switch_prev },
    { "o", concealing_switch_next },
    { "O", concealing_switch_prev },
    { "s", sign_column_switch_next },
    { "S", sign_column_switch_prev },
    -- Plugin options
    { "a", autopairs_toggle },
    { "f", format_on_save_toggle },
    { "g", github_copilot_toggle },
    { "l", lint_toggle },
    { "t", treesitter_context_toggle },
    -- Other
    { "<Esc>", nil, { exit = true, desc = false } },
  },
}
