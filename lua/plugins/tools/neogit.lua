-- Neogit
--
-- A Magit clone for Neovim. This plugins provides a modern UI to interact with Git.

local actions = require("actions")

return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    -- Neogit buffers are not detected by "BufNewFile" or "BufReadPre" event, so to enable plugins
    -- relevant to write commit messages for instance, let's add them manually
    "hrsh7th/nvim-cmp",
    "github/copilot.vim",
  },
  keys = {
    { "<leader>gm", actions.git_menu, desc = "[G]it: [M]enu" },
  },
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
