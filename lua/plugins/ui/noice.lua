return {
  "folke/noice.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  event = "VeryLazy",
  opts = {
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true, -- For nvim-cmp
      },
      hover = { silent = true }, -- Irrelevant warnings when one LS doesn't support hover (e.g. ruff in Python)
    },
    presets = {
      bottom_search = true,
      lsp_doc_border = true,
    },
    -- Hide "buffer written" messages
    routes = { { filter = { event = "msg_show", kind = "", find = "written" }, opts = { skip = true } } },
  },
}
