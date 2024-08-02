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
