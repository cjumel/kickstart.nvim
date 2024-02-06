-- dispatch.vim
--
-- Dispatch commands like tests or builds asynchronously.

local create_user_cmd = function()
  -- Git commit
  vim.api.nvim_create_user_command("GitCommit", function()
    vim.cmd("Dispatch git commit --no-edit")
  end, { desc = "Git commit" })
  vim.api.nvim_create_user_command("GitCommitAmend", function()
    vim.cmd("Dispatch! git commit --amend --no-edit")
  end, { desc = "Git commit amend" })
  vim.api.nvim_create_user_command("GitCommitWip", function()
    vim.cmd("Dispatch! git commit --no-verify --message '🚧 WIP'")
  end, { desc = "Git commit WIP" })

  -- Pre-commit
  vim.api.nvim_create_user_command("PrecommitRunAllFiles", function()
    vim.cmd("Dispatch! pre-commit run --all-files")
  end, { desc = "Pre-commit run on all files" })
  vim.api.nvim_create_user_command("PrecommitRunCurrentFile", function()
    vim.cmd("Dispatch! pre-commit run --files %")
  end, { desc = "Pre-commit run on the current file" })
  vim.api.nvim_create_user_command("PrecommitAutoupdate", function()
    vim.cmd("Dispatch! pre-commit autoupdate")
  end, { desc = "Pre-commit auto-update" })

  -- Poetry
  vim.api.nvim_create_user_command("PoetryInstall", function()
    vim.cmd("Dispatch! poetry install")
  end, { desc = "Poetry install" })
  vim.api.nvim_create_user_command("PoetryUpdate", function()
    vim.cmd("Dispatch! poetry update")
  end, { desc = "Poetry update" })

  -- Python
  vim.api.nvim_create_user_command("PythonCurrentFile", function()
    vim.cmd("Dispatch python %")
  end, { desc = "Python on the current file" })

  -- Pytest
  vim.api.nvim_create_user_command("Pytest", function()
    vim.cmd("Dispatch! pytest")
  end, { desc = "Pytest on all tests" })
  vim.api.nvim_create_user_command("PytestFast", function()
    vim.cmd("Dispatch pytest -m 'not slow'")
  end, { desc = "Pytest on fast tests" })
  vim.api.nvim_create_user_command("PytestSlow", function()
    vim.cmd("Dispatch pytest -m 'slow'")
  end, { desc = "Pytest on slow tests" })
  vim.api.nvim_create_user_command("PytestCurrentFile", function()
    vim.cmd("Dispatch pytest %")
  end, { desc = "Pytest on the current file" })
end

return {
  "tpope/vim-dispatch",
  cmd = {
    -- General
    "Dispatch",
    "Copen",
    -- Git commit
    "GitCommit",
    "GitCommitAmend",
    "GitCommitWip",
    -- Pre-commit
    "PrecommitRunAllFiles",
    "PrecommitRunCurrentFile",
    "PrecommitAutoupdate",
    -- Poetry
    "PoetryInstall",
    "PoetryUpdate",
    -- Python
    "PythonCurrentFile",
    -- Pytest
    "Pytest",
    "PytestFast",
    "PytestSlow",
    "PytestCurrentFile",
  },
  keys = {
    -- General
    {
      "<leader>co",
      function()
        vim.cmd("Copen")
      end,
      desc = "[C]ommand [O]pen",
    },
    -- Git commit
    {
      "<leader>gcm",
      function()
        vim.cmd("GitCommit")
      end,
      desc = "[G]it [C]ommit with [M]essage",
    },
    {
      "<leader>gca",
      function()
        vim.cmd("GitCommitAmend")
      end,
      desc = "[G]it [C]ommit [A]mend",
    },
    {
      "<leader>gcw",
      function()
        vim.cmd("GitCommitWip")
      end,
      desc = "[G]it [C]ommit [W]IP",
    },
  },
  init = function()
    create_user_cmd()
  end,
  config = function()
    create_user_cmd()
  end,
}
