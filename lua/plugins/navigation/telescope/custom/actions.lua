local M = {}

-- Code taken from https://gist.github.com/benlubas/09254459af633cce1b5ac12d16640f0e
M.add_harpoon_mark_from_telescope = function(tb)
  local telescope_utils = require("telescope.actions.utils")
  local actions = require("telescope.actions")

  actions.drop_all(tb)
  actions.add_selection(tb)
  telescope_utils.map_selections(tb, function(selection)
    local file = selection[1]

    -- This lets it work with live grep picker
    if selection.filename then
      file = selection.filename
    end

    -- this lets it work with git status picker
    if selection.value then
      file = selection.value
    end

    require("plugins.navigation.harpoon.custom.actions").add_mark(file)
  end)
  actions.remove_selection(tb)
end

return M
