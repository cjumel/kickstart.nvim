return {
  name = "Update poetry package",
  builder = function()
    return {
      cmd = { "poetry", "update" },
    }
  end,
  condition = {
    filetype = { "toml" },
  },
}
