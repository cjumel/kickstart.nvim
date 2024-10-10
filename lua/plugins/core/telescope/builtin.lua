-- Here are defined custom wrappers around Telescope builtin pickers. It is where I implement custom options or logic
-- for each picker I use & want to customize.

local visual_mode = require("visual_mode")

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
    -- Make the path more user-friendly (relative to the cwd if in the cwd, otherwise relative to the home directory
    --  with a "~" prefix if in the home directory, otherwise absolute)
    local cwd = vim.fn.fnamemodify(opts.cwd, ":p:~:.")
    if cwd == "" then -- Case `cwd` is actually the cwd
      cwd = "./"
    end
    opts.prompt_title = opts.prompt_title .. " - " .. cwd
  end

  return opts
end

--- Get the base options for the `find_files` picker.
---@return table _ The `find_files` base options.
local function find_files_get_base_opts()
  local action_state = require("telescope.actions.state")
  local actions = require("telescope.actions")
  local builtin = require("telescope.builtin")

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

  if visual_mode.is_on() then
    local text = visual_mode.get_text()
    -- Replace punctuation marks by spaces, to support searching from module names, like "plugins.core"
    opts.default_text = string.gsub(text, "%p", " ")
  end

  return opts
end

function M.find_files(opts)
  local builtin = require("telescope.builtin")

  opts = opts or {}
  local current_oil_directory_only = opts.current_oil_directory_only or false

  local telescope_opts = find_files_get_base_opts()
  if current_oil_directory_only then
    if vim.bo.filetype == "oil" then
      telescope_opts.cwd = package.loaded.oil.get_current_dir()
    else
      error("The current buffer is not an Oil buffer.")
    end
  end
  vim.g.telescope_last_opts = telescope_opts -- Persist the options dynamically change them later on

  telescope_opts = find_files_finalize_opts(telescope_opts)
  builtin.find_files(telescope_opts)
end

--- Finalize the options for the `find_directories` custom picker. This function adds all the relevant not-persisted
--- options to the persisted ones.
---@param opts table The persisted options.
---@return table _ The finalized options.
local function find_directories_finalize_opts(opts)
  local custom_make_entry = require("plugins.core.telescope.make_entry")
  local previewers = require("telescope.previewers")

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
    -- Make the path more user-friendly (relative to the cwd if in the cwd, otherwise relative to the home directory
    --  with a "~" prefix if in the home directory, otherwise absolute)
    local cwd = vim.fn.fnamemodify(opts.cwd, ":p:~:.")
    if cwd == "" then -- Case `cwd` is actually the cwd
      cwd = "./"
    end
    opts.prompt_title = opts.prompt_title .. " - " .. cwd
  end

  return opts
end

--- Get the base options for the `find_directories` custom picker.
---@return table _ The `find_directories` base options.
local function find_directories_get_base_opts()
  local action_state = require("telescope.actions.state")
  local actions = require("telescope.actions")
  local builtin = require("telescope.builtin")

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

  if visual_mode.is_on() then
    local text = visual_mode.get_text()
    -- Replace punctuation marks by spaces, to support searching from module names, like "plugins.core"
    opts.default_text = string.gsub(text, "%p", " ")
  end

  return opts
end

function M.find_directories(opts)
  local builtin = require("telescope.builtin")

  opts = opts or {}
  local current_oil_directory_only = opts.current_oil_directory_only or false

  local telescope_opts = find_directories_get_base_opts()
  if current_oil_directory_only then
    if vim.bo.filetype == "oil" then
      telescope_opts.cwd = package.loaded.oil.get_current_dir()
    else
      error("The current buffer is not an Oil buffer.")
    end
  end
  vim.g.telescope_last_opts = telescope_opts -- Persist the options dynamically change them later on

  telescope_opts = find_directories_finalize_opts(telescope_opts)
  builtin.find_files(telescope_opts)
end

--- Finalize the options for the `live_grep` picker. This function adds all the relevant not-persisted options to the
--- persisted ones.
---@param opts table The persisted options.
---@return table _ The finalized options.
local function live_grep_finalize_opts(opts)
  opts.prompt_title = "Find by Grep"

  if opts.vimgrep_arguments and vim.tbl_contains(opts.vimgrep_arguments, "--fixed-strings") then
    opts.prompt_title = opts.prompt_title .. " - fixed-strings"
  end

  if not opts._include_all_files then
    opts.additional_args = { "--hidden" }
  else
    opts.prompt_title = opts.prompt_title .. " (all)"
    opts.additional_args = { "--hidden", "--no-ignore" }
  end

  if opts.cwd then
    -- Make the path more user-friendly (relative to the cwd if in the cwd, otherwise relative to the home directory
    --  with a "~" prefix if in the home directory, otherwise absolute)
    local cwd = vim.fn.fnamemodify(opts.cwd, ":p:~:.")
    if cwd == "" then -- Case `cwd` is actually the cwd
      cwd = "./"
    end
    opts.prompt_title = opts.prompt_title .. " - " .. cwd
  end

  return opts
end

--- Get the base options for the `live_grep` picker.
---@return table _ The `live_grep` base options.
local function live_grep_get_base_opts()
  local action_state = require("telescope.actions.state")
  local actions = require("telescope.actions")
  local builtin = require("telescope.builtin")

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

  if visual_mode.is_on() then
    opts.default_text = visual_mode.get_text()
    opts.vimgrep_arguments = {
      -- Default values
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      -- New values
      "--fixed-strings",
    }
  end

  return opts
end

