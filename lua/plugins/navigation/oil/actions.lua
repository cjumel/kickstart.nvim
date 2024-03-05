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

return M
