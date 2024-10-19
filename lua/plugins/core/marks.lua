-- marks.nvim
--
-- marks.nvim provides a better user experience for interacting with and manipulating Vim & Neovim marks. Such a plugin
-- is, in my opinion, essential to use marks, as it provides the missing features of Neovim marks, like visualizing
-- them in the sign column or some handy keymaps to delete them, for instance.

return {
  "chentoast/marks.nvim",
  event = { "BufNewFile", "BufReadPre" },
  keys = { -- Defining keymaps here, instead of in `opts`, seems to be the only way to add descriptions
    { "m", function() require("marks").set() end, desc = "Set mark" },
    { "m<Space>", function() require("marks").set_next() end, desc = "Set next available mark" },
    { "dm", function() require("marks").delete() end, desc = "Delete mark" },
    { "dm<Space>", function() require("marks").delete_line() end, desc = "Delete line marks" },
    { "dm<CR>", function() require("marks").delete_buf() end, desc = "Delete buffer marks" },
    {
      "m<CR>",
      function()
        require("marks").mark_state:buffer_to_list()
        vim.notify("Buffer marks sent to Loclist")
      end,
      desc = "Send buffer marks to Loclist",
    },
    {
      "m<Tab>",
      function()
        require("marks").mark_state:all_to_list()
        vim.notify("Workspace marks sent to loclist")
      end,
      desc = "Send workspace marks to Loclist",
    },
  },
  opts = {
    default_mappings = false, -- Don't use default mappings as all keymaps are defined in `keys`
  },
}
