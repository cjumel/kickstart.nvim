local visual_mode = require("visual_mode")

local M = {}

M.grug_far = function(opts)
  local grug_far = require("grug-far")

  opts = opts or {}
  local current_buffer_only = opts.current_buffer_only or false
  local current_filetype_only = opts.current_filetype_only or false
  local current_oil_directory_only = opts.current_oil_directory_only or false

  local grug_far_opts = { prefills = {} }

  if visual_mode.is_on() then
    grug_far_opts.prefills.search = visual_mode.get_text()
  end
  if current_buffer_only then
    grug_far_opts.prefills.paths = vim.fn.expand("%")
  end
  if current_filetype_only then
    grug_far_opts.prefills.filesFilter = "*." .. vim.bo.filetype
  end
  if current_oil_directory_only then
    if vim.bo.filetype == "oil" then
      grug_far_opts.prefills.paths = vim.fn.expand(package.loaded.oil.get_current_dir())
    else
      error("The current buffer is not an Oil buffer.")
    end
  end

  grug_far.grug_far(grug_far_opts)
end

return M
