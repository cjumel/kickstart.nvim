-- Neogit
--
-- Neogit provides an interactive and powerful Git interface for Neovim, inspired by Magit. It is very nicely
-- complementary with Gitsigns, and is my go-to tool for any Git-related action that goes beyond a simple buffer, like
-- committing or rebasing.

return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "nvim-telescope/telescope.nvim",
  },
  init = function()
    -- Customize the Neogit command to close zen-mode before opening Neogit
    vim.api.nvim_create_user_command("NeogitCustom", function()
      -- If zen-mode is loaded, close it before counting windows as it will be closed anyway & might mess things up
      local zen_mode = package.loaded["zen-mode"]
      if zen_mode ~= nil then
        zen_mode.close()
      end
      require("neogit").open()
    end, {})
  end,
  keys = { { "<leader>gm", "<cmd>NeogitCustom<CR>", desc = "[G]it: [M]enu" } },
  opts = {
    use_default_keymaps = false,
    disable_hint = true,
    kind = "tab",
    commit_view = { kind = "tab" },
    commit_editor = { kind = "split" },
    rebase_editor = { kind = "split" },
    mappings = {
      commit_editor = {
        ["q"] = "Close",
        ["<c-c><c-c>"] = "Submit",
        ["<c-c><c-k>"] = "Abort",
        ["<m-p>"] = "PrevMessage",
        ["<m-n>"] = "NextMessage",
        ["<m-r>"] = "ResetMessage",
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
        ["gb"] = "BranchPopup",
        ["gc"] = "CommitPopup",
        ["gd"] = "DiffPopup",
        ["gf"] = "FetchPopup",
        ["gl"] = "LogPopup",
        ["gsh"] = "StashPopup",
        ["gpl"] = "PullPopup",
        ["gps"] = "PushPopup",
        ["grb"] = "RebasePopup",
        ["grs"] = "ResetPopup",
        ["grv"] = "RevertPopup",
        ["gw"] = "WorktreePopup",
        ["?"] = "HelpPopup",
      },
      status = {
        ["q"] = "Close",
        ["s"] = "Stage",
        ["S"] = "StageUnstaged",
        ["<C-s>"] = "StageAll",
        ["u"] = "Unstage",
        ["U"] = "UnstageStaged",
        ["x"] = "Discard",
        ["$"] = "CommandHistory",
        ["#"] = "Console",
        ["<CR>"] = "GoToFile",
        ["<Tab>"] = "Toggle",
        ["<C-r>"] = "RefreshBuffer",
        ["<C-v>"] = "VSplitOpen",
        ["<C-x>"] = "SplitOpen",
        [","] = "GoToNextHunkHeader",
        [";"] = "GoToPreviousHunkHeader",
      },
    },
  },
}
