return {
  {
    name = "Pytest all",
    builder = function()
      return {
        cmd = { "pytest" },
        name = "Pytest all",
      }
    end,
  },
  {
    name = "Pytest file",
    builder = function()
      return {
        cmd = { "pytest", vim.fn.expand("%:p") },
        name = "Pytest file",
      }
    end,
    condition = {
      dir = vim.fn.getcwd() .. "/tests", -- Only run if we're in the tests directory
      filetype = { "python" },
    },
  },
  {
    name = "Pytest fast",
    builder = function()
      return {
        cmd = { "pytest", "-m", "not slow" },
        name = "Pytest fast",
      }
    end,
  },
  {
    name = "Pytest slow",
    builder = function()
      return {
        cmd = { "pytest", "-m", "slow" },
        name = "Pytest slow",
      }
    end,
  },
}
