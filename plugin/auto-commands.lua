-- [[ Highlight Yanked Text ]]
-- This auto-command shows which part of a file has been yanked

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.highlight.on_yank() end,
  group = vim.api.nvim_create_augroup("HighlightOnYank", { clear = true }),
})

-- [[ Automatic Color Column ]]
-- This auto-command automatically sets the value of color column according to the `textwidth` buffer option. This makes
--  the management of color columns very easy, as the values of `textwidth` can be simply managed through Neovim's
--  support of `editorconfig` files by using the `max_line_length` field.

--- Set the color column value according to the value of the `textwidth` buffer option.
---@return nil
local function set_colorcolumn()
  if vim.bo.textwidth ~= 0 then
    vim.opt_local.colorcolumn = tostring(vim.bo.textwidth + 1) -- Offset the column by 1 to put it just after the limit
  end
end

local augroup = vim.api.nvim_create_augroup("AutomaticColorColumn", { clear = true })

vim.api.nvim_create_autocmd("BufEnter", { callback = set_colorcolumn, group = augroup })
-- Add an auto-command for when the textwidth is changed manually
vim.api.nvim_create_autocmd("OptionSet", { pattern = "textwidth", callback = set_colorcolumn, group = augroup })
