-- fugitive.vim
--
-- Fugitive provides a few git-related features, which make it and gitsigns perfect for a complete
-- git integration.

local create_user_cmd = function()
  vim.api.nvim_create_user_command("GitStatus", function()
    vim.cmd("Git")
  end, { desc = "Git status" })

  vim.api.nvim_create_user_command("GitCommitAmend", function()
    vim.cmd("Git commit --amend")
  end, { desc = "Git commit amend" })
  vim.api.nvim_create_user_command("GitCommitAmendNoEdit", function()
    vim.cmd("Git commit --amend --no-edit")
  end, { desc = "Git commit amend (no edit)" })

  vim.api.nvim_create_user_command("GitStash", function()
    vim.cmd("Git stash")
  end, { desc = "Git stash" })
  vim.api.nvim_create_user_command("GitStashPop", function()
    vim.cmd("Git stash pop")
  end, { desc = "Git stash pop" })

  vim.api.nvim_create_user_command("GitRebase", function()
    vim.cmd("Git rebase")
  end, { desc = "Git rebase" })
  vim.api.nvim_create_user_command("GitRebaseInteractive", function()
    vim.cmd("Git rebase --interactive")
  end, { desc = "Git rebase interactive" })

  vim.api.nvim_create_user_command("GitResetLast", function()
    vim.cmd("Git reset HEAD~1")
  end, { desc = "Git reset last commit" })
  vim.api.nvim_create_user_command("GitResetSoftLast", function()
    vim.cmd("Git reset --soft HEAD~1")
  end, { desc = "Git reset soft last commit" })
  vim.api.nvim_create_user_command("GitResetHardLast", function()
    vim.cmd("Git reset --hard HEAD~1")
  end, { desc = "Git reset hard last commit" })
end

return {
  "tpope/vim-fugitive",
  cmd = {
    "Git",
    "GitStatus",
    "GitCommitAmend",
    "GitCommitAmendNoEdit",
    "GitStash",
    "GitStashPop",
    "GitRebase",
    "GitRebaseInteractive",
    "GitResetLast",
    "GitResetSoftLast",
    "GitResetHardLast",
  },
  keys = {
    {
      "<leader>gs",
      function()
        vim.cmd("GitStatus")
      end,
      desc = "[G]it [S]tatus",
    },
    {
      "<leader>gca",
      function()
        vim.cmd("GitCommitAmendNoEdit")
      end,
      desc = "[G]it [C]ommit [A]mend (no edit)",
    },
  },
  init = function()
    create_user_cmd()
  end,
  config = function()
    create_user_cmd()

    -- Change keymaps in fugitive buffers
    local group = vim.api.nvim_create_augroup("Fugitive", { clear = false })
    local pattern = { "fugitive", "fugitiveblame" }

    -- Quit
    vim.api.nvim_create_autocmd(
      "FileType",
      { command = "nmap <buffer> q gq", group = group, pattern = pattern }
    )

    -- Navigate hunks
    vim.api.nvim_create_autocmd(
      "FileType",
      { command = "nmap <buffer> <C-p> (", group = group, pattern = pattern }
    )
    vim.api.nvim_create_autocmd(
      "FileType",
      { command = "nmap <buffer> <C-n> )", group = group, pattern = pattern }
    )

    -- Open files in split windows
    vim.api.nvim_create_autocmd(
      "FileType",
      { command = "nmap <buffer> <C-v> gO", group = group, pattern = pattern }
    )
    vim.api.nvim_create_autocmd(
      "FileType",
      { command = "nmap <buffer> <C-x> o", group = group, pattern = pattern }
    )
  end,
}
