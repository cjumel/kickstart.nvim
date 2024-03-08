-- telescope-ui-select.nvim
--
-- Sets vim.ui.select to use Telescope, meaning that any Neovim function (even core ones) can use
-- the Telescope picker.

return {
  "nvim-telescope/telescope-ui-select.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  event = "VeryLazy",
  config = function()
    local telescope = require("telescope")

    telescope.setup({
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown(),
        },
      },
    })

    telescope.load_extension("ui-select")
  end,
}
