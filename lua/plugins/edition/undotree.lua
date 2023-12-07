-- undotree
--
-- A neovim undotree plugin written in lua.

return {
  "jiaoshijie/undotree",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    {
      "<leader>u",
      function()
        require("undotree").toggle()
      end,
      desc = "[U]ndo tree",
    },
  },
  opts = {
    position = "right",
    window = {
      winblend = 0,
    },
  },
}
