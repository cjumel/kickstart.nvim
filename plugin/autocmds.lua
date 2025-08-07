-- [[ Automatic Color Column ]]
-- Automatically sets the color column according to `vim.bo.textwidth` (which can be read from a `.editorconfig` file)

--- Set the color column value according to `vim.bo.textwidth`.
---@return nil
local function set_colorcolumn()
  if vim.bo.textwidth ~= 0 then
    vim.opt_local.colorcolumn = tostring(vim.bo.textwidth + 1) -- Offset the column by 1 to put it just after the limit
  end
end

local augroup = vim.api.nvim_create_augroup("AutomaticColorColumn", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", { callback = set_colorcolumn, group = augroup })
-- For when `vim.bo.textwidth` is changed manually:
vim.api.nvim_create_autocmd("OptionSet", { pattern = "textwidth", callback = set_colorcolumn, group = augroup })
