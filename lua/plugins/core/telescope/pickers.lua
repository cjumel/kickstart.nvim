-- Custom pickers for Telescope. These are mainly wrappers around Telescope's builtin pickers, for additional
-- customization.

local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")
local custom_actions = require("plugins.core.telescope.actions")
local custom_make_entry = require("plugins.core.telescope.make_entry")
local previewers = require("telescope.previewers")
local themes = require("telescope.themes")
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
    attach_mappings = function(_, map)
      map({ "i", "n" }, "<C-t>", toggle_all_files)
      return true -- Enable default mappings
    end,
    _include_all_files = false,
  }

  if vim.bo.filetype == "oil" then
    opts.cwd = require("oil").get_current_dir()
  end
  if visual_mode.is_on() then
    local text = visual_mode.get_text()
    -- Replace punctuation marks by spaces, to support searching from module names, like "plugins.core"
    opts.default_text = string.gsub(text, "%p", " ")
  end

  return opts
end

function M.find_files()
  local opts = find_files_get_base_opts()
  vim.g.telescope_last_opts = opts -- Persist the options to be able to change them later

  opts = find_files_finalize_opts(opts)
  builtin.find_files(opts)
end

function M.recent_files()
  builtin.oldfiles({
    tiebreak = function(current, existing, _) return current.index < existing.index end, -- Sort by recency
    prompt_title = "Find Recent Files",
    -- Replace punctuation marks by spaces, to support searching from module names, like "plugins.core"
    default_text = visual_mode.is_on() and string.gsub(visual_mode.get_text(), "%p", " ") or nil,
    cwd_only = true,
  })
end

function M.old_files()
  builtin.oldfiles({
    tiebreak = function(current, existing, _) return current.index < existing.index end, -- Sort by recency
    prompt_title = "Find Old files",
    -- Replace punctuation marks by spaces, to support searching from module names, like "plugins.core"
    default_text = visual_mode.is_on() and string.gsub(visual_mode.get_text(), "%p", " ") or nil,
    previewer = false, -- File paths can be super long so let's git them some room
  })
end

--- Finalize the options for the `find_directories` custom picker. This function adds all the relevant not-persisted
--- options to the persisted ones.
---@param opts table The persisted options.
---@return table _ The finalized options.
local function find_directories_finalize_opts(opts)
  if not opts._include_all_files then
    opts.prompt_title = "Find Directories"
    opts.find_command = { "fd", "--type", "d", "--color", "never", "--hidden" }
    -- Previewers can't be saved to state so let's work around this by creating them here
    opts.previewer = previewers.new_termopen_previewer({
      get_command = function(entry, _)
        return {
          "eza",
          "-a1",
          "--color=always",
          "--icons=always",
          "--group-directories-first",
          entry.path,
        }
      end,
    })
    -- To support directory icons, use a custom entry maker (which needs to have accessed to the picker options)
    opts.entry_maker = custom_make_entry.gen_from_dir(opts)
  else
    opts.prompt_title = "Find Directories (all)"
    opts.find_command = { "fd", "--type", "d", "--color", "never", "--hidden", "--no-ignore" }
    -- Previewers can't be saved to state so let's work around this by creating them here
    opts.previewer = previewers.new_termopen_previewer({
      get_command = function(entry, _)
        return {
          "eza",
          "-a1",
          "--color=always",
          "--icons=always",
          "--group-directories-first",
          entry.path,
        }
      end,
    })
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
    attach_mappings = function(_, map)
      map({ "i", "n" }, "<C-t>", toggle_all_files)
      return true -- Enable default mappings
    end,
    _include_all_files = false,
  }

  if vim.bo.filetype == "oil" then
    opts.cwd = require("oil").get_current_dir()
  end
  if visual_mode.is_on() then
    local text = visual_mode.get_text()
    -- Replace punctuation marks by spaces, to support searching from module names, like "plugins.core"
    opts.default_text = string.gsub(text, "%p", " ")
  end

  return opts
end

