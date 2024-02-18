-- Neorg
--
-- Modernity meets insane extensibility. The future of organizing your life in Neovim.

return {
  "nvim-neorg/neorg",
  build = ":Neorg sync-parsers",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  ft = { "norg" },
  opts = {
    load = {
      ["core.defaults"] = {}, -- Loads default behaviour
      ["core.keybinds"] = { -- Loads default behaviour
        config = {
          hook = function(keybinds)
            -- Unmaps any Neorg key from the `norg` mode
            keybinds.unmap("norg", "n", "<M-CR>") -- Prefer Harpoon keymap
            keybinds.unmap("norg", "n", keybinds.leader .. "th") -- Prefer ToggleTerm keymap
          end,
        },
      },
      ["core.concealer"] = {}, -- Adds pretty icons to your documents
    },
  },
}
