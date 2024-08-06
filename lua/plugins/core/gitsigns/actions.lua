-- Functions extending the features of the original gitsigns.actions module

local Hunks = require("gitsigns.hunks")
local gitsigns = require("gitsigns")

local cache = require("gitsigns.cache").cache

local api = vim.api
local current_buf = api.nvim_get_current_buf

local M = {}

--- Get the hunk under the cursor.
--- This function is directly taken without changes from the gitsigns.actions module, as the original function is not
--- re-usable.
--- @param bufnr? integer
--- @param hunks? Gitsigns.Hunk.Hunk[]?
--- @return Gitsigns.Hunk.Hunk? hunk
--- @return integer? index
local function get_cursor_hunk(bufnr, hunks)
  bufnr = bufnr or current_buf()

  if not hunks then
    if not cache[bufnr] then
      return
    end
    hunks = {}
    vim.list_extend(hunks, cache[bufnr].hunks or {})
    vim.list_extend(hunks, cache[bufnr].hunks_staged or {})
  end

  local lnum = api.nvim_win_get_cursor(0)[1]
  return Hunks.find_hunk(lnum, hunks)
end

--- Select the hunk under the cursor, with look ahead.
M.select_hunk = function()
  -- Adapt the "<C-U>" from the original command ":<C-U>Gitsigns select_hunk<CR>"
  --  This is taken from https://github.com/neovim/neovim/discussions/24055
  vim.cmd('execute "normal \\<ESC>"')

  -- Navigate to the next hunk is none is found
  local hunk = get_cursor_hunk()
  if hunk == nil then
    gitsigns.next_hunk({ wrap = false, navigation_message = false })
  end

  gitsigns.select_hunk()
end

return M
