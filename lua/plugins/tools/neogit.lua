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
    disable_hint = true, -- Don't always show help hint
    -- FIXME: the plugin would be better with custom keymaps, but I have some issues implementing them:
    --  - when disabling default mappings & copy pasting the default ones from the documentation, some issues
    --    arrise (they can be adressed by looking into the error trace & the source code of the plugin)
    --  - once the issues above are solved, committing stopped working; this is maybe linked to
    --    https://github.com/NeogitOrg/neogit/issues/1342
    use_default_keymaps = true, -- Implementing custom keymaps make the plugin break often when updating it
    commit_view = { kind = "tab" }, -- Use "tab" view instead of "split", to decrease visual clutter
    rebase_editor = { kind = "tab" }, -- Use "tab" view instead of "auto", to decrease visual clutter
  },
}
