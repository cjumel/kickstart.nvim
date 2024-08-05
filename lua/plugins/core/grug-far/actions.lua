-- Define custom actions for grug-far.nvim

local utils = require("utils")

local M = {}

M.grug_far = function()
  local grug_far = require("grug-far")

  local opts = { prefills = {} }
  if utils.visual.is_visual_mode() then
    opts.prefills.search = utils.visual.get_text()
  end

  grug_far.grug_far(opts)
end

M.grug_far_oil_directory = function()
  local grug_far = require("grug-far")

  local opts = { prefills = {} }
  if vim.bo.filetype == "oil" then
    opts.prefills.paths = vim.fn.expand(package.loaded.oil.get_current_dir())
  else
    error("The current buffer is not an Oil buffer.")
  end
  if utils.visual.is_visual_mode() then
    opts.prefills.search = utils.visual.get_text()
  end

  grug_far.grug_far(opts)
end

return M
