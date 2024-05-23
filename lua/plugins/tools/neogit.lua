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
    -- Let's create a user command so that it can be used from Gitsigns as well
    vim.api.nvim_create_user_command("NeogitCustom", function()
      -- If zen-mode is loaded, close it before counting windows as it will be closed anyway & might mess things up
      local zen_mode = package.loaded["zen-mode"]
      if zen_mode ~= nil then
        zen_mode.close()
      end
      require("neogit").open()
    end, { desc = "Open Neogit" })
  end,
  keys = { { "<leader>gn", "<cmd>NeogitCustom<CR>", desc = "[G]it: [N]eogit" } },
  opts = {
    disable_hint = true, -- Don't always show help hint
    use_default_keymaps = true, -- Implementing custom keymaps make the plugin break often when updating it
    commit_view = { kind = "tab" }, -- Use "tab" view instead of "split", to decrease visual clutter
    rebase_editor = { kind = "tab" }, -- Use "tab" view instead of "auto", to decrease visual clutter
  },
}
