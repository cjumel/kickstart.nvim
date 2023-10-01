-- fugitive.vim
--
-- Fugitive provides a few git-related features, which make it and gitsigns perfect for a complete
-- git integration.

local create_user_cmd = function()
  -- Status
  vim.api.nvim_create_user_command("GitStatus", function()
    vim.cmd("Git")
  end, { desc = "Git status" })

  -- Stash
  vim.api.nvim_create_user_command("GitStash", function()
    vim.cmd("Git stash")
  end, { desc = "Git stash" })
  vim.api.nvim_create_user_command("GitStashPop", function()
    vim.cmd("Git stash pop")
  end, { desc = "Git stash pop" })

  -- Add
  vim.api.nvim_create_user_command("GitAddCurrentFile", function()
    vim.cmd("Git add %")
  end, { desc = "Git add current file" })
  vim.api.nvim_create_user_command("GitAddCurrentDirectory", function()
    vim.cmd("Git add .")
  end, { desc = "Git add current directory" })
  vim.api.nvim_create_user_command("GitAddAll", function()
    vim.cmd("Git add --all")
  end, { desc = "Git add all" })

  -- Rebase
  vim.api.nvim_create_user_command("GitRebase", function(opts)
    vim.cmd("Git rebase " .. opts.args)
  end, { nargs = 1, desc = "Git rebase" })
  vim.api.nvim_create_user_command("GitRebaseInteractive", function(opts)
    vim.cmd("Git rebase " .. opts.args .. " --interactive")
  end, { nargs = 1, desc = "Git rebase interactive" })
  vim.api.nvim_create_user_command("GitRebaseMain", function()
    vim.cmd("Git rebase main")
  end, { desc = "Git rebase main" })
  vim.api.nvim_create_user_command("GitRebaseMainInteractive", function()
    vim.cmd("Git rebase main --interactive")
  end, { desc = "Git rebase main interactive" })
  vim.api.nvim_create_user_command("GitRebaseAbort", function()
    vim.cmd("Git rebase --abort")
  end, { desc = "Git rebase abort" })
  vim.api.nvim_create_user_command("GitRebaseContinue", function()
    vim.cmd("Git rebase --continue")
  end, { desc = "Git rebase continue" })

  -- Reset
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
    -- General
    "Git",
    -- Status
    "GitStatus",
    -- Stash
    "GitStash",
    "GitStashPop",
    -- Add
    "GitAddCurrentFile",
    "GitAddCurrentDirectory",
    "GitAddAll",
    -- Rebase
    "GitRebase",
    "GitRebaseInteractive",
    "GitRebaseMain",
    "GitRebaseMainInteractive",
    "GitRebaseAbort",
    "GitRebaseContinue",
    -- Reset
    "GitResetLast",
    "GitResetSoftLast",
    "GitResetHardLast",
  },
  keys = {
    -- Status
    {
      "<leader>gs",
      function()
        vim.cmd("GitStatus")
      end,
      desc = "[G]it [S]tatus",
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
