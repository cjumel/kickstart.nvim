-- catpuccin
--
-- Catpuccin is a color scheme defining different tones as flavors.

local create_user_cmd = function()
  vim.api.nvim_create_user_command("SetLightTheme", function()
    vim.cmd("set background=light")
  end, { desc = "Set light theme" })
  vim.api.nvim_create_user_command("SetDarkTheme", function()
    vim.cmd("set background=dark")
  end, { desc = "Set dark theme" })
end

return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000, -- UI stuff should be loaded first
  init = function()
    create_user_cmd()
  end,
  config = function()
    create_user_cmd()

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
  end,
}
