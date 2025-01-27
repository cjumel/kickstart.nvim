-- treewalker.nvim
--
-- A neovim plugin for moving around your code in a syntax tree aware manner.

return {
  "aaronik/treewalker.nvim",
  keys = {
    {
      "Ì", -- <M-h>
      "<cmd>Treewalker Left<cr>",
      mode = { "n", "v" },
      desc = "Move to the line first ancestor node",
    },
    {
      "Ï", -- <M-j>
      "<cmd>Treewalker Down<cr>",
      mode = { "n", "v" },
      desc = "Move to the line next neighboring node",
    },
    {
      "È", -- <M-k>
      "<cmd>Treewalker Up<cr>",
      mode = { "n", "v" },
      desc = "Move to the line previous neighboring node",
    },
    {
      "|", -- <M-l>
      "<cmd>Treewalker Right<cr>",
      mode = { "n", "v" },
      desc = "Move to the line first child node",
    },
    {
      "Î", -- <M-S-h>
      "<cmd>Treewalker SwapLeft<cr>",
      mode = { "n", "v" },
      desc = "Swap the cursor node with its previous neighbor",
    },
    {
      "Í", -- <M-S-j>
      "<cmd>Treewalker SwapDown<cr>",
      mode = { "n", "v" },
      desc = "Swap the line node downward",
    },
    {
      "Ë", -- <M-S-k>
      "<cmd>Treewalker SwapUp<cr>",
      mode = { "n", "v" },
      desc = "Swap the line node upward",
    },
    {
      "¬", -- <M-S-l>
      "<cmd>Treewalker SwapRight<cr>",
      mode = { "n", "v" },
      desc = "Swap the cursor node with its next neighbor",
    },
  },
  opts = {},
}
