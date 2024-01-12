return {
  keychains = {
    ["<leader>opo"] = { name = "[O]verseer: [P][O]etry", _ = "which_key_ignore" },
  },
  keymaps = {
    {
      "<leader>opoi",
      function()
        require("overseer").run_template({ name = "Poetry install" })
      end,
      desc = "[O]verseer: [P][O]etry [I]nstall",
    },
    {
      "<leader>opou",
      function()
        require("overseer").run_template({ name = "Poetry update" })
      end,
      desc = "[O]verseer: [P][O]etry [U]pdate",
    },
  },
  templates = {
    {
      name = "Poetry install",
      tags = { "poetry" },
      builder = function()
        return {
          cmd = { "poetry", "install" },
        }
      end,
    },
    {
      name = "Poetry update",
      tags = { "poetry" },
      builder = function()
        return {
          cmd = { "poetry", "update" },
        }
      end,
    },
  },
}
