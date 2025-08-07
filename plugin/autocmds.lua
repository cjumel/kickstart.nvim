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

-- [[ Better InsertEnter lazy-loading ]]
-- This enables lazy-loading plugins on `InsertEnter` event, but skipping prompt buffers like snacks.nvim pickers

local insert_enter_plugins = {
  "copilot.lua",
  "LuaSnip",
  "nvim-autopairs",
  "nvim-cmp",
}
vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function()
    if not vim.g.insert_enter_plugins_loaded and vim.bo.buftype ~= "prompt" then
      require("lazy").load({ plugins = insert_enter_plugins })
      vim.g.insert_enter_plugins_loaded = true
    end
  end,
})
