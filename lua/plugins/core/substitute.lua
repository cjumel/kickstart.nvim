-- substitute.nvim
--
-- Plugin aiming to provide new operator motions to make it very easy to perform quick substitions and exchange.

return {
  "gbprod/substitute.nvim",
  keys = {
    { "gs", function() require("substitute").operator() end, desc = "Substitute" },
    { "gsc", function() require("substitute").line() end, desc = "Substitute current line" },
    { "gs", function() require("substitute").visual() end, mode = "x", desc = "Substitute" },
  },
  opts = {},
}
