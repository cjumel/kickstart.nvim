return {
  "kylechui/nvim-surround",
  event = "VeryLazy",
  opts = {
    -- Remove the white spaces introduced when using some of the surrounds
    surrounds = { ["("] = false, ["["] = false, ["{"] = false, ["<"] = false },
    aliases = { ["("] = ")", ["["] = "]", ["{"] = "}", ["<"] = ">" },
  },
}
