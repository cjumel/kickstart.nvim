-- Diffview.nvim
--
-- Plugin providing a single tabpage interface for easily cycling through diffs for all modified files for any git rev.
-- This plugin is integrated in Neogit, but it also provides cool features on its own.

return {
  "sindrets/diffview.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = {
    "DiffviewOpen",
    "DiffviewFileHistory",
    "DiffviewClose",
    "DiffviewToggleFiles",
    "DiffviewFocusFiles",
    "DiffviewRefresh",
  },
}
