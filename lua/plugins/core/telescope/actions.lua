-- Custom actions for Telescope, to be used within pickers.

local M = {}

function M.smart_open_loclist(prompt_bufnr, _mode)
  require("telescope.actions").smart_send_to_loclist(prompt_bufnr, _mode)
  require("trouble").open("loclist")
end

function M.smart_open_quickfix(prompt_bufnr, _mode)
  require("telescope.actions").smart_send_to_qflist(prompt_bufnr, _mode)
  require("trouble").open("qflist")
end

function M.copy_commit_hash(prompt_bufnr)
  local selection = require("telescope.actions.state").get_selected_entry()
  require("telescope.actions").close(prompt_bufnr)

  -- Directly copy to clipboard, as most of the times the output will be used using the Git CLI
  vim.fn.setreg("+", selection.value)
  vim.notify('Commit hash "' .. selection.value .. '" copied to clipboard')
end

return M
