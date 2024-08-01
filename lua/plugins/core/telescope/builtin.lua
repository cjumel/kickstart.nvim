-- Here are defined custom wrappers around Telescope builtin pickers. It is where I implement custom options or logic
-- for each picker I use & want to customize.

local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")
local custom_make_entry = require("plugins.core.telescope.make_entry")
local custom_utils = require("utils")
local previewers = require("telescope.previewers")
local themes = require("telescope.themes")

local M = {}

--- Finalize the options for the `find_files` picker. This function adds all the relevant not-persisted options to
--- the persisted ones.
---@param opts table The persisted options.
---@return table _ The finalized options.
local function find_files_finalize_opts(opts)
  if not opts._include_all_files then
    opts.prompt_title = "Find Files"
    opts.find_command = { "fd", "--type", "f", "--color", "never", "--hidden" }
  else
    opts.prompt_title = "Find Files (all)"
    opts.find_command = { "fd", "--type", "f", "--color", "never", "--hidden", "--no-ignore" }
  end

  if opts.cwd then
    opts.prompt_title = opts.prompt_title .. " - " .. custom_utils.path.normalize(opts.cwd)
  end

  return opts
end

--- Get the base options for the `find_files` picker.
---@return table _ The `find_files` base options.
local function find_files_get_base_opts()
  local function toggle_all_files(prompt_bufnr, _)
    -- Persisted options
    local opts = vim.g.telescope_last_opts
    opts._include_all_files = not opts._include_all_files
    vim.g.telescope_last_opts = opts

    -- Not persisted options
    opts = find_files_finalize_opts(opts)
    local current_picker = action_state.get_current_picker(prompt_bufnr)
    opts.default_text = current_picker:_get_prompt()
    actions.close(prompt_bufnr)

    builtin.find_files(opts)
  end

  local opts = {
    preview = { hide_on_startup = true },
    attach_mappings = function(_, map)
      map({ "i", "n" }, "<C-\\>", toggle_all_files)
      return true -- Enable default mappings
    end,
    _include_all_files = false,
  }

  if custom_utils.visual.is_visual_mode() then
    local text = custom_utils.visual.get_text()
    -- Replace punctuation marks by spaces, to support searching from module names, like "plugins.core"
    opts.default_text = string.gsub(text, "%p", " ")
  end

  return opts
end

function M.find_files()
  local opts = find_files_get_base_opts()
  vim.g.telescope_last_opts = opts -- Persist the options dynamically change them later on

  opts = find_files_finalize_opts(opts)
  builtin.find_files(opts)
end

function M.find_files_oil_directory()
  local opts = find_files_get_base_opts()
  if vim.bo.filetype == "oil" then
    opts.cwd = package.loaded.oil.get_current_dir()
  else
    error("The current buffer is not an Oil buffer.")
  end
  vim.g.telescope_last_opts = opts -- Persist the options dynamically change them later on

  opts = find_files_finalize_opts(opts)
  builtin.find_files(opts)
end

--- Finalize the options for the `find_directories` custom picker. This function adds all the relevant not-persisted
--- options to the persisted ones.
---@param opts table The persisted options.
---@return table _ The finalized options.
local function find_directories_finalize_opts(opts)
  if not opts._include_all_files then
    opts.prompt_title = "Find Directories"
    opts.find_command = { "fd", "--type", "d", "--color", "never", "--hidden" }
    -- previwers.vim_buffer_cat can't be saved to state so let's work around this
    opts.previewer = previewers.vim_buffer_cat.new({})
    -- To support directory icons, use a custom entry maker (which needs to have accessed to the picker options)
    opts.entry_maker = custom_make_entry.gen_from_dir(opts)
  else
    opts.prompt_title = "Find Directories (all)"
    opts.find_command = { "fd", "--type", "d", "--color", "never", "--hidden", "--no-ignore" }
    -- previwers.vim_buffer_cat can't be saved to state so let's work around this
    opts.previewer = previewers.vim_buffer_cat.new({})
    -- To support directory icons, use a custom entry maker (which needs to have accessed to the picker options)
    opts.entry_maker = custom_make_entry.gen_from_dir(opts)
  end

  if opts.cwd then
    opts.prompt_title = opts.prompt_title .. " - " .. custom_utils.path.normalize(opts.cwd)
  end

  return opts
