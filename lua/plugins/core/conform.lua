local default_formatters_by_ft = {
  conf = { "trim_newlines", "trim_whitespace" },
  editorconfig = { "trim_newlines", "trim_whitespace" },
  gitconfig = { "trim_newlines", "trim_whitespace" },
  gitignore = { "trim_newlines", "trim_whitespace" },
  json = { lsp_format = "first" }, -- JsonLS
  lua = { "stylua" },
  make = { "trim_newlines", "trim_whitespace" },
  markdown = { "mdformat" },
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

local default_formatter_to_mason_name = {
  ruff_organize_imports = "ruff",
  rustfmt = false, -- Should be installed with rustup
  trim_newlines = false,
  trim_whitespace = false,
}

local default_disable_format_on_save_on_files = {
  -- Directories inside projects but managed by external tools
  "/%.git/",
  "/%.venv",

  -- Global directories managed by package managers
  "^~/%.tmux/",
  "^~/%.local/share/nvim/",
}

return {
  "stevearc/conform.nvim",
  dependencies = { "mason-org/mason.nvim" },
  ft = vim.tbl_keys(default_formatters_by_ft), -- `vim.g.formatters_by_ft` is not known at this time
  opts = function()
    return {
      formatters_by_ft = vim.tbl_deep_extend("force", default_formatters_by_ft, vim.g.formatters_by_ft or {}),
      format_on_save = function(bufnr)
        local format_on_save_is_disabled_by_command = vim.b[bufnr].disable_format_on_save
          or vim.g.disable_format_on_save
        if format_on_save_is_disabled_by_command then
          return
        end

        local format_on_save_is_disabled_by_config = (
          vim.g.disable_format_on_save_on_fts == "*"
          or vim.tbl_contains(vim.g.disable_format_on_save_on_fts or {}, vim.bo.filetype)
        )
        if format_on_save_is_disabled_by_config then
          return
        end

        local absolute_file_path = vim.fn.expand("%:p")
        local absolute_cwd_path = vim.fn.fnamemodify(vim.fn.getcwd(), ":p")
        local file_is_in_cwd = string.sub(absolute_file_path, 1, #absolute_cwd_path) == absolute_cwd_path
        if not file_is_in_cwd then
          return
        end

        local relative_file_path = vim.fn.expand("%:p:~")
        for _, excluded_file_pattern in
          ipairs(vim.list_extend(default_disable_format_on_save_on_files, vim.g.disable_format_on_save_on_files or {}))
        do
          local file_is_excluded = relative_file_path:match(excluded_file_pattern)
          if file_is_excluded then
            return
          end
        end

        return { lsp_fallback = false, timeout_ms = 500 }
      end,
    }
  end,
  config = function(_, opts)
    require("conform").setup(opts)

    -- Make sure all required dependencies can be installed with the `MasonInstallAll` command
    local mason_ensure_installed = {}
    local formatters_by_ft = vim.tbl_deep_extend("force", default_formatters_by_ft, vim.g.formatters_by_ft or {})
    local formatter_to_mason_name =
      vim.tbl_deep_extend("force", default_formatter_to_mason_name, vim.g.formatter_to_mason_name or {})
    for _, formatters in pairs(formatters_by_ft) do
      for formatter_key, formatter in ipairs(formatters) do
        if
          formatter_key ~= "lsp_format" -- "lsp_format" is a special key for LSP formatter modes
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
