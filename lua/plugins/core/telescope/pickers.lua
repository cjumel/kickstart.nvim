-- Custom pickers for Telescope. These are mainly wrappers around Telescope's builtin pickers, for additional
-- customization.

local actions = require("telescope.actions")
local builtin = require("telescope.builtin")
local custom_actions = require("plugins.core.telescope.actions")
local themes = require("telescope.themes")

local M = {}

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
