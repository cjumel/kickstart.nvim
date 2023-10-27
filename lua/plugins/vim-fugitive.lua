-- fugitive.vim
--
-- Fugitive provides a few git-related features, which make it and gitsigns perfect for a complete
-- git integration.

local function is_empty_string(s)
  return s == nil or s == ""
end
local function get_value(opts, default)
  if not is_empty_string(opts.args) then
    return opts.args
  else
    return default
  end
end

return {
  "tpope/vim-fugitive",
  cmd = {
    "Git",
  },
  keys = {
    {
      "<leader>gs",
      function()
        vim.cmd("Git")
      end,
      desc = "[G]it: [S]tatus",
    },
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
      vim.cmd("Git rebase " .. get_value(opts, "main"))
    end, { nargs = "?", desc = "Git rebase <arg> (main by default)" })
    vim.api.nvim_create_user_command("GitRebaseOrigin", function(opts)
      vim.cmd("Git rebase origin/" .. get_value(opts, "main"))
    end, { nargs = "?", desc = "Git rebase origin/<arg> (main by default)" })
    vim.api.nvim_create_user_command("GitRebaseInteractive", function(opts)
      vim.cmd("Git rebase --interactive " .. get_value(opts, "main"))
    end, { nargs = "?", desc = "Git rebase interactive <arg> (main by default)" })
    vim.api.nvim_create_user_command("GitRebaseInteractiveOrigin", function(opts)
      vim.cmd("Git rebase --interactive origin/" .. get_value(opts, "main"))
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
      vim.cmd("Git reset HEAD~" .. get_value(opts, "1"))
    end, { nargs = "?", desc = "Git reset mixed the last <arg> commits (1 by default)" })
    vim.api.nvim_create_user_command("GitResetSoftLast", function(opts)
      vim.cmd("Git reset --soft HEAD~" .. get_value(opts, "1"))
    end, { nargs = "?", desc = "Git reset soft the last <arg> commits (1 by default)" })
    vim.api.nvim_create_user_command("GitResetHardLast", function(opts)
      vim.cmd("Git reset --hard HEAD~" .. get_value(opts, "1"))
    end, { nargs = "?", desc = "Git reset hard the last <arg> commits (1 by default)" })
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
