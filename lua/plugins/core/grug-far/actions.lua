local visual_mode = require("visual_mode")

local M = {}

M.grug_far = function()
  local opts = {
    prefills = {},
  }

  if vim.bo.filetype == "oil" then
    local oil = require("oil")
    opts.prefills.paths = oil.get_current_dir()
  end
  if visual_mode.is_on() then
    opts.prefills.search = visual_mode.get_text()
  end

  require("grug-far").open(opts)
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

  require("grug-far").open(opts)
end

M.grug_far_filetype = function()
  local opts = {
    prefills = {},
  }

  if vim.bo.filetype ~= "oil" then
    local file_extension = vim.fn.expand("%:e")
    opts.prefills.filesFilter = "*." .. file_extension
  else
    -- Filetype can't be inferred so let's only pre-fill the directory path
    local oil = require("oil")
    opts.prefills.paths = oil.get_current_dir()
  end
  if visual_mode.is_on() then
    opts.prefills.search = visual_mode.get_text()
  end

  require("grug-far").open(opts)
end

return M