end

--- Get the base options for the `find_directories` custom picker.
---@return table _ The `find_directories` base options.
local function find_directories_get_base_opts()
  local function toggle_all_files(prompt_bufnr, _)
    -- Persisted options
    local opts = vim.g.telescope_last_opts
    opts._include_all_files = not opts._include_all_files
    vim.g.telescope_last_opts = opts

    -- Not persisted options
    opts = find_directories_finalize_opts(opts)
    local current_picker = action_state.get_current_picker(prompt_bufnr)
    opts.default_text = current_picker:_get_prompt()
    actions.close(prompt_bufnr)

    builtin.find_files(opts)
  end

  local opts = {
    preview = { hide_on_startup = true },
    attach_mappings = function(_, map)
      map({ "i", "n" }, "<C-\\>", toggle_all_files)
      return true -- Enable default mappings
    end,
    _include_all_files = false,
  }

  if custom_utils.visual.is_visual_mode() then
    local text = custom_utils.visual.get_text()
    -- Replace punctuation marks by spaces, to support searching from module names, like "plugins.core"
    opts.default_text = string.gsub(text, "%p", " ")
  end

  return opts
end

function M.find_directories()
  local opts = find_directories_get_base_opts()
  vim.g.telescope_last_opts = opts -- Persist the options dynamically change them later on

  opts = find_directories_finalize_opts(opts)
  builtin.find_files(opts)
end

function M.find_directories_oil_directory()
  local opts = find_directories_get_base_opts()
  if vim.bo.filetype == "oil" then
    opts.cwd = package.loaded.oil.get_current_dir()
  else
    error("The current buffer is not an Oil buffer.")
  end
  vim.g.telescope_last_opts = opts -- Persist the options dynamically change them later on

  opts = find_directories_finalize_opts(opts)
  builtin.find_files(opts)
end

--- Finalize the options for the `live_grep` picker. This function adds all the relevant not-persisted options to the
--- persisted ones.
---@param opts table The persisted options.
---@return table _ The finalized options.
local function live_grep_finalize_opts(opts)
  if not opts._include_all_files then
    opts.prompt_title = "Find by Grep"
    opts.additional_args = { "--hidden" }
  else
    opts.prompt_title = "Find by Grep (all)"
    opts.additional_args = { "--hidden", "--no-ignore" }
  end

  if opts.cwd then
    opts.prompt_title = opts.prompt_title .. " - " .. custom_utils.path.normalize(opts.cwd)
  end

  return opts
end

--- Get the base options for the `live_grep` picker.
---@return table _ The `live_grep` base options.
local function live_grep_get_base_opts()
  local function toggle_all_files(prompt_bufnr, _)
    -- Persisted options
    local opts = vim.g.telescope_last_opts
    opts._include_all_files = not opts._include_all_files
    vim.g.telescope_last_opts = opts

    -- Not persisted options
    opts = live_grep_finalize_opts(opts)
    local current_picker = action_state.get_current_picker(prompt_bufnr)
    opts.default_text = current_picker:_get_prompt()
    actions.close(prompt_bufnr)

    builtin.live_grep(opts)
  end

  local opts = {
    attach_mappings = function(_, map)
      map({ "i", "n" }, "<C-\\>", toggle_all_files)
      return true -- Enable default mappings
    end,
    _include_all_files = false,
  }

  if custom_utils.visual.is_visual_mode() then
    opts.default_text = custom_utils.visual.get_text()
  end

  return opts
end

function M.live_grep()
  local opts = live_grep_get_base_opts()
  vim.g.telescope_last_opts = opts -- Persist the options dynamically change them later on

  opts = live_grep_finalize_opts(opts)
  builtin.live_grep(opts)
