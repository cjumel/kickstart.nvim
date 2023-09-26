-- dispatch.vim
--
-- Dispatch commands like tests or builds asynchronously.

local create_user_cmd = function()
  vim.api.nvim_create_user_command("GitCommit", function()
    vim.cmd("Dispatch git commit --no-edit")
  end, { desc = "Git commit" })
  vim.api.nvim_create_user_command("PrecommitRunAllFiles", function()
    vim.cmd("Dispatch pre-commit run --all-files")
  end, { desc = "Pre-commit run on all files" })
  vim.api.nvim_create_user_command("PrecommitRunCurrentFile", function()
    vim.cmd("Dispatch pre-commit run --files %")
  end, { desc = "Pre-commit run on the current file" })
  vim.api.nvim_create_user_command("PoetryInstall", function()
    vim.cmd("Dispatch poetry install")
  end, { desc = "Poetry install" })
  vim.api.nvim_create_user_command("PoetryUpdate", function()
    vim.cmd("Dispatch poetry update")
  end, { desc = "Poetry update" })
  vim.api.nvim_create_user_command("PythonCurrentFile", function()
    vim.cmd("Dispatch python %")
  end, { desc = "Python on the current file" })
  vim.api.nvim_create_user_command("Pytest", function()
    vim.cmd("Dispatch pytest --no-header")
  end, { desc = "Pytest on all files" })
  vim.api.nvim_create_user_command("PytestCurrentFile", function()
    vim.cmd("Dispatch pytest % --no-header")
  end, { desc = "Pytest on the current file" })
end

return {
  "tpope/vim-dispatch",
  cmd = {
    "Dispatch",
    "GitCommit",
    "PrecommitRunAllFiles",
    "PrecommitRunCurrentFile",
    "PoetryInstall",
    "PoetryUpdate",
    "PythonCurrentFile",
    "Pytest",
    "PytestCurrentFile",
  },
  keys = {
    {
      "<leader>gcm",
      function()
        vim.cmd("GitCommit")
      end,
      desc = "[G]it [C]ommit with [M]essage",
    },
  },
  init = function()
    create_user_cmd()
  end,
  config = function()
    create_user_cmd()
  end,
}
