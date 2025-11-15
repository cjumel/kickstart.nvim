return {
  "folke/noice.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  event = "VeryLazy",
  opts = {
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
      hover = { silent = true }, -- Irrelevant warnings when one LS doesn't support hover (e.g. ruff in Python)
      signature = { auto_open = { enabled = false } }, -- Automatic signature in insert mode is handled by blink.cmp
    },
    presets = {
      bottom_search = true,
      lsp_doc_border = true,
    },
    -- Hide "buffer written" messages
    routes = { { filter = { event = "msg_show", kind = "", find = "written" }, opts = { skip = true } } },
  },
}