end

function M.live_grep_oil_directory()
  local opts = live_grep_get_base_opts()
  if vim.bo.filetype == "oil" then
    opts.cwd = package.loaded.oil.get_current_dir()
  else
    error("The current buffer is not an Oil buffer.")
  end
  vim.g.telescope_last_opts = opts -- Persist the options dynamically change them later on

  opts = live_grep_finalize_opts(opts)
  builtin.live_grep(opts)
end

function M.oldfiles()
  local opts = {
    preview = { hide_on_startup = true },
    tiebreak = function(current, existing, _) return current.index < existing.index end, -- Sort entries by recency
    prompt_title = "Find OldFiles",
  }

  if custom_utils.visual.is_visual_mode() then
    local text = custom_utils.visual.get_text()
    -- Replace punctuation marks by spaces, to support searching from module names, like "plugins.core"
    opts.default_text = string.gsub(text, "%p", " ")
  end

  builtin.oldfiles(opts)
end

function M.current_buffer()
  local opts = {}

  if custom_utils.visual.is_visual_mode() then
    opts.default_text = custom_utils.visual.get_text()
  end

  builtin.current_buffer_fuzzy_find(opts)
end

function M.help_tags()
  local opts = {}

  if custom_utils.visual.is_visual_mode() then
    opts.default_text = custom_utils.visual.get_text()
  end

  builtin.help_tags(opts)
end

function M.man_pages()
  local opts = {}

  if custom_utils.visual.is_visual_mode() then
    opts.default_text = custom_utils.visual.get_text()
  end

  builtin.man_pages(opts)
end

function M.buffers()
  local opts = themes.get_dropdown({
    preview = { hide_on_startup = true },
    ignore_current_buffer = true, -- When current buffer is included & last used is selected, search doesn't work well
    sort_lastused = true, -- Sort current & last used buffer at the top & select the last used
    sort_mru = true, -- Sort all buffers after the last used
  })

  builtin.buffers(opts)
end

function M.command_history()
  local opts = themes.get_dropdown({
    previewer = false,
    layout_config = { width = 0.7 },
    tiebreak = function(current, existing, _) return current.index < existing.index end, -- Sort entries by recency
    filter_fn = function(cmd) return string.len(cmd) >= 4 end, -- Filter out short commands like "w", "q", "wq", "wqa"
  })

  builtin.command_history(opts)
end

function M.search_history()
  local opts = themes.get_dropdown({
    previewer = false,
    layout_config = { width = 0.7 },
    tiebreak = function(current, existing, _) return current.index < existing.index end, -- Sort entries by recency
  })

  builtin.search_history(opts)
end

function M.git_status()
  local opts = { prompt_title = "Git Status" }
  builtin.git_status(opts)
end

function M.git_commits()
  local opts = {
    prompt_title = "Git Log",
    tiebreak = function(current, existing, _) return current.index < existing.index end, -- Sort entries by recency
  }
  builtin.git_commits(opts)
end

function M.git_bcommits()
  local opts = {
    prompt_title = "Buffer Commits",
    tiebreak = function(current, existing, _) return current.index < existing.index end, -- Sort entries by recency
  }
  builtin.git_bcommits(opts)
end

function M.git_bcommits_range()
  local opts = {
    prompt_title = "Selection Commits",
    tiebreak = function(current, existing, _) return current.index < existing.index end, -- Sort entries by recency
  }
  builtin.git_bcommits_range(opts)
end

function M.lsp_document_symbols()
  local opts = {}

  if custom_utils.visual.is_visual_mode() then
    opts.default_text = custom_utils.visual.get_text()
  end

  builtin.lsp_document_symbols(opts)
end

function M.lsp_workspace_symbols()
  local opts = {}

  if custom_utils.visual.is_visual_mode() then
    opts.default_text = custom_utils.visual.get_text()
  end

  builtin.lsp_dynamic_workspace_symbols(opts)
end

return M
