return {
  "folke/lazydev.nvim",
  ft = "lua",
  opts = {
    library = {
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      { path = "conform.nvim", words = { "conform%." } },
      { path = "snacks.nvim", words = { "Snacks%." } },
      { path = vim.fn.stdpath("config"), words = { "nvim_config%." } },
    },
  },
}
