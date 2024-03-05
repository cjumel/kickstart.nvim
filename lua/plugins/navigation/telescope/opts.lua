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

return M
