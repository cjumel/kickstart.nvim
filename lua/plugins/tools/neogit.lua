-- Neogit
--
-- Neogit provides an interactive and powerful Git interface for Neovim, inspired by Magit. It is very complementary
-- with Gitsigns and is my go-to tool for any Git-related action that goes beyond staging, unstaging and discarding
-- changes in a single buffer, like committing or rebasing, while not leaving Neovim.

return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  keys = {
    {
      "&", -- Similar (in terms of key position) to "-" for Oil
      function()
        -- If zen-mode is loaded, close it before opening Neogit as it messes it up
        local zen_mode = package.loaded["zen-mode"]
        if zen_mode ~= nil then
          zen_mode.close()
        end
        require("neogit").open()
      end,
      desc = "Neogit",
    },
  },
  opts = {
    commit_editor = { spell_check = false },
    commit_view = { kind = "tab" }, -- Decrease visual clutter
    rebase_editor = { kind = "tab" }, -- Decrease visual clutter
    mappings = {
      rebase_editor = {
        -- Change the "move commit" keymaps for something easier to type repeatedly
        ["gk"] = false, -- Formely "MoveUp"
        ["<C-p>"] = "MoveUp",
        ["gj"] = false, -- Formerly "MoveDown"
        ["<C-n>"] = "MoveDown",
      },
      finder = {
        -- Change some keymaps for more compatibility with telescope.nvim keymaps
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
        [";"] = "GoToPreviousHunkHeader",
        ["}"] = false, -- Formerly "GoToNextHunkHeader"
        [","] = "GoToNextHunkHeader",
        -- Add new keymaps
        ["<C-c>"] = "Close",
      },
    },
  },
}
