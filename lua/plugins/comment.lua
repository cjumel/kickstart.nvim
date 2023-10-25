-- comment.nvim
--
-- Define many keymaps to comment code, using `gc` and others.

return {
  "numToStr/Comment.nvim",
  event = { "BufNewFile", "BufReadPre" },
  keys = {
    {
      "<leader>ta",
      function()
        vim.api.nvim_command("normal! o")
        -- The new line is either empty or with a comment prefix, let's remove it, if needed,
        -- before adding the "TODO"
        vim.api.nvim_command("normal! ^DaTODO: ")
        require("Comment.api").comment.linewise.current()
        vim.api.nvim_command("normal! $")
      end,
      desc = "[T]odo: [A]dd (line after the cursor)",
    },
    {
      "<leader>tA",
      function()
        vim.api.nvim_command("normal! O")
        -- The new line is either empty or with a comment prefix, let's remove it, if needed,
        -- before adding the "TODO"
        vim.api.nvim_command("normal! ^DaTODO: ")
        require("Comment.api").comment.linewise.current()
        vim.api.nvim_command("normal! $")
      end,
      desc = "[T]odo: [A]dd (line before the cursor)",
    },
  },
  opts = {},
}
