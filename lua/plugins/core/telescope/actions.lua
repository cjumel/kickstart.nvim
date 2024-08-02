-- Here are defined custom actions for Telescope, used through general or spicker-specific mappings.

local M = {}

function M.smart_open_loclist(prompt_bufnr, _mode)
  local telescope_actions = require("telescope.actions")
  local trouble = require("trouble") -- Lazy loaded thanks to function wrapping
  telescope_actions.smart_send_to_loclist(prompt_bufnr, _mode)
  trouble.open("loclist")
end

function M.smart_open_quickfix(prompt_bufnr, _mode)
  local telescope_actions = require("telescope.actions")
  local trouble = require("trouble") -- Lazy loaded thanks to function wrapping
  telescope_actions.smart_send_to_qflist(prompt_bufnr, _mode)
  trouble.open("quickfix")
end

return M
