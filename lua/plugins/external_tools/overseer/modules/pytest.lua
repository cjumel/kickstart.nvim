return {
  keychains = {
    ["<leader>ope"] = { name = "[O]verseer: [P]yt[E]st", _ = "which_key_ignore" },
    ["<leader>opem"] = { name = "[O]verseer: [P]yt[E]st [M]arked as", _ = "which_key_ignore" },
  },
  keymaps = {
    {
      "<leader>opea",
      function()
        require("overseer").run_template({ name = "Pytest all" })
      end,
      desc = "[O]verseer: [P]yt[E]st [A]ll",
    },
    {
      "<leader>opef",
      function()
        require("overseer").run_template({ name = "Pytest file" })
      end,
      desc = "[O]verseer: [P]yt[E]st [F]ile",
    },
    {
      "<leader>opemf",
      function()
        require("overseer").run_template({ name = "Pytest fast" })
      end,
      desc = "[O]verseer: [P]yt[E]st [M]arked as [F]ast",
    },
    {
      "<leader>opems",
      function()
        require("overseer").run_template({ name = "Pytest slow" })
      end,
      desc = "[O]verseer: [P]yt[E]st [M]arked as [S]low",
    },
  },
  templates = {
    {
      name = "Pytest all",
      builder = function()
        return {
          cmd = { "pytest" },
        }
      end,
    },
    {
      name = "Pytest file",
      builder = function()
        return {
          cmd = { "pytest", vim.fn.expand("%:p") },
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
        }
      end,
    },
    {
      name = "Pytest slow",
      builder = function()
        return {
          cmd = { "pytest", "-m", "slow" },
        }
      end,
    },
  },
}
