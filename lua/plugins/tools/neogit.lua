return {
  "NeogitOrg/neogit",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = { { "<leader>gm", function() require("neogit").open() end, desc = "[G]it: [M]enu" } },
  opts = {
    commit_editor = { spell_check = false },
    mappings = {
      rebase_editor = {
        -- Change the "move commit" keymaps for something easier to type repeatedly
        ["gk"] = false, -- Formely "MoveUp"
        ["K"] = "MoveUp",
        ["gj"] = false, -- Formerly "MoveDown"
        ["J"] = "MoveDown",
      },
      finder = {
        -- Change some keymaps for more compatibility with picker keymaps
        ["<Tab>"] = "Next", -- Formely "MultiselectToggleNext"
        ["<S-Tab>"] = "Previous", -- Formely "MultiselectTogglePrevious"
      },
      popup = {
        -- Stick to "r" prefix for some popups, for consistency with Git aliases
        ["r"] = false, -- Formerly "RebasePopup"
        ["rb"] = "RebasePopup",
        ["X"] = false, -- Formerly "ResetPopup"
        ["rs"] = "ResetPopup",
        ["v"] = false, -- Formerly "RevertPopup"
        ["rv"] = "RevertPopup",
      },
      status = {
        -- Change the "next/previous hunk" keymaps for something easier to type quickly
        ["{"] = false, -- Formerly "GoToPreviousHunkHeader"
        [","] = "GoToPreviousHunkHeader",
        ["}"] = false, -- Formerly "GoToNextHunkHeader"
        [";"] = "GoToNextHunkHeader",
      },
    },
  },
}
