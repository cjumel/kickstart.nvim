local visual_mode = require("visual_mode")

local M = {}

M.grug_far = function(opts)
  opts = opts or {}
  local current_buffer_only = opts.current_buffer_only or false
  local current_filetype_only = opts.current_filetype_only or false

  local grug_far_opts = {
    prefills = {},
  }

  if vim.bo.filetype == "oil" then
    local cwd = require("oil").get_current_dir()
    if cwd then
      grug_far_opts.prefills.paths = vim.fn.expand(cwd)
    end
  end
  if visual_mode.is_on() then
    grug_far_opts.prefills.search = visual_mode.get_text()
  end

  if current_buffer_only then
    grug_far_opts.prefills.paths = vim.fn.expand("%")
  end
  if current_filetype_only then
    grug_far_opts.prefills.filesFilter = "*." .. vim.bo.filetype
  end

  require("grug-far").grug_far(grug_far_opts)
end

M.grug_far_buffer = function() M.grug_far({ current_buffer_only = true }) end

M.grug_far_filetype = function() M.grug_far({ current_filetype_only = true }) end

return M
