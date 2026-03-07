---@type nvim_config.LintersByFiletype
local default_linters_by_ft = {
  sh = { "shellcheck" },
  yaml = { "yamllint" },
  zsh = { "shellcheck" }, -- Not actually for zsh, but works fine for me
}

---@type nvim_config.LinterToMasonName
local default_linter_to_mason_name = {}

return {
  "mfussenegger/nvim-lint",
  dependencies = { "mason-org/mason.nvim" },
  ft = vim.tbl_keys(default_linters_by_ft), -- `vim.g.linters_by_ft` is not known at this stage so it can't be used
  config = function()
    ---@type nvim_config.LintersByFiletype
    local linters_by_ft = vim.tbl_deep_extend("force", default_linters_by_ft, vim.g.linters_by_ft or {})
    ---@type nvim_config.LinterToMasonName
    local linter_to_mason_name =
      vim.tbl_deep_extend("force", default_linter_to_mason_name, vim.g.linter_name_to_mason_name or {})

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

    -- Make sure all required dependencies can be installed with the `MasonInstallAll` command
    local mason_ensure_installed = {}
    for _, linters in pairs(linters_by_ft) do
      for _, linter in ipairs(linters) do
        if linter_to_mason_name[linter] ~= false then
          local mason_name = linter_to_mason_name[linter] or linter
          table.insert(mason_ensure_installed, mason_name)
        end
      end
    end
    vim.g.mason_ensure_installed = vim.list_extend(vim.g.mason_ensure_installed or {}, mason_ensure_installed)
  end,
}