function M.find_directories()
  local opts = find_directories_get_base_opts()
  vim.g.telescope_last_opts = opts -- Persist the options to be able to change them later

  opts = find_directories_finalize_opts(opts)
  builtin.find_files(opts)
end

function M.find_lines()
  builtin.current_buffer_fuzzy_find({
    prompt_title = "Find Lines",
    layout_strategy = "vertical",
    tiebreak = function(current, existing, _) return current.index < existing.index end, -- Sort by line number
    default_text = visual_mode.is_on() and visual_mode.get_text() or nil,
  })
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
    layout_strategy = "vertical",
    attach_mappings = function(_, map)
      map({ "i", "n" }, "<C-t>", toggle_all_files)
      return true -- Enable default mappings
    end,
    _include_all_files = false,
  }

  if vim.bo.filetype == "oil" then
    opts.cwd = require("oil").get_current_dir()
  end
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

function M.live_grep()
  local telescope_opts = live_grep_get_base_opts()
  vim.g.telescope_last_opts = telescope_opts -- Persist the options to be able to change them later

  telescope_opts = live_grep_finalize_opts(telescope_opts)
  builtin.live_grep(telescope_opts)
end

function M.help_tags()
  builtin.help_tags({
    prompt_title = "Help tags",
    layout_strategy = "vertical",
    previewer = false,
  })
end

function M.commands()
  builtin.commands({
    prompt_title = "Commands",
    layout_strategy = "vertical",
  })
end

function M.keymaps()
  builtin.keymaps({
    prompt_title = "Keymaps",
    layout_strategy = "vertical",
  })
end

function M.buffers()
  builtin.buffers(themes.get_dropdown({
    prompt_title = "Buffer Switcher",
    initial_mode = "normal",
    preview = { hide_on_startup = true },
    ignore_current_buffer = true, -- When current buffer is included & last used is selected, search doesn't work well
    sort_lastused = true, -- Sort current & last used buffer at the top & select the last used
    sort_mru = true, -- Sort all buffers after the last used
    attach_mappings = function(_, map)
      map({ "n" }, "<BS>", actions.delete_buffer)
      return true -- Enable default mappings
    end,
  }))
end

function M.resume() builtin.resume({}) end

function M.command_history()
  builtin.command_history(themes.get_dropdown({
    previewer = false,
    tiebreak = function(current, existing, _) return current.index < existing.index end, -- Sort by recency
    filter_fn = function(cmd) return string.len(cmd) >= 4 end, -- Filter out short commands like "w", "q", "wq", "wqa"
  }))
end

function M.search_history()
  builtin.search_history(themes.get_dropdown({
    previewer = false,
    tiebreak = function(current, existing, _) return current.index < existing.index end, -- Sort by recency
  }))
end

function M.git_status()
  builtin.git_status({
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
  })
end

function M.git_branches()
  builtin.git_branches({
    prompt_title = "Git Branch",
    layout_strategy = "vertical",
  })
end

function M.git_commits()
  builtin.git_commits({
    prompt_title = "Git Log",
    tiebreak = function(current, existing, _) return current.index < existing.index end, -- Sort by recency
    attach_mappings = function(_, _)
      actions.select_default:replace(custom_actions.copy_commit_hash) -- Replace the default checkout-to-commit action
      return true -- Enable default mappings
    end,
  })
end

function M.git_bcommits()
  builtin.git_bcommits({
    prompt_title = "Buffer Commits",
    tiebreak = function(current, existing, _) return current.index < existing.index end, -- Sort by recency
    attach_mappings = function(_, _)
      actions.select_default:replace(custom_actions.copy_commit_hash) -- Replace the default checkout-to-commit action
      return true -- Enable default mappings
    end,
  })
end

function M.git_bcommits_range()
  builtin.git_bcommits_range({
    prompt_title = "Selection Commits",
    tiebreak = function(current, existing, _) return current.index < existing.index end, -- Sort by recency
    attach_mappings = function(_, _)
      actions.select_default:replace(custom_actions.copy_commit_hash) -- Replace the default checkout-to-commit action
      return true -- Enable default mappings
    end,
  })
end

return M
