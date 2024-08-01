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
  cmd = { "Neogit" }, -- To open Neogit directly from outside Neovim
  keys = {
    {
      "&", -- Similar (in terms of key position) to "-" for Oil
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
        -- Replace "gj" & "gk" to move up or down a commit by the unused "J" and "K"
        ["gk"] = false,
        ["K"] = "MoveUp",
        ["gj"] = false,
        ["J"] = "MoveDown",
      },
      popup = {
        -- Simplify or modify some of the default shortcuts
        ["D"] = false,
        ["d"] = "DiffPopup",
        ["X"] = false,
        ["R"] = "ResetPopup",
        ["Z"] = false,
        ["z"] = "StashPopup",
      },
      status = {
        ["<C-c>"] = "Close", -- Close Neogit with <C-c> (as well as with "q")
        -- Replace "{" & "}" to navigate between hunks by the unused "," & ";"
        ["{"] = false,
        [";"] = "GoToPreviousHunkHeader",
        ["}"] = false,
        [","] = "GoToNextHunkHeader",
        -- Use the unused "J" & "K" to navigate between sections
        ["J"] = function() vim.cmd.normal("}j") end,
        ["K"] = function()
          if vim.api.nvim_win_get_cursor(0)[1] > 5 then -- Avoid jumping to the heading section
            vim.cmd.normal("k{j")
          end
        end,
      },
    },
  },
}
