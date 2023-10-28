local M = {}

M.get_small_dropdown = function(initial_mode)
  return require("telescope.themes").get_dropdown({
    initial_mode = initial_mode or "insert",
    winblend = 10,
    layout_config = {
      width = 0.7,
    },
  })
end

M.get_commands_dropdown = function()
  local opts = M.get_small_dropdown()

  -- Simplify the display of commands with only name & description
  local displayer = require("telescope.pickers.entry_display").create({
    separator = "▏",
    items = {
      { width = 0.33 },
      { remaining = true },
    },
  })
  local make_display = function(entry)
    return displayer({
      { entry.name, "TelescopeResultsIdentifier" },
      entry.definition,
    })
  end
  local entry_maker = function(entry)
    return {
      name = entry.name,
      bang = entry.bang,
      nargs = entry.nargs,
      complete = entry.complete,
      definition = entry.definition,
      --
      value = entry,
      valid = true,
      ordinal = entry.name,
      display = make_display,
    }
  end
  opts.entry_maker = entry_maker

  return opts
end

M.get_large_dropdown = function(initial_mode)
  return require("telescope.themes").get_dropdown({
    initial_mode = initial_mode or "insert",
    layout_config = {
      anchor = "N", -- Anchor to the top of the screen
      width = 0.8,
    },
  })
end

return M
