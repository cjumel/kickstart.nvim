-- dispatch.vim
--
-- Dispatch commands like tests or builds asynchronously.

-- TODO:
-- - Setup commands: python file, pytest all, pytest file, poetry update

local create_user_cmd = function()
  vim.api.nvim_create_user_command("GitCommit", function()
    vim.cmd("Dispatch git commit --no-edit")
  end, { desc = "Git commit" })
end

return {
  "tpope/vim-dispatch",
  cmd = {
    "Dispatch",
    "GitCommit",
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
