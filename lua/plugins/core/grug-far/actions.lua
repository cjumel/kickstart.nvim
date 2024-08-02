-- Define custom actions for grug-far.nvim

local grug_far = require("grug-far")
local utils = require("utils")

local M = {}

M.grug_far = function()
  local opts = {}

  if not utils.visual.is_visual_mode() then
    grug_far.grug_far(opts)
  else
    grug_far.with_visual_selection(opts)
  end
end

M.grug_far_oil_directory = function()
  if vim.bo.filetype ~= "oil" then
    error("The current buffer is not an Oil buffer.")
  end
  local opts = {
    prefills = { paths = vim.fn.expand(package.loaded.oil.get_current_dir()) },
  }

  if not utils.visual.is_visual_mode() then
    grug_far.grug_far(opts)
  else
    grug_far.with_visual_selection(opts)
  end
end

M.grug_far_current_buffer = function()
  local opts = {
    prefills = { paths = vim.fn.expand("%") },
  }

  if not utils.visual.is_visual_mode() then
    grug_far.grug_far(opts)
  else
    grug_far.with_visual_selection(opts)
  end
end

return M
