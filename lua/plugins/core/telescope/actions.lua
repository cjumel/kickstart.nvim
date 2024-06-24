-- Here are defined custom actions for Telescope, used through general or spicker-specific mappings.

local actions = require("telescope.actions")
local actions_state = require("telescope.actions.state")
local builtin = require("telescope.builtin")
local custom_builtin = require("plugins.core.telescope.builtin")

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

M.find_files = {}

function M.find_files.toggle_all(prompt_bufnr, _)
  -- Persisted options
  local opts = vim.g.telescope_last_opts
  opts._all = not opts._all
  vim.g.telescope_last_opts = opts

  -- Not persisted options
  opts = custom_builtin.finalize_opts_find_files(opts)
  local current_picker = actions_state.get_current_picker(prompt_bufnr)
  opts.default_text = current_picker:_get_prompt()
  actions.close(prompt_bufnr)

  builtin.find_files(opts)
end

M.live_grep = {}

function M.live_grep.toggle_all(prompt_bufnr, _)
  -- Persisted options
  local opts = vim.g.telescope_last_opts
  opts._all = not opts._all
  vim.g.telescope_last_opts = opts

  -- Not persisted options
  opts = custom_builtin.finalize_opts_live_grep(opts)
  local current_picker = actions_state.get_current_picker(prompt_bufnr)
  opts.default_text = current_picker:_get_prompt()
  actions.close(prompt_bufnr)

  builtin.live_grep(opts)
end

M.lsp_document_symbols = {}

function M.lsp_document_symbols.switch_to_lsp_dynamic_workspace_symbols(prompt_bufnr, _)
  local opts = {}

  -- Compute not persisted options
  local current_picker = actions_state.get_current_picker(prompt_bufnr)
  opts.default_text = current_picker:_get_prompt()
  actions.close(prompt_bufnr)

  builtin.lsp_dynamic_workspace_symbols(opts)
end

M.lsp_dynamic_workspace_symbols = {}

function M.lsp_dynamic_workspace_symbols.switch_to_lsp_document_symbols(prompt_bufnr, _)
  local opts = {}

  -- Compute not persisted options
  local current_picker = actions_state.get_current_picker(prompt_bufnr)
  opts.default_text = current_picker:_get_prompt()
  actions.close(prompt_bufnr)

  builtin.lsp_document_symbols(opts)
end

return M
