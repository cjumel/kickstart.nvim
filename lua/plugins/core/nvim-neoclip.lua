-- neoclip
--
-- neoclip is a clipboard manager for Neovim inspired for instance by clipmenu. It is very simple and integrates very
-- nicely with Telescope.nvim, and enables a very user-friendly experience with Neovim's clipboard.

return {
  "AckslD/nvim-neoclip.lua",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    { "kkharji/sqlite.lua", module = "sqlite" }, -- For persistent history
  },
  event = { "BufNewFile", "BufReadPre" },
  keys = {
    {
      '<leader>"',
      function()
        require("telescope").extensions.neoclip.default({
          prompt_title = '" Register History',
          layout_strategy = "vertical",
          tiebreak = function(current, existing, _) return current.index < existing.index end, -- Sort by recency
        })
      end,
      desc = '" register history',
    },
    {
      "<leader>q",
      function()
        require("telescope").extensions.macroscope.default(require("telescope.themes").get_dropdown({
          prompt_title = "q Register Macro History",
          previewer = false,
          tiebreak = function(current, existing, _) return current.index < existing.index end, -- Sort by recency
        }))
      end,
      desc = "[Q] register macro history",
    },
  },
  opts = {
    enable_persistent_history = true,
    filter = function(data) -- Don't store pure whitespace yanks
      local function all(tbl, check)
        for _, entry in ipairs(tbl) do
          if not check(entry) then
            return false
          end
        end
        return true
      end
      return not all(data.event.regcontents, function(line) return vim.fn.match(line, [[^\s*$]]) ~= -1 end)
    end,
    content_spec_column = true,
    on_select = {
      move_to_front = true,
      close_telescope = true,
    },
    on_paste = {
      set_reg = true,
      move_to_front = true,
      close_telescope = true,
    },
    keys = {
      telescope = {
        i = { -- Insert mode is not the main use case for me, so let's keep only the bare necessary
          select = "<CR>",
          paste = false,
          paste_behind = false,
          replay = false,
          delete = false,
          edit = false,
        },
        n = {
          select = "<CR>",
          paste = "p",
          paste_behind = "P",
          replay = false,
          delete = "d",
          edit = "e",
        },
      },
    },
  },
}
