local utils = require("utils")

local M = {}

M.dropdown = {
  previewer = false,
  layout_config = {
    width = 0.7,
  },
}

-- Tiebreak function determining how to sort Telescope entries with equal match with the prompt
-- by recency. Using this makes sure entries stay sorted by recency when entering a prompt.
M.recency_tiebreak = function(current_entry, existing_entry, _)
  return current_entry.index < existing_entry.index
end

-- Filter function for command history to discard short commands like "w", "q", "wq", "wqa", etc.
M.command_history_filter_fn = function(cmd)
  if string.len(cmd) < 4 then
    return false
  end
  return true
end

local default_find_command = { -- Default command for fd in telescope implementation
  "fd",
  "--type",
  "f",
  "--color",
  "never",
}

M.find_files = {
  find_command = default_find_command,
  preview = { hide_on_startup = true },
}
M.find_files_hidden = {
  find_command = utils.table.concat_arrays({
    default_find_command,
    {
      "--hidden",
      "--exclude",
      ".git",
    },
  }),
  preview = { hide_on_startup = true },
}
M.find_files_all = {
  find_command = utils.table.concat_arrays({
    default_find_command,
    {
      "--hidden",
      "--exclude",
      ".git",
      "--no-ignore",
    },
  }),
  preview = { hide_on_startup = true },
}

M.live_grep = {}
M.live_grep_unrestricted = { additional_args = { "-uu" } }
M.grep_string = {}
M.grep_string_unrestricted = { additional_args = { "-uu" } }

return M
