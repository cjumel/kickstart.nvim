-- neoclip
--
-- neoclip is a clipboard manager for neovim inspired for example by clipmenu.

local telescope_opts = require("plugins.navigation.telescope.opts")

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

local whitespace_yank_filter_fn = function(data)
  return not all(data.event.regcontents, is_whitespace)
end

return {
  "AckslD/nvim-neoclip.lua",
  dependencies = {
    { "kkharji/sqlite.lua", module = "sqlite" }, -- For persistent history
    -- The following dependencies are needed but don't need to be loaded when the plugin is loaded
    -- "nvim-telescope/telescope.nvim",
  },
  event = { "BufNewFile", "BufReadPre" },
  keys = {
    {
      "<leader>p",
      function()
        require("telescope").extensions.neoclip.default({
          layout_strategy = "vertical",
        })
      end,
      desc = "[P]aste candidates history",
    },
    {
      "<leader>q",
      function()
        local opts = require("telescope.themes").get_dropdown(telescope_opts.dropdown)
        require("telescope").extensions.macroscope.default(opts)
      end,
      desc = "[Q]-register macro history",
    },
  },
  opts = {
    enable_persistent_history = true,
    content_spec_column = true,
    on_select = {
      move_to_front = true,
    },
    on_paste = {
      set_reg = true,
      move_to_front = true,
    },
    on_replay = {
      set_reg = true,
      move_to_front = true,
    },
    -- Don't store pure whitespace yanks
    filter = whitespace_yank_filter_fn,
    keys = {
      telescope = {
        i = {
          select = "<CR>",
          paste = false,
          paste_behind = false,
          replay = false,
          delete = "<C-d>",
          edit = "<C-e>",
        },
        n = {
          select = "<CR>",
          paste = false,
          paste_behind = false,
          replay = false,
          delete = "d",
          edit = "e",
        },
      },
    },
  },
}
