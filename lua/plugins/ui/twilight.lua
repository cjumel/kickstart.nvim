-- Twilight
--
-- Dims inactive portions of the code you're editing.

return {
  "folke/twilight.nvim",
  keys = {
    {
      "<leader>Z",
      function()
        require("twilight").toggle()
      end,
      desc = "[Z]en mode: toggle Twilight",
    },
  },
  opts = {},
}
