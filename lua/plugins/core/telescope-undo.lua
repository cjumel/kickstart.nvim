-- telescope-undo.nvim
--
-- telescope-undo.nvim is a Telescope extension to visualize the undotree and fuzzy-search changes in it. I don't find
-- it as convenient as the undotree plugin for simple visualization and navigation in the undotree and I've encountered
-- issues with telescope-undo.nvim to restore some past states, but it enables fuzzy-searching changes in it, which is a
-- super nice feature and makes it nicely complementary with undotree.

local visual_mode = require("visual_mode")

--- Custom version of the `yank_additions` action, where we always yank the additions in line-wise mode.
--- See `lua/telescope-undo/actions.lua` in the telescope-undo.nvim repository for the initial implementation.
---@param prompt_bufnr integer The buffer number of the prompt buffer.
---@return function
local function yank_additions(prompt_bufnr)
  return function()
    local actions = require("telescope.actions")
    local actions_state = require("telescope.actions.state")

    -- yanks the additions from the currently selected undo state into the default register
    local entry = actions_state.get_selected_entry()
    if entry ~= nil then
      vim.fn.setreg('"', entry.value.additions, "V")
      vim.notify("Yanked additions:\n" .. table.concat(entry.value.additions, "\n"))
      actions.close(prompt_bufnr)
      return entry.value.additions
    end
  end
end

--- Custom version of the `yank_deletions` action, where we always yank the deletions in line-wise mode.
--- See `lua/telescope-undo/actions.lua` in the telescope-undo.nvim repository for the initial implementation.
---@param prompt_bufnr integer The buffer number of the prompt buffer.
---@return function
local function yank_deletions(prompt_bufnr)
  return function()
    local actions = require("telescope.actions")
    local actions_state = require("telescope.actions.state")

    -- yanks the deletions from the currently selected undo state into the default register
    local entry = actions_state.get_selected_entry()
    if entry ~= nil then
      vim.fn.setreg('"', entry.value.deletions, "V")
      vim.notify("Yanked deletions:\n" .. table.concat(entry.value.deletions, "\n"))
      actions.close(prompt_bufnr)
      return entry.value.deletions
    end
  end
end

return {
  "debugloop/telescope-undo.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  keys = {
    {
      "<leader>fu",
      function()
        require("telescope").extensions.undo.undo({
          prompt_title = "Find Undotree",
          layout_config = { preview_width = 0.6 },
          tiebreak = function(current, existing, _) return current.index < existing.index end, -- Sort by recency
          default_text = visual_mode.is_on() and visual_mode.get_text() or nil,
        })
      end,
      mode = { "n", "v" },
      desc = "[F]ind: [U]ndotree",
    },
  },
  opts = {
    vim_diff_opts = { ctxlen = 5 }, -- Number of lines to display around each change
    mappings = {
      i = {
        ["<CR>"] = yank_additions,
        ["<M-CR>"] = yank_deletions, -- <C-CR>
        ["<S-cr>"] = false,
        ["<C-cr>"] = false,
        ["<C-y>"] = false,
        ["<C-r>"] = false,
      },
      n = {
        ["<CR>"] = yank_additions,
        ["<M-CR>"] = yank_deletions, -- <C-CR>
        ["y"] = false,
        ["Y"] = false,
        ["u"] = false,
      },
    },
  },
  config = function(_, opts)
    local telescope = require("telescope")

    telescope.setup({ extensions = { undo = opts } })
    telescope.load_extension("undo")
  end,
}
