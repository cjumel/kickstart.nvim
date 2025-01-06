local M = {}

--- Custom version of the `yank_additions` action, where we always yank the additions in line-wise mode.
--- See `lua/telescope-undo/actions.lua` in the telescope-undo.nvim repository for the initial implementation.
---@param prompt_bufnr integer The buffer number of the prompt buffer.
---@return function
M.yank_additions = function(prompt_bufnr)
  return function()
    local actions = require("telescope.actions")
    local actions_state = require("telescope.actions.state")

    -- yanks the additions from the currently selected undo state into the default register
    local entry = actions_state.get_selected_entry()
    if entry ~= nil then
      vim.fn.setreg('"', entry.value.additions, "V")
      vim.notify("Yanked additions:\n" .. table.concat(entry.value.additions, "\n"))
      actions.close(prompt_bufnr)
      return entry.value.additions
    end
  end
end

--- Custom version of the `yank_deletions` action, where we always yank the deletions in line-wise mode.
--- See `lua/telescope-undo/actions.lua` in the telescope-undo.nvim repository for the initial implementation.
---@param prompt_bufnr integer The buffer number of the prompt buffer.
---@return function
M.yank_deletions = function(prompt_bufnr)
  return function()
    local actions = require("telescope.actions")
    local actions_state = require("telescope.actions.state")

    -- yanks the deletions from the currently selected undo state into the default register
    local entry = actions_state.get_selected_entry()
    if entry ~= nil then
      vim.fn.setreg('"', entry.value.deletions, "V")
      vim.notify("Yanked deletions:\n" .. table.concat(entry.value.deletions, "\n"))
      actions.close(prompt_bufnr)
      return entry.value.deletions
    end
  end
end

return M
