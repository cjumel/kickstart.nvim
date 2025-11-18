local M = {}

--- Quit the current buffer, prompting to save if modified. The entire funtion behavior is copied on Snacks.nvim
--- bufdelete's one.
function M.quit()
  if vim.bo.modified then
    local bufname = vim.api.nvim_buf_get_name(0)
    local bufpath = vim.fn.fnamemodify(bufname, ":p:~:.")
    local choice = vim.fn.confirm('Save changes to "' .. bufpath .. '"?', "&Yes\n&No\nCancel", 1)
    if choice == 1 then
      vim.cmd("wq")
    elseif choice == 2 then
      vim.cmd("q!")
    end
  else
    vim.cmd("q")
  end
end

return M
