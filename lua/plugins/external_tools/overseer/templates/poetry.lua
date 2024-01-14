return {
  {
    name = "Poetry install",
    tags = { "python", "poetry" },
    builder = function()
      return {
        cmd = { "poetry", "install" },
      }
    end,
  },
  {
    name = "Poetry update",
    tags = { "python", "poetry" },
    builder = function()
      return {
        cmd = { "poetry", "update" },
      }
    end,
  },
}
