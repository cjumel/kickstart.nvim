local telescope_opts = require("plugins.navigation.telescope.opts")
local utils = require("utils")

local M = {}

-- Overwrite the default preview action to open the preview window on the right hand side
M.preview = {
  desc = "Open the entry under the cursor in a preview window, or close the preview window if already open",
  callback = function()
    local oil = require("oil")
    local util = require("oil.util")
    local entry = oil.get_cursor_entry()
    if not entry then
      vim.notify("Could not find entry under cursor", vim.log.levels.ERROR)
      return
    end
    local winid = util.get_preview_win()
    if winid then
      local cur_id = vim.w[winid].oil_entry_id
      if entry.id == cur_id then
        vim.api.nvim_win_close(winid, true)
        return
      end
    end
    oil.select({ preview = true, split = "belowright" }) -- Open on the right hand side
  end,
}

-- Overwrite Telescope keymaps to search in the current directory when in Oil buffer
M.telescope_find_files = {
  desc = "[F]ind: [F]iles",
  mode = "n",
  callback = function()
    require("telescope.builtin").find_files(utils.table.concat_dicts({
      { cwd = require("oil").get_current_dir() },
      telescope_opts.find_files,
    }))
  end,
}
M.telescope_find_files_hidden = {
  desc = "[F]ind: files includ. [H]idden",
  mode = "n",
  callback = function()
    require("telescope.builtin").find_files(utils.table.concat_dicts({
      { cwd = require("oil").get_current_dir() },
      telescope_opts.find_files_hidden,
    }))
  end,
}
M.telescope_find_files_all = {
  desc = "[F]ind: [A]ll files",
  mode = "n",
  callback = function()
    require("telescope.builtin").find_files(utils.table.concat_dicts({
      { cwd = require("oil").get_current_dir() },
      telescope_opts.find_files_all,
    }))
  end,
}
M.telescope_live_grep = {
  desc = "[F]ind: by [G]rep",
  mode = "n",
  callback = function()
    require("telescope.builtin").live_grep(utils.table.concat_dicts({
      { cwd = require("oil").get_current_dir() },
      telescope_opts.live_grep,
    }))
  end,
}
M.telescope_live_grep_unrestricted = {
  desc = "[F]ind: by [G]rep (unrestricted)",
  mode = "n",
  callback = function()
    require("telescope.builtin").live_grep(utils.table.concat_dicts({
      { cwd = require("oil").get_current_dir() },
      telescope_opts.live_grep_unrestricted,
    }))
  end,
}
local function telescope_grep_string_callback()
  require("telescope.builtin").grep_string(utils.table.concat_dicts({
    { cwd = require("oil").get_current_dir() },
    telescope_opts.grep_string,
  }))
end
M.telescope_grep_string = {
  desc = "[F]ind: [W]ord",
  mode = "n",
  callback = telescope_grep_string_callback,
}
M.telescope_grep_string_visual = {
  desc = "[F]ind selection",
  mode = "v",
  callback = telescope_grep_string_callback,
}
local function telescope_grep_string_unrestricted_callback()
  require("telescope.builtin").grep_string(utils.table.concat_dicts({
    { cwd = require("oil").get_current_dir() },
    telescope_opts.grep_string_unrestricted,
  }))
end
M.telescope_grep_string_unrestricted = {
  desc = "[F]ind: [W]ord (unrestricted)",
  mode = "n",
  callback = telescope_grep_string_unrestricted_callback,
}
M.telescope_grep_string_unrestricted_visual = {
  desc = "[F]ind selection (unrestricted)",
  mode = "v",
  callback = telescope_grep_string_unrestricted_callback,
}

return M
