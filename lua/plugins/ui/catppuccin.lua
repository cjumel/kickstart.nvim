-- Catppuccin
--
-- Catppuccin is a color scheme compatible with many tools, including neovim, and defining
-- different tones from light to dark.

return {
  "catppuccin/nvim",
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

    vim.api.nvim_create_user_command("SwitchTheme", function()
      if vim.o.background == "dark" then
        vim.cmd("set background=light")
      else
        vim.cmd("set background=dark")
      end
    end, { desc = "Switch between light and dark themes" })
  end,
}
