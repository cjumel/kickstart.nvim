-- fugitive.vim
--
-- Fugitive provides a few git-related features, which make it and gitsigns perfect for a complete
-- git integration.

local function is_empty_string(s)
  return s == nil or s == ""
end

return {
  "tpope/vim-fugitive",
  cmd = {
    "Git",
  },
  keys = {
    -- Status
    {
      "<leader>gs",
      function()
        vim.cmd("GitStatus")
      end,
      desc = "[G]it: [S]tatus",
    },
  },
  init = function()
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
      if not is_empty_string(opts.args) then
        vim.cmd("Git rebase " .. opts.args)
      else
        vim.cmd("Git rebase main")
      end
    end, { nargs = "?", desc = "Git rebase (on main by default)" })
    vim.api.nvim_create_user_command("GitRebaseInteractive", function(opts)
      if not is_empty_string(opts.args) then
        vim.cmd("Git rebase --interactive " .. opts.args)
      else
        vim.cmd("Git rebase --interactive main")
      end
    end, { nargs = "?", desc = "Git rebase interactive (on main by default)" })
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
      if not is_empty_string(opts.args) then
        vim.cmd("Git reset HEAD~" .. opts.args)
      else
        vim.cmd("Git reset HEAD~1")
      end
    end, { desc = "Git reset mixed the last commits (1 by default)" })
    vim.api.nvim_create_user_command("GitResetSoftLast", function(opts)
      if not is_empty_string(opts.args) then
        vim.cmd("Git reset --soft HEAD~" .. opts.args)
      else
        vim.cmd("Git reset --soft HEAD~1")
      end
    end, { desc = "Git reset soft the last commits (1 by default)" })
    vim.api.nvim_create_user_command("GitResetHardLast", function(opts)
      if not is_empty_string(opts.args) then
        vim.cmd("Git reset --hard HEAD~" .. opts.args)
      else
        vim.cmd("Git reset --hard HEAD~1")
      end
    end, { desc = "Git reset hard the last commits (1 by default)" })
  end,
  config = function()
    -- Change keymaps in fugitive buffers
    local group = vim.api.nvim_create_augroup("Fugitive", { clear = false })
    local pattern = { "fugitive", "fugitiveblame" }
    local function remap(l, r)
      vim.api.nvim_create_autocmd(
        "FileType",
        { command = "nmap <buffer> " .. l .. " " .. r, group = group, pattern = pattern }
      )
    end

    remap("q", "gq") -- Quit
    remap(",", "[c") -- Previous hunk
    remap(";", "]c") -- Next hunk
    remap("R", "X") -- Reset changes under the cursor
    remap("<C-p>", "[[") -- Previous section
    remap("<C-n>", "]]") -- Next section
    remap("<C-v>", "go") -- Open file in vertical split
    remap("<C-x>", "o") -- Open file in horizontal split
    remap("-", "<Nop>") -- Disable key
  end,
}
