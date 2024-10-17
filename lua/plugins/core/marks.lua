-- marks.nvim
--
-- marks.nvim provides a better user experience for interacting with and manipulating Vim & Neovim marks. Such a plugin
-- is, in my opinion, essential to use marks, as it provides the missing features of Neovim marks, like visualizing
-- them in the sign column or some handy keymaps to delete them, for instance.

return {
  "chentoast/marks.nvim",
  event = { "BufNewFile", "BufReadPre" },
  keys = { -- Defining manually keymaps (instead of in options) is the only way to add descriptions
    { "m", function() require("marks").set() end, desc = "Set mark" },
    { "m<Space>", function() require("marks").set_next() end, desc = "Set next available mark" },
    { "dm", function() require("marks").delete() end, desc = "Delete mark" },
    { "dm<Space>", function() require("marks").delete_line() end, desc = "Delete line marks" },
    { "dm<CR>", function() require("marks").delete_buf() end, desc = "Delete buffer marks" },
    {
      "<leader>m",
      function()
        require("marks").mark_state:buffer_to_list()
        require("trouble").open("loclist")
      end,
      desc = "[M]arks (buffer)",
    },
    {
      "<leader>M",
      function()
        require("marks").mark_state:all_to_list()
        require("trouble").open("loclist")
      end,
      desc = "[M]arks (workspace)",
    },
  },
  opts = {
    default_mappings = false, -- Don't use default mappings as keymaps are defined above
  },
}
