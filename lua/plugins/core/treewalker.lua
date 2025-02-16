-- treewalker.nvim
--
-- A neovim plugin for moving around your code in a syntax tree aware manner. It provides a very ice way to navigate
-- through the code and move pieces around, fully using the power of Treesitter.

return {
  "aaronik/treewalker.nvim",
  keys = {
    { "Ì", "<cmd>Treewalker Left<CR>", mode = { "n", "v" }, desc = "Move to the line first ancestor node" }, -- <M-h>
    { "Ï", "<cmd>Treewalker Down<CR>", mode = { "n", "v" }, desc = "Move to the line next neighboring node" }, -- <M-j>
    { "È", "<cmd>Treewalker Up<CR>", mode = { "n", "v" }, desc = "Move to the line previous neighboring node" }, -- <M-k>
    { "|", "<cmd>Treewalker Right<CR>", mode = { "n", "v" }, desc = "Move to the line first child node" }, -- <M-l>
    { "Î", "<cmd>Treewalker SwapLeft<CR>", desc = "Swap the cursor node with its previous neighbor" }, -- <M-S-h>
    { "Í", "<cmd>Treewalker SwapDown<CR>", desc = "Swap the line node downward" }, -- <M-S-j>
    { "Ë", "<cmd>Treewalker SwapUp<CR>", desc = "Swap the line node upward" }, -- <M-S-k>
    { "¬", "<cmd>Treewalker SwapRight<CR>", desc = "Swap the cursor node with its next neighbor" }, -- <M-S-l>
  },
  opts = {},
}
