local buffer = require("buffer")
local visual_mode = require("visual_mode")

local M = {}

M.grug_far = function()
  local opts = {
    prefills = {},
  }

  if vim.bo.filetype == "oil" then
    opts.prefills.paths = require("oil").get_current_dir()
  end
  if visual_mode.is_on() then
    opts.prefills.search = visual_mode.get_text()
  end

  require("grug-far").grug_far(opts)
end

M.grug_far_buffer = function()
  local opts = {
    prefills = {},
  }

  if vim.bo.filetype ~= "oil" then
    opts.prefills.paths = vim.fn.expand("%")
  else
    error("Grug-far buffer action can't be used on Oil buffers")
  end
  if visual_mode.is_on() then
    opts.prefills.search = visual_mode.get_text()
  end

  require("grug-far").grug_far(opts)
end

M.grug_far_filetype = function()
  local opts = {
    prefills = {},
  }

  if vim.bo.filetype ~= "oil" then
    opts.prefills.filesFilter = "*." .. vim.bo.filetype
  else
    opts.prefills.paths = require("oil").get_current_dir()
    local filetype = buffer.get_project_filetype()
    if filetype ~= nil then
      opts.prefills.filesFilter = "*." .. filetype
    end
  end
  if visual_mode.is_on() then
    opts.prefills.search = visual_mode.get_text()
  end

  require("grug-far").grug_far(opts)
end

return M
