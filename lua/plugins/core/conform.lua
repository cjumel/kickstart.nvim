---@type nvim_config.FormattersByFiletype
local default_formatters_by_ft = {
  conf = { "trim_newlines", "trim_whitespace" },
  editorconfig = { "trim_newlines", "trim_whitespace" },
  gitconfig = { "trim_newlines", "trim_whitespace" },
  gitignore = { "trim_newlines", "trim_whitespace" },
  json = { lsp_format = "first" }, -- JsonLS
  lua = { "stylua" },
  make = { "trim_newlines", "trim_whitespace" },
  markdown = { lsp_format = "first" }, -- rumdl
  proto = { "trim_newlines", "trim_whitespace" },
  python = {
    "ruff_organize_imports",
    lsp_format = "last", -- Ruff
  },
  rust = { "rustfmt" },
  sh = { "shfmt" },
  text = { "trim_newlines", "trim_whitespace" },
  tmux = { "trim_newlines", "trim_whitespace" },
  toml = { lsp_format = "first" }, -- Taplo
  typescript = { lsp_format = "first" }, -- Biome
  typst = { lsp_format = "first" }, -- Tinymist
  vim = { "trim_newlines", "trim_whitespace" },
  yaml = { "yamlfmt", "trim_newlines" },
  zsh = { "shfmt" }, -- Not actually for zsh, but works fine for me
}

---@type nvim_config.FormatterToMasonName
local default_formatter_to_mason_name = {
  ruff_organize_imports = "ruff",
  rustfmt = false, -- Should be installed with rustup
  trim_newlines = false,
  trim_whitespace = false,
}

return {
  "stevearc/conform.nvim",
  dependencies = { "mason-org/mason.nvim" },
  ft = vim.tbl_keys(default_formatters_by_ft), -- `vim.g.formatters_by_ft` is not known at this stage so it can't be used
  config = function()
    ---@type nvim_config.FormattersByFiletype
    local formatters_by_ft = vim.tbl_deep_extend("force", default_formatters_by_ft, vim.g.formatters_by_ft or {})
    ---@type nvim_config.FormatterToMasonName
    local formatter_to_mason_name =
      vim.tbl_deep_extend("force", default_formatter_to_mason_name, vim.g.formatter_to_mason_name or {})

    require("conform").setup({
      formatters_by_ft = formatters_by_ft,
      format_on_save = function(bufnr)
        if vim.b[bufnr].format_on_save_is_disabled or vim.g.format_on_save_is_disabled then
          return
        end
        return { lsp_fallback = false, timeout_ms = 500 }
      end,
    })

    -- Make sure all required dependencies can be installed with the `MasonInstallAll` command
    local mason_ensure_installed = {}
    for _, formatters in pairs(formatters_by_ft) do
      for key, formatter in ipairs(formatters) do ---@diagnostic disable-line: param-type-mismatch]
        if
          key ~= "lsp_format" -- "lsp_format" is a special key for LSP formatter modes
          and formatter_to_mason_name[formatter] ~= false
        then
          local mason_name = formatter_to_mason_name[formatter] or formatter
          table.insert(mason_ensure_installed, mason_name)
        end
      end
    end
    vim.g.mason_ensure_installed = vim.list_extend(vim.g.mason_ensure_installed or {}, mason_ensure_installed)
  end,
}
