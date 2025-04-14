-- Neogit
--
-- Neogit provides an interactive and powerful Git interface for Neovim, inspired by Magit. It is very complementary
-- with Gitsigns and is my go-to tool for any Git-related action that goes beyond staging, unstaging and discarding
-- changes in a single buffer, like committing or rebasing, while not leaving Neovim.

return {
  "NeogitOrg/neogit",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = { { "<leader>gn", function() require("neogit").open() end, desc = "[G]it: [N]eogit" } },
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
        [";"] = "GoToPreviousHunkHeader",
        ["}"] = false, -- Formerly "GoToNextHunkHeader"
        [","] = "GoToNextHunkHeader",
      },
    },
  },
  config = function(_, opts)
    require("neogit").setup(opts)

    -- Customize commit view keymaps
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "NeogitCommitView",
      group = vim.api.nvim_create_augroup("NeogitKeymaps", { clear = true }),
      callback = function()
        vim.keymap.set("n", ",", "}", { desc = "Next hunk", remap = true, buffer = true })
        vim.keymap.set("n", ";", "{", { desc = "Previous hunk", remap = true, buffer = true })
      end,
    })
  end,
}
