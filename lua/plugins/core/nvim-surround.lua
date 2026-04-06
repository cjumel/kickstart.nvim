return {
  "kylechui/nvim-surround",
  keys = {
    { "ys", desc = "Add surrounds" },
    { "cs", desc = "Change surrounds" },
    { "ds", desc = "Delete surrounds" },
    { "S", mode = "x", desc = "Add surrounds" },
  },
  opts = {
    -- Remove the white spaces introduced when using some of the surrounds
    surrounds = { ["("] = false, ["["] = false, ["{"] = false, ["<"] = false },
    aliases = { ["("] = ")", ["["] = "]", ["{"] = "}", ["<"] = ">" },
  },
}
