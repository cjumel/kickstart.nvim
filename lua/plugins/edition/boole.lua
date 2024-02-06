-- boole.nvim
--
-- Boole is a simple Neovim plugin that extends the default increment and decrement functionality
-- of CTRL-A and CTRL-X to allow for toggling boolean values like on, yes, and true as well as
-- cycling through series of values like days of the week or months of the year.

return {
  "nat-418/boole.nvim",
  keys = {
    {
      "<C-a>",
      "<cmd>Boole increment<CR>",
      desc = "Increment",
      ft = "*",
    },
    {
      "<C-x>",
      "<cmd>Boole decrement<CR>",
      desc = "Decrement",
      ft = "*",
    },
  },
  opts = {
    mappings = {}, -- Can't be removed otherwise the setup fails
  },
}
