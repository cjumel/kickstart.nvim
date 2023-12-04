-- Which Key
--
-- Show the available keymaps once you start writink a few keys, the marks and registers.

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  keys = {
    {
      "<C-]>", -- Actually <C-%> on my setup
      function()
        vim.cmd("WhichKey '' n")
      end,
      mode = { "n" },
      desc = "Which key",
    },
    {
      "<C-]>", -- Actually <C-%> on my setup
      function()
        vim.cmd("WhichKey '' i")
      end,
      mode = { "i" },
      desc = "Which key",
    },
    {
      "<C-]>", -- Actually <C-%> on my setup
      function()
        vim.cmd("WhichKey '' v")
      end,
      mode = { "v" },
      desc = "Which key",
    },
  },
  opts = {
    window = {
      border = "single",
    },
  },
  config = function(_, opts)
    require("which-key").setup(opts)

    -- document existing key chains
    require("which-key").register({
      ["<leader>d"] = { name = "[D]ebug", _ = "which_key_ignore" },
      ["<leader>dp"] = { name = "[D]ebug [P]ython", _ = "which_key_ignore" },
      ["<leader>D"] = { name = "[D]atabase", _ = "which_key_ignore" },
      ["<leader>f"] = { name = "[F]ind", _ = "which_key_ignore" },
      ["<leader>l"] = { name = "[L]SP", _ = "which_key_ignore" },
      ["<leader>o"] = { name = "[O]verseer", _ = "which_key_ignore" },
      ["<leader>t"] = { name = "[T]oggle", _ = "which_key_ignore" },
      ["<leader>x"] = { name = "Trouble", _ = "which_key_ignore" },
    })
  end,
}
