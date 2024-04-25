-- substitute.nvim
--
-- Plugin aiming to provide new operator motions to make it very easy to perform quick substitutions and exchange.

return {
  "gbprod/substitute.nvim",
  keys = {
    { "gs", function() require("substitute").operator() end, desc = "Substitute" },
    { "gsc", function() require("substitute").line() end, desc = "Substitute current line" },
    { "gs", function() require("substitute").visual() end, mode = "x", desc = "Substitute" },
    { "gS", function() require("substitute.range").operator() end, desc = "Substitute in buffer" },
    { "gSc", function() require("substitute.range").word() end, desc = "Substitute current word in buffer" },
    { "gS", function() require("substitute.range").visual_range() end, mode = "x", desc = "Substitute in buffer" },
    { "gw", function() require("substitute.exchange").operator() end, desc = "Swap" },
    { "gwc", function() require("substitute.exchange").line() end, desc = "Swap current line" },
    { "gw", function() require("substitute.exchange").visual() end, mode = "x", desc = "Swap" },
  },
  opts = {
    range = {
      subject = {
        last_search = true, -- Quite natural as it provides a visual feedback of what will be replaced
      },
    },
  },
}
