local M = {}

M.get_dropdown = function(initial_mode)
  return require("telescope.themes").get_dropdown({
    initial_mode = initial_mode or "insert",
    previewer = false,
    layout_config = {
      width = 0.7,
    },
  })
end

return M
