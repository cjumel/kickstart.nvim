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
    local file_extension = vim.fn.expand("%:e")
    opts.prefills.filesFilter = "*." .. file_extension
  else
    opts.prefills.paths = require("oil").get_current_dir()
    local file_extension = buffer.get_project_filetype({ output_extension = true })
    if file_extension ~= nil then
      opts.prefills.filesFilter = "*." .. file_extension
    end
  end
  if visual_mode.is_on() then
    opts.prefills.search = visual_mode.get_text()
  end

  require("grug-far").grug_far(opts)
end

return M
