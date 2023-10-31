-- neoclip
--
-- neoclip is a clipboard manager for neovim inspired for example by clipmenu.

local function is_whitespace(line)
  return vim.fn.match(line, [[^\s*$]]) ~= -1
end

local function all(tbl, check)
  for _, entry in ipairs(tbl) do
    if not check(entry) then
      return false
    end
  end
  return true
end

return {
  "AckslD/nvim-neoclip.lua",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  event = { "BufNewFile", "BufReadPre" },
  keys = {
    {
      "<leader>p",
      function()
        require("telescope").extensions.neoclip.default({
          layout_strategy = "vertical",
          initial_mode = "normal",
        })
      end,
      mode = { "n", "v" },
      desc = "[P]aste from history",
    },
    {
      "<leader>P",
      function()
        require("neoclip").clear_history()
      end,
      mode = { "n", "v" },
      desc = "Clear [P]aste history",
    },
  },
  opts = {
    history = 25,
    content_spec_column = true,
    on_select = {
      move_to_front = true,
    },
    on_paste = {
      set_reg = true,
      move_to_front = true,
    },
    keys = {
      telescope = {
        i = {
          select = "<cr>",
        },
        n = {
          select = "<cr>",
          paste = "p",
          paste_behind = "P",
          delete = "dd",
        },
      },
    },
    -- Don't store pure whitespace yanks
    filter = function(data)
      return not all(data.event.regcontents, is_whitespace)
    end,
  },
}
