-- neoclip
--
-- neoclip is a clipboard manager for Neovim inspired for instance by clipmenu. It is very simple and integrates very
-- nicely with telescope.nvim. It enables a very user-friendly experience with Neovim's registers, which can be somehow
-- not super intuitive to use at first.

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
        local visual_mode = require("visual_mode")
        local opts = {
          prompt_title = "Yank History",
          layout_strategy = "vertical",
          tiebreak = function(current, existing, _) return current.index < existing.index end, -- Sort by recency
        }
        if visual_mode.is_on() then
          opts.default_text = visual_mode.get_text()
        end
        require("telescope").extensions.neoclip.default(opts)
      end,
      mode = { "n", "v" },
      desc = "Yank history",
    },
    {
      "<leader>@",
      function()
        local visual_mode = require("visual_mode")
        local opts = {
          prompt_title = "Macro History",
          layout_strategy = "vertical",
          tiebreak = function(current, existing, _) return current.index < existing.index end, -- Sort by recency
        }
        if visual_mode.is_on() then
          opts.default_text = visual_mode.get_text()
        end
        require("telescope").extensions.macroscope.default(opts)
      end,
      mode = { "n", "v" },
      desc = "Macro history",
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
    on_select = { move_to_front = true },
    keys = {
      telescope = {
        i = {
          select = "<CR>",
          paste = false,
          paste_behind = false,
          replay = false,
          delete = false,
          edit = "<M-CR>", -- <C-CR>
        },
        n = {
          select = "<CR>",
          paste = false,
          paste_behind = false,
          replay = false,
          delete = false,
          edit = "<M-CR>", -- <C-CR>
        },
      },
    },
  },
}
