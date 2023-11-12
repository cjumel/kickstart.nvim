-- [[ Configure plugins ]]
-- NOTE: The imports below can automatically add your own plugins, configuration, etc. from
-- different directories in `lua/plugins/`
require("lazy").setup({

  -- Plugins related to code (LSP, completion, debugging, etc.)
  { import = "plugins.code" },
  { import = "plugins.code.cmp" },
  { import = "plugins.code.dap" },

  -- Plugins related to simple editions (highlighting, motions, text objects, etc.)
  { import = "plugins.edition" },
  { import = "plugins.edition.treesitter" },

  -- Plugins related to code navigation (fuzzy finding, file tree navigation, etc.)
  { import = "plugins.navigation" },
  { import = "plugins.navigation.telescope" },

  -- Plugins related to the user interface (color scheme, visual elements, etc.)
  { import = "plugins.ui" },

  -- Plugins related to the global workflow with external tools (git, tests, external package
  -- manager, etc.)
  { import = "plugins.workflow" },
  { import = "plugins.workflow.vcs" },
}, {})

-- vim: ts=2 sts=2 sw=2 et
