local M = {}

-- Define custom action for Trouble to make it lazy-loaded
M.smart_open_with_trouble = function(prompt_bufnr, _mode)
  local trouble_actions = require("trouble.providers.telescope")
  trouble_actions.smart_open_with_trouble(prompt_bufnr, _mode)
end

-- Define custom action to open quickfix list with Trouble while keeping it lazy-loaded
M.smart_send_to_qflist = function(prompt_bufnr, _mode)
  local actions = require("telescope.actions")
  local trouble = require("trouble")
  actions.smart_send_to_qflist(prompt_bufnr, _mode)
  trouble.open("quickfix")
end

-- Define custom action to open location list with Trouble while keeping it lazy-loaded
M.smart_send_to_loclist = function(prompt_bufnr, _mode)
  local actions = require("telescope.actions")
  local trouble = require("trouble")
  actions.smart_send_to_loclist(prompt_bufnr, _mode)
  trouble.open("loclist")
end

return M
