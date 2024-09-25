-- [[ Highlight Yanked Text ]]
-- This auto-command shows which part of a file has been yanked

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.highlight.on_yank() end,
  group = vim.api.nvim_create_augroup("HighlightOnYank", { clear = true }),
})

-- [[ Clear Unnamed Buffers ]]
-- This auto-command removes the empty unnamed buffers (created when no buffer is opened) whenever another buffer is
--  opened. This prevents showing unnamed buffers in the buffers Telescope picker, for instance.

--- Delete all unnamed buffers whose content is empty.
---@return nil
local function clear_unnamed_buffers()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if
      vim.api.nvim_buf_is_loaded(bufnr)
      and vim.api.nvim_buf_get_name(bufnr) == ""
      and vim.api.nvim_get_option_value("buftype", { buf = bufnr }) == ""
    then
      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false) -- Get all lines in the buffer
      local total_characters = 0
      for _, line in ipairs(lines) do
        total_characters = total_characters + #line
      end
      if total_characters == 0 then
        vim.api.nvim_buf_delete(bufnr, { force = true })
      end
    end
  end
end

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = clear_unnamed_buffers,
  group = vim.api.nvim_create_augroup("ClearUnamedBuffers", { clear = true }),
})
