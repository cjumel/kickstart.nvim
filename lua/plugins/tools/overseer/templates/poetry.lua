local tags = { "python", "poetry" }

return {
  {
    name = "Poetry install",
    params = {
      args = {
        type = "string",
        desc = "The additional arguments to pass to the command",
        optional = true,
        order = 1,
      },
    },
    builder = function(params)
      return {
        cmd = { "poetry", "install", params.args },
      }
    end,
    tags = tags,
  },
  {
    name = "Poetry update",
    params = {
      args = {
        type = "string",
        desc = "The additional arguments to pass to the command",
        optional = true,
        order = 1,
      },
    },
    builder = function(params)
      return {
        cmd = { "poetry", "update", params.args },
      }
    end,
    tags = tags,
  },
  {
    name = "Poetry add",
    params = {
      package = {
        type = "string",
        desc = "Name of the package to add",
        optional = false,
        order = 1,
      },
      args = {
        type = "string",
        desc = "The additional arguments to pass to the command",
        optional = true,
        order = 2,
      },
    },
    builder = function(params)
      return {
        cmd = { "poetry", "add", params.package, params.args },
      }
    end,
    tags = tags,
  },
}
