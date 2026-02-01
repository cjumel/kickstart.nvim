-- ISSUE: in recent versions, lazydev.nvim does not work well with LuaLS at a version strictly greater than 3.16.4 (see
-- this issue: https://github.com/folke/lazydev.nvim/issues/136); to install a working version of LuaLS, run:
-- `:MasonInstall lua-language-server@3.16.4`
return {
  "folke/lazydev.nvim",
  ft = "lua",
  opts = {
    library = {
      { path = "conform.nvim", words = { "conform%." } },
      { path = "snacks.nvim", words = { "Snacks%." } },
      { path = vim.fn.stdpath("config"), words = { "nvim_config%." }}
    },
  },
}
