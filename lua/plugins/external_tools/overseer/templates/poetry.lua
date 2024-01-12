return {
  {
    name = "Poetry install",
    tags = { "poetry" },
    builder = function()
      return {
        cmd = { "poetry", "install" },
        name = "Poetry install",
      }
    end,
  },
  {
    name = "Poetry update",
    tags = { "poetry" },
    builder = function()
      return {
        cmd = { "poetry", "update" },
        name = "Poetry update",
      }
    end,
  },
}
