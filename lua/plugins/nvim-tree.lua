-- Nvim-tree
--
-- A file tree explorer for nvim written in Lua.

return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    {
      "<leader>n",
      "<cmd> NvimTreeFocus <CR>",
      desc = "[N]vim-tree",
    },
  },
  opts = {
    git = {
      enable = true,
    },
    filters = {
      git_ignored = false,
      dotfiles = true,
      custom = {
        "^.git$",
        "^.DS_Store",
        "^__pycache__",
        "^.null-ls_",
      },
    },
    on_attach = function(bufnr)
      local api = require("nvim-tree.api")

      local function opts(desc)
        return {
          desc = "nvim-tree: " .. desc,
          buffer = bufnr,
          noremap = true,
          silent = true,
          nowait = true,
        }
      end

      -- default mappings
      api.config.mappings.default_on_attach(bufnr)

      -- custom mappings
      vim.keymap.set("n", "=", api.node.open.edit, opts("Open"))
    end,
    renderer = {
      root_folder_label = false,
    },
  },
}
