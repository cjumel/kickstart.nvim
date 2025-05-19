-- marks.nvim
--
-- marks.nvim provides a better user experience for interacting with and manipulating Vim & Neovim marks. Such a plugin
-- is, in my opinion, essential to use marks, as it provides the missing features of Neovim marks, like visualizing
-- them in the sign column or some handy keymaps to delete them, for instance.

return {
  "chentoast/marks.nvim",
  event = { "BufNewFile", "BufReadPre" },
  keys = {
    { "m", function() require("marks").set() end, desc = "Set mark" },
    { "m<Space>", function() require("marks").set_next() end, desc = "Set next available mark" },
    {
      "m<Tab>",
      function()
        require("marks").mark_state:all_to_list()
        vim.cmd("Trouble loclist toggle")
      end,
      desc = "Send marks to location list",
    },
    { "dm", function() require("marks").delete() end, desc = "Delete mark" },
    { "dm<Space>", function() require("marks").delete_line() end, desc = "Delete line marks" },
    { "dm<Tab>", function() require("marks").delete_buf() end, desc = "Delete buffer marks" },
  },
  opts = {
    default_mappings = false,
  },
}
