-- Here are defined custom actions for Telescope, used through general or spicker-specific mappings.

local actions = require("telescope.actions")
local actions_state = require("telescope.actions.state")
local builtin = require("telescope.builtin")
local custom_make_entry = require("plugins.core.telescope.make_entry")
local previewers = require("telescope.previewers")

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

function M.find_files.toggle_hidden(prompt_bufnr, _)
  local opts = vim.g.telescope_last_opts

  -- Switch the custom options & persist them
  opts._hidden = not opts._hidden
  opts._hidden_and_ignored = false
  vim.g.telescope_last_opts = opts

  -- Compute not persisted options
  local current_picker = actions_state.get_current_picker(prompt_bufnr)
  opts.default_text = current_picker:_get_prompt()
  actions.close(prompt_bufnr)
  if opts.prompt_title:sub(1, 16) == "Find Directories" then
    -- previwers.vim_buffer_cat can't be saved to state so let's work around this
    opts.previewer = previewers.vim_buffer_cat.new({})
    -- To support directory icons, use a custom entry maker (which needs to have accessed to the picker options)
    opts.entry_maker = custom_make_entry.gen_from_dir(opts)
  end
  if opts._hidden then
    local find_command = vim.list_extend({}, opts.find_command) -- Don't modify the original command
    opts.find_command = vim.list_extend(find_command, { "--hidden" })
    opts.prompt_title = opts.prompt_title .. " (w/ hidden)"
  end

  builtin.find_files(opts)
end

function M.find_files.toggle_all(prompt_bufnr, _)
  local opts = vim.g.telescope_last_opts

  -- Switch the custom options & persist them
  opts._hidden = false
  opts._hidden_and_ignored = not opts._hidden_and_ignored
  vim.g.telescope_last_opts = opts

  -- Compute not persisted options
  local current_picker = actions_state.get_current_picker(prompt_bufnr)
  opts.default_text = current_picker:_get_prompt()
  actions.close(prompt_bufnr)
  if opts.prompt_title:sub(1, 16) == "Find Directories" then
    -- previwers.vim_buffer_cat can't be saved to state so let's work around this
    opts.previewer = previewers.vim_buffer_cat.new({})
    -- To support directory icons, use a custom entry maker (which needs to have accessed to the picker options)
    opts.entry_maker = custom_make_entry.gen_from_dir(opts)
  end
  if opts._hidden_and_ignored then
    local find_command = vim.list_extend({}, opts.find_command) -- Don't modify the original command
    opts.find_command = vim.list_extend(find_command, { "--hidden", "--no-ignore" })
    opts.prompt_title = opts.prompt_title .. " (all)"
  end

  builtin.find_files(opts)
end

M.live_grep = {}

function M.live_grep.toggle_hidden(prompt_bufnr, _)
  local opts = vim.g.telescope_last_opts

  -- Switch the custom options & persist them
  opts._hidden = not opts._hidden
  opts._hidden_and_ignored = false
  vim.g.telescope_last_opts = opts

  -- Compute not persisted options
  local current_picker = actions_state.get_current_picker(prompt_bufnr)
  opts.default_text = current_picker:_get_prompt()
  actions.close(prompt_bufnr)
  if opts._hidden then
    opts.additional_args = { "--hidden" }
    opts.prompt_title = opts.prompt_title .. " (w/ hidden)"
  end

  builtin.live_grep(opts)
end

function M.live_grep.toggle_all(prompt_bufnr, _)
  local opts = vim.g.telescope_last_opts

  -- Switch the custom options & persist them
  opts._hidden = false
  opts._hidden_and_ignored = not opts._hidden_and_ignored
  vim.g.telescope_last_opts = opts

  -- Compute not persisted options
  local current_picker = actions_state.get_current_picker(prompt_bufnr)
  opts.default_text = current_picker:_get_prompt()
  actions.close(prompt_bufnr)
  if opts._hidden_and_ignored then
    opts.additional_args = { "--hidden", "--no-ignore" }
    opts.prompt_title = opts.prompt_title .. " (w/ all)"
  end

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
