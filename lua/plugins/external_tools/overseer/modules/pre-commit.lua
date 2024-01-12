return {
  keychains = {
    ["<leader>opc"] = { name = "[O]verseer: [P]re-[C]ommit", _ = "which_key_ignore" },
    ["<leader>opcr"] = { name = "[O]verseer: [P]re-[C]ommit [R]un", _ = "which_key_ignore" },
  },
  keymaps = {
    {
      "<leader>opci",
      function()
        require("overseer").run_template({ name = "Pre-commit install" })
      end,
      desc = "[O]verseer: [P]re-[C]ommit [I]nstall",
    },
    {
      "<leader>opcra",
      function()
        require("overseer").run_template({ name = "Pre-commit run all files" })
      end,
      desc = "[O]verseer: [P]re-[C]ommit [R]un [A]ll files",
    },
    {
      "<leader>opcrd",
      function()
        require("overseer").run_template({ name = "Pre-commit run directory" })
      end,
      desc = "[O]verseer: [P]re-[C]ommit [R]un [D]irectory",
    },
    {
      "<leader>opcrf",
      function()
        require("overseer").run_template({ name = "Pre-commit run file" })
      end,
      desc = "[O]verseer: [P]re-[C]ommit [R]un [F]ile",
    },
  },
  templates = {
    {
      name = "Pre-commit install",
      tags = { "pre-commit" },
      builder = function()
        return {
          cmd = { "pre-commit", "install" },
          name = "Pre-commit install",
        }
      end,
    },
    {
      name = "Pre-commit run all files",
      tags = { "pre-commit" },
      builder = function()
        return {
          cmd = { "pre-commit", "run", "--all-files" },
          name = "Pre-commit run all files",
        }
      end,
    },
    {
      name = "Pre-commit run directory",
      tags = { "pre-commit" },
      builder = function()
        return {
          -- vim.fn.expandcmd is taken from the "shell" builtin template; without it pre-commit
          -- skips all the files in the directory
          cmd = vim.fn.expandcmd("pre-commit run --files **/*"),
          name = "Pre-commit run directory",
        }
      end,
    },
    {
      name = "Pre-commit run file",
      tags = { "pre-commit" },
      builder = function()
        return {
          cmd = { "pre-commit", "run", "--file", vim.fn.expand("%:p") },
          name = "Pre-commit run file",
        }
      end,
      condition = {
        filetype = { -- To avoid making this available without a file open
          "json",
          "lua",
          "markdown",
          "python",
          "toml",
          "yaml",
        },
      },
    },
  },
}
