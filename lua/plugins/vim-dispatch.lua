-- dispatch.vim
--
-- Dispatch commands like tests or builds asynchronously.

return {
  "tpope/vim-dispatch",
  cmd = {
    "Dispatch",
    "Copen",
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
      desc = "[G]it [C]o[M]mit",
    },
    {
      "<leader>gca",
      function()
        vim.cmd("GitCommitAmend")
      end,
      desc = "[G]it [C]ommit [A]mend",
    },
    {
      "<leader>gcf",
      function()
        vim.cmd("GitCommitFixup")
      end,
      desc = "[G]it [C]ommit [F]ixup",
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
    -- Git commit
    vim.api.nvim_create_user_command("GitCommit", function()
      vim.cmd("Dispatch git commit --no-edit")
    end, { desc = "Git commit" })
    vim.api.nvim_create_user_command("GitCommitAmend", function()
      vim.cmd("Dispatch! git commit --amend --no-edit")
    end, { desc = "Git commit amend" })
    vim.api.nvim_create_user_command("GitCommitFixup", function()
      vim.cmd("Dispatch! git commit --message '🚧 FIXUP'")
    end, { desc = "Git commit fixup" })
    vim.api.nvim_create_user_command("GitCommitWip", function()
      vim.cmd("Dispatch! git commit --no-verify --message '🚧 WIP'")
    end, { desc = "Git commit WIP" })

    -- Pre-commit
    vim.api.nvim_create_user_command("PrecommitRunFile", function()
      vim.cmd("Dispatch! pre-commit run --files %")
    end, { desc = "Pre-commit run on current file" })
    vim.api.nvim_create_user_command("PrecommitRunDirectory", function()
      vim.cmd("Dispatch! pre-commit run --files ./**/*")
    end, { desc = "Pre-commit run on current directory" })
    vim.api.nvim_create_user_command("PrecommitRunAllFiles", function()
      vim.cmd("Dispatch! pre-commit run --all-files")
    end, { desc = "Pre-commit run on all files" })
    vim.api.nvim_create_user_command("PrecommitAutoUpdate", function()
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
    vim.api.nvim_create_user_command("PythonRunFile", function()
      vim.cmd("Dispatch python %")
    end, { desc = "Python run on the current file" })

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
    vim.api.nvim_create_user_command("PytestFile", function()
      vim.cmd("Dispatch pytest %")
    end, { desc = "Pytest on the current file" })
  end,
}
