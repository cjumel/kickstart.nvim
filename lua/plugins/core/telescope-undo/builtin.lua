local M = {}

function M.find_undotree()
  local visual_mode = require("visual_mode")

  local opts = {
    prompt_title = "Find Undotree",
    layout_config = { preview_width = 0.6 },
    tiebreak = function(current, existing, _) return current.index < existing.index end, -- Sort by recency
  }
  if visual_mode.is_on() then
    opts.default_text = visual_mode.get_text()
  end

  require("telescope").extensions.undo.undo(opts)
end

return M
