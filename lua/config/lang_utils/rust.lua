local M = {}

local project_markers = { "Cargo.toml" }

---@return boolean
function M.is_project()
  return not vim.tbl_isempty(vim.fs.find(project_markers, {
    path = vim.fn.getcwd(),
    upward = true,
    stop = vim.env.HOME,
  }))
end

return M
