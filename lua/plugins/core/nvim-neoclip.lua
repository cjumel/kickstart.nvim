-- neoclip
--
-- neoclip is a clipboard manager for neovim inspired for example by clipmenu.

return {
  "AckslD/nvim-neoclip.lua",
  dependencies = {
    { "kkharji/sqlite.lua", module = "sqlite" }, -- For persistent history
  },
  event = { "BufNewFile", "BufReadPre" },
  keys = {
    -- Search in yank history is not really convenient (often, older entries are shown before
    -- the target I'm looking for). Besides, since the yank history is shared between all the
    -- projects, it is really messy, unlike the undo tree for instance. For these reasons, let's
    -- only implement simple normal mode interfaces.
    {
      "<leader>y",
      function()
        local telescope = require("telescope")
        local themes = require("telescope.themes")

        local opts = themes.get_dropdown({
          previewer = false,
          layout_config = { width = 0.7 },
          initial_mode = "normal",
          prompt_title = "Yank history",
        })

        telescope.extensions.neoclip.default(opts)
      end,
      desc = "[Y]ank history: open",
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
      return not all(data.event.regcontents, function(line)
        return vim.fn.match(line, [[^\s*$]]) ~= -1
      end)
    end,
    -- Macros saved in history are super hard to read (unlike in the yank history), and they are
    -- very specific to a given situation, so in practice I'm never using the macro history
    enable_macro_history = false,
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
