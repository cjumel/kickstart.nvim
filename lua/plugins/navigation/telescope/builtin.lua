-- Here are defined custom wrappers around Telescope builtin pickers. It is where I implement custom options or logic
-- for each picker I use.

local builtin = require("telescope.builtin")
local previewers = require("telescope.previewers")
local themes = require("telescope.themes")

local custom_make_entry = require("plugins.navigation.telescope.make_entry")
local custom_utils = require("utils")

local M = {}

function M.current_buffer_fuzzy_find()
  local opts = {}

  if custom_utils.visual.is_visual_mode() then
    opts.default_text = custom_utils.visual.get_text()
  end

  builtin.current_buffer_fuzzy_find(opts)
end

function M.find_files()
  local opts = {
    find_command = { "fd", "--type", "f", "--color", "never" },
    preview = { hide_on_startup = true },
    prompt_title = "Find Files",
  }

  if vim.bo.filetype == "oil" then
    local cwd = package.loaded.oil.get_current_dir()
    opts.cwd = cwd
    opts.prompt_title = opts.prompt_title .. " - " .. custom_utils.path.normalize(cwd)
  end

  vim.g.telescope_last_opts = opts -- Persist the options dynamically change them later on
  builtin.find_files(opts)
end

function M.find_directories()
  local opts = {
    find_command = { "fd", "--type", "d", "--color", "never" },
    preview = { hide_on_startup = true },
    prompt_title = "Find Directories",
  }

  if vim.bo.filetype == "oil" then
    local cwd = package.loaded.oil.get_current_dir()
    opts.cwd = cwd
    opts.prompt_title = opts.prompt_title .. " - " .. custom_utils.path.normalize(cwd)
  end

  vim.g.telescope_last_opts = opts -- Persist the options dynamically change them later on

  -- previwers.vim_buffer_cat can't be saved to state so let's work around this
  opts.previewer = previewers.vim_buffer_cat.new({})
  -- To support directory icons, use a custom entry maker (which needs to have accessed to the picker options)
  opts.entry_maker = custom_make_entry.gen_from_dir(opts)

  builtin.find_files(opts)
end

function M.live_grep()
  local opts = {
    prompt_title = "Find by Grep",
  }

  if custom_utils.visual.is_visual_mode() then
    opts.default_text = custom_utils.visual.get_text()
  end

  if vim.bo.filetype == "oil" then
    local cwd = package.loaded.oil.get_current_dir()
    opts.cwd = cwd
    opts.prompt_title = opts.prompt_title .. " - " .. custom_utils.path.normalize(cwd)
  end

  vim.g.telescope_last_opts = opts
  builtin.live_grep(opts)
end

function M.oldfiles()
  local opts = {
    preview = { hide_on_startup = true },
    tiebreak = function(current, existing, _) return current.index < existing.index end, -- Sort entries by recency
    prompt_title = "Find OldFiles",
  }

  builtin.oldfiles(opts)
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
  local opts = { prompt_title = "Find Git Files" }
  builtin.git_status(opts)
end

function M.git_commits()
  local opts = { prompt_title = "Git Log" }
  builtin.git_commits(opts)
end

function M.git_bcommits()
  if vim.fn.mode() == "n" then
    local opts = { prompt_title = "Git Buffer Log" }
    builtin.git_bcommits(opts)
  else
    local opts = { prompt_title = "Git Selection Log" }
    builtin.git_bcommits_range(opts)
  end
end

function M.keymaps()
  local opts = { prompt_title = "Keymaps" }
  builtin.keymaps(opts)
end

function M.help_tags()
  local opts = { prompt_title = "Help Tags" }
  builtin.help_tags(opts)
end

return M
