-- lualine.nvim
--
-- A blazing fast and customizable status bar written in Lua.

local utils = require("utils")

-- Handle the case the theme file is missing
local ok, theme = pcall(require, "theme")
if not ok then
  theme = {}
end

local default_lualine_sections = {
  lualine_a = { "mode" },
  lualine_b = { "branch", "diff", "diagnostics" },
  lualine_c = { "filename" },
  lualine_x = { "encoding", "fileformat", "filetype" },
  lualine_y = { "location" },
  lualine_z = { "progress" },
}

return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  priority = 100, -- Main UI stuff should be loaded first
  opts = utils.table.concat_dicts({
    {
      options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = "|",
        section_separators = "",
      },
      sections = {
        lualine_c = {
          {
            "filename",
            path = 1, -- Relative path
            symbols = {
              modified = "●", -- Text to show when the buffer is modified
            },
          },
        },
        lualine_x = {
          -- Add a message in the status line when recording a macro
          -- This means that noice needs to pass the message to the statusline (see noice's wiki)
          {
            function()
              if package.loaded.noice ~= nil then -- Don't fail if Noice is not setup
                return require("noice").api.statusline.mode.get()
              end
            end,
            cond = function()
              if package.loaded.noice ~= nil then -- Don't fail if Noice is not setup
                return require("noice").api.statusline.mode.has()
              end
            end,
            color = { fg = "#ff9e64" },
          },
          -- If file is in Harpoon list, show its index
          -- This loads Harpoon so it's not lazy-loaded anymore
          {
            function()
              local harpoon = require("harpoon")

              local harpoon_list_length = harpoon:list():length()
              local current_file_path = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":.")

              for index = 1, harpoon_list_length do
                local harpoon_file_path = harpoon:list():get(index).value
                if current_file_path == harpoon_file_path then
                  return "H" .. index
                end
              end

              return ""
            end,
          },
          -- Default content
          "encoding",
          "fileformat",
          "filetype",
        },
        lualine_y = { "location" },
        lualine_z = { "progress" },
      },
      extensions = {
        -- Redefine some extensions to customize them (see lualine/extensions/ for the initial
        -- implementations)
        {
          sections = utils.table.concat_dicts({
            default_lualine_sections,
            {
              lualine_c = {
                function()
                  local ok, oil = pcall(require, "oil")
                  if not ok then
                    return ""
                  end

                  local current_dir = oil.get_current_dir()
                  -- Truncate relative to cwd or home with "~" when possible
                  local short_path = vim.fn.fnamemodify(current_dir, ":p:~:.")
                  -- If path is cwd (relative path is empty), don't show path relative to project
                  if short_path == "" then
                    short_path = vim.fn.fnamemodify(current_dir, ":p:~")
                  end
                  return short_path
                end,
              },
            },
          }),
          filetypes = { "oil" },
        },
        {
          sections = utils.table.concat_dicts({
            default_lualine_sections,
            {
              lualine_c = {
                function()
                  local opts = require("trouble.config").options
                  local words = vim.split(opts.mode, "[%W]")
                  for i, word in ipairs(words) do
                    words[i] = word:sub(1, 1):upper() .. word:sub(2)
                  end
                  return table.concat(words, " ")
                end,
              },
            },
          }),
          filetypes = { "Trouble" },
        },
        {
          sections = utils.table.concat_dicts({
            default_lualine_sections,
            {
              lualine_c = {
                function()
                  return "ToggleTerm #" .. vim.b.toggle_number
                end,
              },
            },
          }),
          filetypes = { "toggleterm" },
        },
      },
    },
    theme.lualine_opts or {},
  }),
}
