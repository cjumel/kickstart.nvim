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
    -- NOTE: once the plugin (and especially the management of custom keymaps) is more stable, let's re-implement custom
    --  keymaps
    use_default_keymaps = true, -- Implementing custom keymaps make the plugin break often when updating it
    commit_view = { kind = "tab" }, -- Use "tab" view instead of "split", to decrease visual clutter
    rebase_editor = { kind = "tab" }, -- Use "tab" view instead of "auto", to decrease visual clutter
  },
}
