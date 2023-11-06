-- fugitive.vim
--
-- A Git wrapper so awesome, it should be illegal. This plugins provides many commands wrapping
-- around git commands.

local utils = require("plugins.workflow.vcs.utils.vim-fugitive")

return {
  "tpope/vim-fugitive",
  cmd = {
    "Git",
  },
  keys = {
    {
      "<leader>gps",
      function()
        vim.cmd("Git push")
      end,
      desc = "[G]it: [P]u[S]h",
    },
    {
      "<leader>gpl",
      function()
        vim.cmd("Git pull")
      end,
      desc = "[G]it: [P]u[L]l",
    },
  },
  init = function()
    -- Stash
    vim.api.nvim_create_user_command("GitStash", function()
      vim.cmd("Git stash")
    end, { desc = "Git stash" })
    vim.api.nvim_create_user_command("GitStashPop", function()
      vim.cmd("Git stash pop")
    end, { desc = "Git stash pop" })
    vim.api.nvim_create_user_command("GitStashClear", function()
      vim.cmd("Git stash clear")
    end, { desc = "Git stash clear" })

    -- Rebase
    vim.api.nvim_create_user_command("GitRebase", function(opts)
      vim.cmd("Git rebase " .. utils.get_value(opts, "main"))
    end, { nargs = "?", desc = "Git rebase <arg> (main by default)" })
    vim.api.nvim_create_user_command("GitRebaseOrigin", function(opts)
      vim.cmd("Git rebase origin/" .. utils.get_value(opts, "main"))
    end, { nargs = "?", desc = "Git rebase origin/<arg> (main by default)" })
    vim.api.nvim_create_user_command("GitRebaseInteractive", function(opts)
      vim.cmd("Git rebase --interactive " .. utils.get_value(opts, "main"))
    end, { nargs = "?", desc = "Git rebase interactive <arg> (main by default)" })
    vim.api.nvim_create_user_command("GitRebaseInteractiveOrigin", function(opts)
      vim.cmd("Git rebase --interactive origin/" .. utils.get_value(opts, "main"))
    end, { nargs = "?", desc = "Git rebase interactive origin/<arg> (main by default)" })
    vim.api.nvim_create_user_command("GitRebaseAbort", function()
      vim.cmd("Git rebase --abort")
    end, { desc = "Git rebase abort" })
    vim.api.nvim_create_user_command("GitRebaseContinue", function()
      vim.cmd("Git rebase --continue")
    end, { desc = "Git rebase continue" })
    vim.api.nvim_create_user_command("GitRebaseSkip", function()
      vim.cmd("Git rebase --skip")
    end, { desc = "Git rebase skip" })

    -- Reset
    vim.api.nvim_create_user_command("GitResetMixedLast", function(opts)
      vim.cmd("Git reset HEAD~" .. utils.get_value(opts, "1"))
    end, { nargs = "?", desc = "Git reset mixed the last <arg> commits (1 by default)" })
    vim.api.nvim_create_user_command("GitResetSoftLast", function(opts)
      vim.cmd("Git reset --soft HEAD~" .. utils.get_value(opts, "1"))
    end, { nargs = "?", desc = "Git reset soft the last <arg> commits (1 by default)" })
    vim.api.nvim_create_user_command("GitResetHardLast", function(opts)
      vim.cmd("Git reset --hard HEAD~" .. utils.get_value(opts, "1"))
    end, { nargs = "?", desc = "Git reset hard the last <arg> commits (1 by default)" })
  end,
}
