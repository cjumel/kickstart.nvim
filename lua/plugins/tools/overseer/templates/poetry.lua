local tags = { "python", "poetry" }

return {
  {
    name = "Poetry install",
    builder = function()
      return {
        cmd = { "poetry", "install" },
      }
    end,
    tags = tags,
  },
  {
    name = "Poetry update",
    builder = function()
      return {
        cmd = { "poetry", "update" },
      }
    end,
    tags = tags,
  },
}
