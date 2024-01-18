-- Noice
--
-- Highly experimental plugin that completely replaces the UI for messages, cmdline and the
-- popupmenu.

local function dismiss()
  vim.cmd("Noice dismiss")

  -- Clear remaining relative windows (e.g. preview or hover floating windows)
  for _, id in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(id).relative ~= "" then
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
