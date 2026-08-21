---@type nvim_config.DisableFormatOnSave Determine when to disable format on save, globally or per-buffer.
vim.g.disable_format_on_save = function(bufnr)
  if vim.bo[bufnr].filetype == "json" then
    return true
  end
  return false
end

---@type nvim_config.CommitConvention The convention to use for git commit messages.
vim.g.commit_convention = "gitmoji"
