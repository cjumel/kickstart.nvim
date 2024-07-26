-- Here are defined custom wrappers around Telescope builtin pickers. It is where I implement custom options or logic
-- for each picker I use.

local builtin = require("telescope.builtin")
local custom_make_entry = require("plugins.core.telescope.make_entry")
local custom_utils = require("utils")
local previewers = require("telescope.previewers")
local themes = require("telescope.themes")

local M = {}

--- Get the input options for the `find_files` picker.
---@param all boolean Whether to search for ignored files or not.
---@param directory boolean Whether to search for directories or not.
---@return table
local function get_input_opts_find_files(all, directory)
  local opts = {
    preview = { hide_on_startup = true },
    -- Custom options
    _all = all,
    _directory = directory,
  }

  if custom_utils.visual.is_visual_mode() then
    local text = custom_utils.visual.get_text()
    -- Replace punctuation marks by spaces, to support searching from module names, like "plugins.core"
    opts.default_text = string.gsub(text, "%p", " ")
  end

  if vim.bo.filetype == "oil" then
    opts.cwd = package.loaded.oil.get_current_dir()
  end

  return opts
end

--- Finalize the options for the `find_files` picker.
---@param opts table The input options.
---@return table
local function finalize_opts_find_files(opts)
  if not opts._all and not opts._directory then
    opts.prompt_title = "Find Files"
    opts.find_command = { "fd", "--type", "f", "--color", "never", "--hidden" }
  elseif opts._all and not opts._directory then
    opts.prompt_title = "Find Files (all)"
    opts.find_command = { "fd", "--type", "f", "--color", "never", "--hidden", "--no-ignore" }
  elseif not opts._all and opts._directory then
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
M.finalize_opts_find_files = finalize_opts_find_files

function M.find_files()
  local opts = get_input_opts_find_files(false, false)
  vim.g.telescope_last_opts = opts -- Persist the options dynamically change them later on

  opts = finalize_opts_find_files(opts)
  builtin.find_files(opts)
end

function M.find_files_all()
  local opts = get_input_opts_find_files(true, false)
  vim.g.telescope_last_opts = opts -- Persist the options dynamically change them later on

  opts = finalize_opts_find_files(opts)
  builtin.find_files(opts)
end

function M.find_directories()
  local opts = get_input_opts_find_files(false, true)
  vim.g.telescope_last_opts = opts -- Persist the options dynamically change them later on

  opts = finalize_opts_find_files(opts)
  builtin.find_files(opts)
end

function M.find_directories_all()
  local opts = get_input_opts_find_files(true, true)
  vim.g.telescope_last_opts = opts -- Persist the options dynamically change them later on

  opts = finalize_opts_find_files(opts)
  builtin.find_files(opts)
end

local function get_input_opts_live_grep(all)
  local opts = {
    -- Custom options
    _all = all,
  }

  if custom_utils.visual.is_visual_mode() then
    opts.default_text = custom_utils.visual.get_text()
  end

  if vim.bo.filetype == "oil" then
    opts.cwd = package.loaded.oil.get_current_dir()
  end

  return opts
end

local function finalize_opts_live_grep(opts)
  if not opts._all then
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
M.finalize_opts_live_grep = finalize_opts_live_grep

function M.live_grep()
  local opts = get_input_opts_live_grep(false)
  vim.g.telescope_last_opts = opts -- Persist the options dynamically change them later on

  opts = finalize_opts_live_grep(opts)
  builtin.live_grep(opts)
end

function M.live_grep_all()
  local opts = get_input_opts_live_grep(true)
  vim.g.telescope_last_opts = opts -- Persist the options dynamically change them later on

  opts = finalize_opts_live_grep(opts)
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
