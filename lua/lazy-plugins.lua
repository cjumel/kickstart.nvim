-- [[ Configure plugins ]]
-- The imports below can automatically add your own plugins, configuration, etc. from
-- different directories in `lua/plugins/`

local opts = {
  ui = {
    border = "single", -- A lot better for transparent background
  },
}

local plugins = {

  -- Plugins related to code (LSP, completion, debugging, etc.)
  { import = "plugins.code.dap" },
  { import = "plugins.code" },

  -- Plugins related to simple editions (highlighting, motions, text objects, etc.)
  { import = "plugins.edition.treesitter" },
  { import = "plugins.edition" },

  -- Plugins related to external tools (VCS, pre-commit, external package manager, etc.)
  { import = "plugins.external_tools.vcs" },
  { import = "plugins.external_tools" },

  -- Plugins related to code navigation (fuzzy finding, file tree navigation, etc.)
  { import = "plugins.navigation.harpoon" },
  { import = "plugins.navigation.oil" },
  { import = "plugins.navigation.telescope" },
  { import = "plugins.navigation" },

  -- Plugins related to the user interface (color scheme, visual elements, etc.)
  { import = "plugins.ui" },
}

require("lazy").setup(plugins, opts)

-- vim: ts=2 sts=2 sw=2 et
