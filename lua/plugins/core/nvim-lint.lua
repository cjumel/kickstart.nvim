return {
  "mfussenegger/nvim-lint",
  dependencies = { "mason-org/mason.nvim" },
  ft = vim.tbl_keys(require("config.data").linters_by_ft), -- `vim.g.linters_by_ft` is not known at this stage so it can't be used
  config = function()
    ---@type nvim_config.LintersByFiletype
    local linters_by_ft = vim.tbl_deep_extend("force", require("config.data").linters_by_ft, vim.g.linters_by_ft or {})

    local lint = require("lint")
    lint.linters_by_ft = linters_by_ft

    vim.api.nvim_create_autocmd({
      "BufEnter", -- Entering a buffer
      "InsertLeave", -- Leaving insert mode
      "TextChanged", -- Text is changed by pasting, deleting, etc. but not by insert mode
      "BufWritePost", -- After writing the buffer; required for some linters relying on file on disk
    }, {
      callback = function() lint.try_lint() end,
    })
  end,
}
