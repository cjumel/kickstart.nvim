-- Neogit
--
-- Neogit provides an interactive and powerful Git interface for Neovim, inspired by Magit. It is very complementary
-- with Gitsigns, the other Git-related plugin I use, and is my go-to tool for any Git-related action that goes beyond
-- staging, unstaging and discarding changes in a single buffer, like committing or rebasing.

return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "nvim-telescope/telescope.nvim",
  },
  keys = {
    {
      "<leader>;", -- No mnemonic for this keymap, but simple and unused
      function()
        -- If zen-mode is loaded, close it before counting windows as it will be closed anyway & might mess things up
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
    disable_hint = true, -- Remove always-on visual help in Neogit window
    commit_view = { kind = "tab" }, -- Decrease visual clutter when using this view
    rebase_editor = { kind = "tab" }, -- Decrease visual clutter when using this view
    mappings = {
      rebase_editor = {
        ["gk"] = false,
        ["<C-p>"] = "MoveUp",
        ["gj"] = false,
        ["<C-n>"] = "MoveDown",
      },
      popup = {
        ["D"] = false,
        ["d"] = "DiffPopup",
        ["X"] = false,
        ["R"] = "ResetPopup",
        ["Z"] = false,
        ["z"] = "StashPopup",
      },
      status = {
        ["<C-c>"] = "Close",
        ["{"] = false,
        [";"] = "GoToPreviousHunkHeader",
        ["}"] = false,
        [","] = "GoToNextHunkHeader",
      },
    },
  },
}
