-- Auto Pairs
--
-- Automatically insert brackets in pairs.

return {
  "windwp/nvim-autopairs",
  event = { "BufNewFile", "BufReadPre" },
  keys = {
    {
      "<leader>,a",
      function()
        local autopairs = require("nvim-autopairs")
        if autopairs.state.disabled then
          autopairs.enable()
          vim.notify("Auto-pairs enabled.")
        else
          autopairs.disable()
          vim.notify("Auto-pairs disabled.")
        end
      end,
      desc = "Settings: toggle [A]uto-pairs",
    },
  },
  opts = {},
}
