-- There is a builtin template for cargo, but it adds too many things to my taste, and it doesn't use some tags that I
-- use, so I prefer re-implementing a simpler version of it

return {
  name = "cargo",
  condition = {
    callback = function(_)
      if vim.fn.executable("cargo") == 0 then
        return false
      end

      return not vim.tbl_isempty(vim.fs.find("Cargo.toml", {
        type = "file",
        path = vim.fn.getcwd(),
        upward = true, -- Search in the current directory and its ancestors
        stop = vim.env.HOME,
      }))
    end,
  },
  generator = function(_, cb)
    cb({
      {
        name = "cargo check",
        tags = { "CHECK" },
        builder = function(_)
          return {
            cmd = { "cargo", "check" },
          }
        end,
      },
      {
        name = "cargo build",
        tags = { "BUILD" },
        builder = function(_)
          return {
            cmd = { "cargo", "build" },
          }
        end,
      },
      {
        name = "cargo run",
        tags = { "RUN" },
        builder = function(_)
          return {
            cmd = { "cargo", "run" },
          }
        end,
      },
    })
  end,
}
