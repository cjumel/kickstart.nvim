-- The settings Hydra provides a simple interface to view and change Neovim-level settings.

local buffer = require("buffer")

local function context_header_display()
  if vim.g.context_header_mode == "on" then
    return "[on] /  off "
  else
    return " on  / [off]"
  end
end

local function context_header_switch_next()
  if vim.g.context_header_mode == "on" then
    vim.g.context_header_mode = "off"
  else
    vim.g.context_header_mode = "on"
  end

  local treesitter_context = package.loaded["treesitter-context"]
  if treesitter_context ~= nil then
    if vim.g.context_header_mode == "on" then
      treesitter_context.enable()
    else
      treesitter_context.disable()
    end
  end
end
local context_header_switch_prev = context_header_switch_next

local function format_on_save_display()
  if vim.g.format_on_save_mode == "on" then
    return "[on] /  auto  /  off "
  elseif vim.g.format_on_save_mode == "auto" then
    return " on  / [auto] /  off "
  else
    return " on  /  auto  / [off]"
  end
end

local function format_on_save_switch_next()
  if vim.g.format_on_save_mode == "on" then
    vim.g.format_on_save_mode = "auto"
  elseif vim.g.format_on_save_mode == "auto" then
    vim.g.format_on_save_mode = "off"
  else
    vim.g.format_on_save_mode = "on"
  end
end
local function format_on_save_switch_prev()
  if vim.g.format_on_save_mode == "on" then
    vim.g.format_on_save_mode = "off"
  elseif vim.g.format_on_save_mode == "off" then
    vim.g.format_on_save_mode = "auto"
  else
    vim.g.format_on_save_mode = "on"
  end
end

local function lint_display()
  if vim.g.lint_mode == "on" then
    return "[on] /  auto  /  off "
  elseif vim.g.lint_mode == "auto" then
    return " on  / [auto] /  off "
  else
    return " on  /  auto  / [off]"
  end
end

local function lint_switch_next()
  if vim.g.lint_mode == "on" then
    vim.g.lint_mode = "auto"
  elseif vim.g.lint_mode == "auto" then
    vim.g.lint_mode = "off"
  else
    vim.g.lint_mode = "on"
  end

  local lint = package.loaded["lint"]
  if lint ~= nil then
    if vim.g.lint_mode == "off" then
      vim.diagnostic.reset() -- Remove existing diagnostics
    end
  end
end
local function lint_switch_prev()
  if vim.g.lint_mode == "on" then
    vim.g.lint_mode = "off"
  elseif vim.g.lint_mode == "off" then
    vim.g.lint_mode = "auto"
  else
    vim.g.lint_mode = "on"
  end

  local lint = package.loaded["lint"]
  if lint ~= nil then
    if vim.g.lint_mode == "off" then
      vim.diagnostic.reset() -- Remove existing diagnostics
    end
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

local function ruler_column_display()
  if vim.g.ruler_column_mode == "88" then
    return "[88] /  100  /  120  /  140  /  auto  /  off "
  elseif vim.g.ruler_column_mode == "100" then
    return " 88  / [100] /  120  /  140  /  auto  /  off "
  elseif vim.g.ruler_column_mode == "120" then
    return " 88  /  100  / [120] /  140  /  auto  /  off "
  elseif vim.g.ruler_column_mode == "140" then
    return " 88  /  100  /  120  / [140] /  auto  /  off "
  elseif vim.g.ruler_column_mode == "auto" then
    return " 88  /  100  /  120  /  140  / [auto] /  off "
  else
    return " 88  /  100  /  120  /  140  /  auto  / [off]"
  end
end

local function ruler_column_switch_next()
  if vim.g.ruler_column_mode == "88" then
    vim.g.ruler_column_mode = "100"
  elseif vim.g.ruler_column_mode == "100" then
    vim.g.ruler_column_mode = "120"
  elseif vim.g.ruler_column_mode == "120" then
    vim.g.ruler_column_mode = "140"
  elseif vim.g.ruler_column_mode == "140" then
    vim.g.ruler_column_mode = "auto"
  elseif vim.g.ruler_column_mode == "auto" then
    vim.g.ruler_column_mode = "off"
  else
    vim.g.ruler_column_mode = "88"
  end

  if vim.g.ruler_column_mode == "auto" or vim.g.ruler_column_mode == "off" then
    vim.opt.colorcolumn = "" -- No colorcolumn (for "auto", ftplugins will change it)
  else
    vim.opt.colorcolumn = vim.g.ruler_column_mode
  end
  if not buffer.is_temporary() then
    vim.cmd("edit") -- Reload the current buffer to apply the new colorcolumn setting
  end
end
local function ruler_column_switch_prev()
  if vim.g.ruler_column_mode == "off" then
    vim.g.ruler_column_mode = "auto"
  elseif vim.g.ruler_column_mode == "auto" then
    vim.g.ruler_column_mode = "140"
  elseif vim.g.ruler_column_mode == "140" then
    vim.g.ruler_column_mode = "120"
  elseif vim.g.ruler_column_mode == "120" then
    vim.g.ruler_column_mode = "100"
  elseif vim.g.ruler_column_mode == "100" then
    vim.g.ruler_column_mode = "88"
  else
    vim.g.ruler_column_mode = "off"
  end

  if vim.g.ruler_column_mode == "auto" or vim.g.ruler_column_mode == "off" then
    vim.opt.colorcolumn = "" -- No colorcolumn (for "auto", ftplugins will change it)
  else
    vim.opt.colorcolumn = vim.g.ruler_column_mode
  end
  if not buffer.is_temporary() then
    vim.cmd("edit") -- Reload the current buffer to apply the new colorcolumn setting
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

return {
  body = "<leader>,",
  config = {
    desc = "Settings Hydra",
    hint = {
      position = "middle",
      funcs = {
        context_header = context_header_display,
        format_on_save = format_on_save_display,
        lint = lint_display,
        number_column = number_column_display,
        ruler_column = ruler_column_display,
        sign_column = sign_column_display,
      },
    },
  },
  -- The way the settings Hydra is centered is determined empirically through the number of white spaces, as the
  --  content of the Hydra body depends on the above functions
  hint = [[
                                  Settings Hydra                         

   _c_/_C_ ➜ Context header:          %{context_header}   
   _f_/_F_ ➜ Format on save:          %{format_on_save}   
   _l_/_L_ ➜ Lint:                    %{lint}   
   _n_/_N_ ➜ Number column:           %{number_column}   
   _r_/_R_ ➜ Ruler column:            %{ruler_column}   
   _s_/_S_ ➜ Sign column:             %{sign_column}   

]],
  heads = {
    { "c", context_header_switch_next },
    { "C", context_header_switch_prev },
    { "f", format_on_save_switch_next },
    { "F", format_on_save_switch_prev },
    { "l", lint_switch_next },
    { "L", lint_switch_prev },
    { "n", number_column_switch_next },
    { "N", number_column_switch_prev },
    { "r", ruler_column_switch_next },
    { "R", ruler_column_switch_prev },
    { "s", sign_column_switch_next },
    { "S", sign_column_switch_prev },
    { "<Esc>", nil, { exit = true, desc = false } },
  },
}
