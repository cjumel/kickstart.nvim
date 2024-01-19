-- Noice
--
-- Highly experimental plugin that completely replaces the UI for messages, cmdline and the
-- popupmenu.

local function dismiss()
  -- Dismiss Noice messages if Noice is loaded
  if package.loaded.noice ~= nil then
    require("noice").cmd("dismiss")
  end

  -- If zen-mode is loaded, fetch its window ids (main and background) to avoid closing them
  local zen_mode_win = nil
  local zen_mode_bg_win = nil
  if package.loaded["zen-mode"] ~= nil then
    local zen_mode_view = require("zen-mode.view")
    if zen_mode_view.is_open() then
      zen_mode_win = zen_mode_view.win
      zen_mode_bg_win = zen_mode_view.bg_win
    end
  end

  -- Clear remaining relative windows (e.g. preview or hover floating windows) except the zen-mode
  -- windows
  for _, id in ipairs(vim.api.nvim_list_wins()) do
    if
      vim.api.nvim_win_get_config(id).relative ~= ""
      and id ~= zen_mode_win
      and id ~= zen_mode_bg_win
    then
      vim.api.nvim_win_close(id, false)
    end
  end
end

return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
    "nvim-treesitter/nvim-treesitter",
  },
  keys = {
    {
      "<ESC>",
      function()
        dismiss()
      end,
      desc = "Dismiss messages & floating windows",
    },
    {
      "<C-c>",
      function()
        dismiss()
      end,
      mode = { "n", "i", "v" },
      desc = "Dismiss messages & floating windows",
    },
    {
      "<leader>n",
      "<cmd> Noice <CR>",
      desc = "[N]otification history",
    },
  },
  opts = {
    lsp = {
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    presets = {
      lsp_doc_border = true, -- add a border to hover docs and signature help
    },
    routes = {
      -- hide written messages
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "written",
        },
        opts = { skip = true },
      },
    },
  },
}
