-- conform.nvim
--
-- conform.nvim is a lightweight yet powerful formatter plugin for Neovim. It is my plugin of choice for formatting and
-- auto-formatting due to its great flexibility and customizability, while still remaining quite simple compared to
-- alternatives like null-ls.

-- Define here which formatters to use for each file type; keys must be simple file types, and values must be arrays
--  of formatter names
-- In some file types, a formatter is integrated as a language server in nvim-lspconfig; in that case, the corresponding
--  file type must be added as a key with at least an empty array as value to trigger formatting on save
local formatters_by_ft = {
  conf = { "trim_newlines", "trim_whitespace" },
  editorconfig = { "trim_newlines", "trim_whitespace" },
  gitconfig = { "trim_newlines", "trim_whitespace" },
  gitignore = { "trim_newlines", "trim_whitespace" },
  json = { "prettier" },
  jsonc = { "prettier" },
  lua = { "stylua" },
  make = { "trim_newlines", "trim_whitespace" },
  markdown = { "prettier" }, -- Prettier is the only popular formatter I found which supports GitHub Flavored Markdown
  python = { "ruff_fix", "ruff_format" }, -- Lint diagnostic automatic fixes & regular formatting
  sh = { "shfmt" },
  text = { "trim_newlines", "trim_whitespace" },
  tmux = { "trim_newlines", "trim_whitespace" },
  toml = {}, -- Use Taplo language server formatting
  typst = {}, -- Use tinymist language server formatting (for some reason I can't make this work with "trim_newlines")
  vim = { "trim_newlines", "trim_whitespace" },
  yaml = { "prettier", "trim_newlines" }, -- Prettier doesn't remove trailing whitespace in YAML
  zsh = { "shfmt" }, -- Not actually for zsh, but in my use case it seems to work fine
}

-- Specify the formatters which have no Mason package
local formatters_without_mason_package = {
  "trim_newlines",
  "trim_whitespace",
}

-- Specify the name of the Mason package for formatters where they differ
local formatter_to_mason_name = {
  ruff_fix = "ruff",
  ruff_format = "ruff",
}

return {
  "stevearc/conform.nvim",
  cond = not require("config")["light_mode"],
  dependencies = { "williamboman/mason.nvim" },
  ft = vim.tbl_keys(formatters_by_ft),
  init = function()
    -- Enable conform formatting with Neovim's builtin formatting (see `:h gq`)
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

    local mason_ensure_installed = {}
    for _, formatters in pairs(formatters_by_ft) do
      for formatter_key, formatter in ipairs(formatters) do
        if
          formatter_key ~= "lsp_format" -- "lsp_format" is a special key for LSP formatter modes
          and not vim.tbl_contains(formatters_without_mason_package, formatter)
        then
          local mason_name = formatter_to_mason_name[formatter] or formatter
          if
            not vim.tbl_contains(mason_ensure_installed, mason_name)
            and not vim.tbl_contains(vim.g.mason_ensure_installed or {}, mason_name)
          then
            table.insert(mason_ensure_installed, mason_name)
          end
        end
      end
    end
    vim.g.mason_ensure_installed = vim.list_extend(vim.g.mason_ensure_installed or {}, mason_ensure_installed)
  end,
  opts = {
    formatters_by_ft = formatters_by_ft,
    format_on_save = function(bufnr)
      if
        ( -- Check Neovim configuration option to disable format-on-save on filetypes
          require("config")["disable_format_on_save_on_filetypes"] == "*"
          or (
            require("config")["disable_format_on_save_on_filetypes"]
            and vim.tbl_contains(require("config")["disable_format_on_save_on_filetypes"], vim.bo.filetype)
          )
        )
        -- Check command to toggle format on save
        or (vim.g.disable_format_on_save or vim.b[bufnr].disable_format_on_save)
        -- Check tooling should not be globally disabled on the buffer
        or require("buffer").tooling_is_disabled()
      then
        return
      end

      return { lsp_fallback = true, timeout_ms = 500 }
    end,
  },
  config = function(_, opts)
    require("conform").setup(opts)

    -- Create command to toggle format-on-save
    -- Used with a bang ("!"), the disable command will disable format-on-save just for the current buffer
    vim.api.nvim_create_user_command("FormatOnSaveDisable", function(args)
      if args.bang then
        vim.b.disable_format_on_save = true
      else
        vim.g.disable_format_on_save = true
      end
    end, { desc = "Disable format-on-save", bang = true })
    vim.api.nvim_create_user_command("FormatOnSaveEnable", function()
      vim.b.disable_format_on_save = false
      vim.g.disable_format_on_save = false
    end, { desc = "Enable format-on-save" })
  end,
}
