local tags = { "python", "poetry" }

return {
  {
    name = "Poetry install",
    builder = function()
      return {
        cmd = { "poetry", "install" },
      }
    end,
    desc = "Install the Poetry environment",
    tags = tags,
  },
  {
    name = "Poetry update",
    builder = function()
      return {
        cmd = { "poetry", "update" },
      }
    end,
    desc = "Update the Poetry environment",
    tags = tags,
  },
  {
    name = "Poetry add",
    builder = function(params)
      return {
        cmd = { "poetry", "add", params.args },
      }
    end,
    desc = "Add a package to the Poetry environment",
    tags = tags,
  },
}
