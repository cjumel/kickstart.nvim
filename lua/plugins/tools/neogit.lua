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
    disable_hint = true,
    use_default_keymaps = false,
    commit_view = { kind = "tab" }, -- Decrease visual clutter when using this view
    rebase_editor = { kind = "tab" }, -- Decrease visual clutter when using this view
    mappings = {
      commit_editor = {
        ["q"] = "Close",
        ["<c-c><c-c>"] = "Submit",
        ["<c-c><c-k>"] = "Abort",
        ["<c-c><c-p>"] = "PrevMessage", -- Forgotten in the documentation but mandatory to define
        ["<c-c><c-n>"] = "NextMessage", -- Forgotten in the documentation but mandatory to define
        ["<c-c><c-r>"] = "ResetMessage", -- Forgotten in the documentation but mandatory to define
      },
      commit_editor_I = {
        ["<c-c><c-c>"] = "Submit",
        ["<c-c><c-k>"] = "Abort",
      },
      rebase_editor = {
        ["p"] = "Pick",
        ["r"] = "Reword",
        ["e"] = "Edit",
        ["s"] = "Squash",
        ["f"] = "Fixup",
        ["x"] = "Execute",
        ["d"] = "Drop",
        ["b"] = "Break",
        ["q"] = "Close",
        ["<cr>"] = "OpenCommit",
        ["gk"] = "MoveUp",
        ["gj"] = "MoveDown",
        ["<c-c><c-c>"] = "Submit",
        ["<c-c><c-k>"] = "Abort",
        ["[c"] = "OpenOrScrollUp",
        ["]c"] = "OpenOrScrollDown",
      },
      rebase_editor_I = {
        ["<c-c><c-c>"] = "Submit",
        ["<c-c><c-k>"] = "Abort",
      },
      finder = {
        ["<cr>"] = "Select",
        ["<c-c>"] = "Close",
        ["<esc>"] = "Close",
        ["<c-n>"] = "Next",
        ["<c-p>"] = "Previous",
        ["<down>"] = "Next",
        ["<up>"] = "Previous",
        ["<tab>"] = "MultiselectToggleNext",
        ["<s-tab>"] = "MultiselectTogglePrevious",
        ["<c-j>"] = "NOP",
      },
      popup = {
        ["?"] = "HelpPopup",
        ["A"] = "CherryPickPopup",
        ["d"] = "DiffPopup",
        ["M"] = "RemotePopup",
        ["ps"] = "PushPopup",
        ["rs"] = "ResetPopup",
        ["z"] = "StashPopup",
        ["b"] = "BranchPopup",
        ["B"] = "BisectPopup",
        ["c"] = "CommitPopup",
        ["f"] = "FetchPopup",
        ["l"] = "LogPopup",
        ["m"] = "MergePopup",
        ["pl"] = "PullPopup",
        ["rb"] = "RebasePopup",
        ["rv"] = "RevertPopup",
        ["w"] = "WorktreePopup",
      },
      status = {
        ["k"] = "MoveUp",
        ["j"] = "MoveDown",
        ["q"] = "Close",
        ["o"] = "OpenTree",
        ["I"] = "InitRepo",
        ["1"] = "Depth1",
        ["2"] = "Depth2",
        ["3"] = "Depth3",
        ["4"] = "Depth4",
        ["<tab>"] = "Toggle",
        ["x"] = "Discard",
        ["s"] = "Stage",
        ["S"] = "StageUnstaged",
        ["<c-s>"] = "StageAll",
        ["K"] = "Untrack",
        ["u"] = "Unstage",
        ["U"] = "UnstageStaged",
        ["$"] = "CommandHistory",
        ["R"] = "ShowRefs", -- Forgotten in the documentation but mandatory to define
        ["Y"] = "YankSelected",
        ["<c-r>"] = "RefreshBuffer",
        ["<enter>"] = "GoToFile",
        ["<c-v>"] = "VSplitOpen",
        ["<c-x>"] = "SplitOpen",
        ["<c-t>"] = "TabOpen",
        [";"] = "GoToPreviousHunkHeader",
        [","] = "GoToNextHunkHeader",
        ["[c"] = "OpenOrScrollUp",
        ["]c"] = "OpenOrScrollDown",
      },
    },
  },
}
