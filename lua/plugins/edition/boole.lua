-- boole.nvim
--
-- Boole is a simple Neovim plugin that extends the default increment and decrement functionality
-- of CTRL-A and CTRL-X to allow for toggling boolean values like on, yes, and true as well as
-- cycling through series of values like days of the week or months of the year.

return {
  "nat-418/boole.nvim",
  opts = {
    mappings = {
      increment = "<C-a>",
      decrement = "<C-x>",
    },
  },
}
