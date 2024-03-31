-- marks.nvim
--
-- Plugin providing a better user experience for interacting with and manipulating Neoim marks.

-- NOTE: there's a known issue with non-permanent mark deletion, it should be fixed in Neovim 0.10
--  See https://github.com/chentoast/marks.nvim/issues/13
--  The suggested workarounds both messes with the `oldfiles` (used by Telescope) so I prefer not
--  to implement them

return {
  "chentoast/marks.nvim",
  keys = {
    {
      "m",
      function() require("marks").set() end,
      desc = "Set mark",
    },
    {
      "dm",
      function() require("marks").delete() end,
      desc = "Delete mark",
    },
    {
      "<leader>ma",
      function() require("marks").set_next() end,
      desc = "[M]arks: [A]dd mark",
    },
    {
      "<leader>mp",
      function() require("marks").preview() end,
      desc = "[M]arks: [P]review mark",
    },
    {
      "<leader>md",
      function() require("marks").delete_line() end,
      desc = "[M]arks: [D]elete line marks",
    },
    {
      "<leader>mc",
      function() require("marks").delete_buf() end,
      desc = "[M]arks: [C]lear buffer marks",
    },
    {
      "<leader>mm",
      function() vim.cmd("MarksToggleSigns") end,
      desc = "[M]arks: toggle signs",
    },
  },
  opts = {
    -- Default mappings are not integrated with Which Key &, being so close to the builtin `m`
    -- keymap, they require some keymaps to be pressed in a short time span
    default_mappings = false,
  },
  config = function(_, opts)
    local marks = require("marks")

    marks.setup(opts)

    local utils = require("utils")
    local mpmap = utils.keymap.mpmap

    mpmap({ "[`", "]`" }, {
      -- marks.next & marks.prev throw errors when there are no marks, so we need to handle this
      function() pcall(require("marks").next) end,
      function() pcall(require("marks").prev) end,
    }, { "Next mark", "Previous mark" })
  end,
}
