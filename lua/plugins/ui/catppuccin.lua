-- Catppuccin
--
-- Catppuccin is a color scheme compatible with many tools, including neovim, and defining
-- different tones from light to dark.

return {
  "catppuccin/nvim",
  dependencies = {
    "folke/which-key.nvim",
  },
  name = "catppuccin",
  priority = 1000, -- Main UI stuff should be loaded first
  config = function()
    -- setup must be called before loading
    require("catppuccin").setup({
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      background = {
        light = "latte",
        dark = "mocha",
      },
      integrations = { -- add highlight groups for popular plugins
        fidget = true,
        harpoon = true,
        hop = true,
        mason = true,
        noice = true,
        notify = true,
        lsp_trouble = true,
        which_key = true,
      },
    })

    vim.cmd.colorscheme("catppuccin")

    require("which-key").register({
      ["<leader>u"] = { name = "[U]I", _ = "which_key_ignore" },
    })

    vim.keymap.set("n", "<leader>ud", function()
      vim.cmd("set background=dark")
    end, { desc = "[U]I: [D]ark theme" })
    vim.keymap.set("n", "<leader>ul", function()
      vim.cmd("set background=light")
    end, { desc = "[U]I: [L]ight theme" })
  end,
}
