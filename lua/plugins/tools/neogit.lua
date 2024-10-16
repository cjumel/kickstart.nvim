-- Neogit
--
-- Neogit provides an interactive and powerful Git interface for Neovim, inspired by Magit. It is very complementary
-- with Gitsigns and is my go-to tool for any Git-related action that goes beyond staging, unstaging and discarding
-- changes in a single buffer, like committing or rebasing, while not leaving Neovim.

return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
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
    commit_view = { kind = "tab" }, -- Decrease visual clutter when using this view
    rebase_editor = { kind = "tab" }, -- Decrease visual clutter when using this view
    mappings = {
      rebase_editor = {
        -- Change the "move up" keymap for something easier to type repeatedly
        ["gk"] = false,
        ["K"] = "MoveUp",
        -- Change the "move down" keymap for something easier to type repeatedly
        ["gj"] = false,
        ["J"] = "MoveDown",
      },
      popup = {
        -- Change the "pull popup" keymap
        ["p"] = false,
        ["pl"] = "PullPopup",
        -- Change the "push popup" keymap
        ["P"] = false,
        ["ps"] = "PushPopup",
        -- Change the "rebase popup" keymap
        ["r"] = false,
        ["rb"] = "RebasePopup",
        -- Change the "reset popup" keymap
        ["X"] = false,
        ["rs"] = "ResetPopup",
        -- Change the "revert popup" keymap
        ["v"] = false,
        ["rv"] = "RevertPopup",
        -- Change the "stash popup" keymap. The "z" keymap is used in Neogit for folding, but it doesn't work well in my
        --  setup and I don't use it in practice so let's overwrite it.
        ["Z"] = false,
        ["z"] = "StashPopup",
      },
      status = {
        -- Change the "go to previous hunk" keymap
        ["{"] = false,
        [";"] = "GoToPreviousHunkHeader",
        -- Change the "go to next hunk" keymap
        ["}"] = false,
        [","] = "GoToNextHunkHeader",
        -- Add new keymaps
        ["<C-c>"] = "Close",
      },
    },
  },
}
