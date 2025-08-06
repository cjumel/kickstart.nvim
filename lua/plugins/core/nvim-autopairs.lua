-- nvim-autopairs
--
-- A super powerful autopair plugin for Neovim that supports multiple characters.

return {
  "windwp/nvim-autopairs",
  lazy = true,
  init = function() -- Setup custom lazy-loading event
    vim.api.nvim_create_autocmd("InsertEnter", {
      callback = function()
        if not vim.tbl_contains({ "snacks_picker_input", "grug-far" }, vim.bo.filetype) then
          Lazy.load({ plugins = { "nvim-autopairs" } })
        end
      end,
    })
  end,
  opts = {
    disable_filetype = { "snacks_picker_input", "grug-far" },
  },
}
