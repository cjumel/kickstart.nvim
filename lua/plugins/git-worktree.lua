-- git-worktree.nvim
--
-- A simple wrapper around git worktree operations, create, switch, and delete.

return {
  "ThePrimeagen/git-worktree.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  keys = {
    {
      "<leader>gwl",
      function()
        require("telescope").extensions.git_worktree.git_worktrees()
      end,
      desc = "[G]it: [W]orktree [L]ist",
    },
    {
      "<leader>gwc",
      function()
        require("telescope").extensions.git_worktree.create_git_worktree()
      end,
      desc = "[G]it: [W]orktree [C]reate",
    },
  },
  config = function()
    require("git-worktree").setup({
      change_directory_command = "cd",
      update_on_change = true,
      update_on_change_command = "",
      clearjumps_on_change = true,
      autopush = false,
    })
    require("telescope").load_extension("git_worktree")
  end,
}