function M.live_grep(opts)
  local builtin = require("telescope.builtin")

  opts = opts or {}
  local current_oil_directory_only = opts.current_oil_directory_only or false

  local telescope_opts = live_grep_get_base_opts()
  if current_oil_directory_only then
    if vim.bo.filetype == "oil" then
      telescope_opts.cwd = package.loaded.oil.get_current_dir()
    else
      error("The current buffer is not an Oil buffer.")
    end
  end
  vim.g.telescope_last_opts = telescope_opts -- Persist the options dynamically change them later on

  telescope_opts = live_grep_finalize_opts(telescope_opts)
  builtin.live_grep(telescope_opts)
end

function M.oldfiles()
  local builtin = require("telescope.builtin")

  local opts = {
    preview = { hide_on_startup = true },
    tiebreak = function(current, existing, _) return current.index < existing.index end, -- Sort entries by recency
    prompt_title = "Find OldFiles",
  }

  if visual_mode.is_on() then
    local text = visual_mode.get_text()
    -- Replace punctuation marks by spaces, to support searching from module names, like "plugins.core"
    opts.default_text = string.gsub(text, "%p", " ")
  end

  builtin.oldfiles(opts)
end

function M.current_buffer()
  local builtin = require("telescope.builtin")

  local opts = {
    prompt_title = "Find in Buffer",
  }

  if visual_mode.is_on() then
    opts.default_text = visual_mode.get_text()
  end

  builtin.current_buffer_fuzzy_find(opts)
end

function M.help_tags()
  local builtin = require("telescope.builtin")

  local opts = {}

  if visual_mode.is_on() then
    opts.default_text = visual_mode.get_text()
  end

  builtin.help_tags(opts)
end

function M.man_pages()
  local builtin = require("telescope.builtin")

  local opts = {}

  if visual_mode.is_on() then
    opts.default_text = visual_mode.get_text()
  end

  builtin.man_pages(opts)
end

function M.buffers()
  local actions = require("telescope.actions")
  local builtin = require("telescope.builtin")
  local themes = require("telescope.themes")

  local opts = themes.get_dropdown({
    initial_mode = "normal",
    preview = { hide_on_startup = true },
    ignore_current_buffer = true, -- When current buffer is included & last used is selected, search doesn't work well
    sort_lastused = true, -- Sort current & last used buffer at the top & select the last used
    sort_mru = true, -- Sort all buffers after the last used
    attach_mappings = function(_, map)
      map({ "n" }, "<BS>", actions.delete_buffer)
      return true -- Enable default mappings
    end,
  })

  builtin.buffers(opts)
end

function M.resume()
  local builtin = require("telescope.builtin")

  local opts = {}

  builtin.resume(opts)
end

function M.command_history()
  local builtin = require("telescope.builtin")
  local themes = require("telescope.themes")

  local opts = themes.get_dropdown({
    previewer = false,
    layout_config = { width = 0.7 },
    tiebreak = function(current, existing, _) return current.index < existing.index end, -- Sort entries by recency
    filter_fn = function(cmd) return string.len(cmd) >= 4 end, -- Filter out short commands like "w", "q", "wq", "wqa"
  })

  builtin.command_history(opts)
end

function M.search_history()
  local builtin = require("telescope.builtin")
  local themes = require("telescope.themes")

  local opts = themes.get_dropdown({
    previewer = false,
    layout_config = { width = 0.7 },
    tiebreak = function(current, existing, _) return current.index < existing.index end, -- Sort entries by recency
  })

  builtin.search_history(opts)
end

function M.git_status()
  local actions = require("telescope.actions")
  local builtin = require("telescope.builtin")

  local opts = {
    prompt_title = "Git Status",
    git_icons = {
      added = "+",
      changed = "~",
      copied = ">",
      deleted = "-",
      renamed = "➡",
      unmerged = "‡",
      untracked = "",
    },
    attach_mappings = function(_, map)
      -- Override the <Tab> keymap to disable the stage/unstage feature of the picker
      map({ "i", "n" }, "<Tab>", actions.move_selection_next)
      return true -- Enable default mappings
    end,
  }
  builtin.git_status(opts)
end

function M.git_branches()
  local builtin = require("telescope.builtin")

  builtin.git_branches()
end

function M.git_commits()
  local builtin = require("telescope.builtin")

  local opts = {
    prompt_title = "Git Log",
    tiebreak = function(current, existing, _) return current.index < existing.index end, -- Sort entries by recency
  }
  builtin.git_commits(opts)
end

function M.git_bcommits()
  local builtin = require("telescope.builtin")

  local opts = {
    prompt_title = "Buffer Commits",
    tiebreak = function(current, existing, _) return current.index < existing.index end, -- Sort entries by recency
  }
  builtin.git_bcommits(opts)
end

function M.git_bcommits_range()
  local builtin = require("telescope.builtin")

  local opts = {
    prompt_title = "Selection Commits",
    tiebreak = function(current, existing, _) return current.index < existing.index end, -- Sort entries by recency
  }
  builtin.git_bcommits_range(opts)
end

function M.lsp_document_symbols()
  local builtin = require("telescope.builtin")

  local opts = {}

  if visual_mode.is_on() then
    opts.default_text = visual_mode.get_text()
  end

  builtin.lsp_document_symbols(opts)
end

function M.lsp_workspace_symbols()
  local builtin = require("telescope.builtin")

  local opts = {}

  if visual_mode.is_on() then
    opts.default_text = visual_mode.get_text()
  end

  builtin.lsp_dynamic_workspace_symbols(opts)
end

return M
