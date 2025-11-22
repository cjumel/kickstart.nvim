-- NOTE: disable autoformatting by setting `vim.g.disable_autoformat_on_fts` to an array of filetypes or to "*" in your
-- `.nvim.lua` config file
-- NOTE: change formatters on filetypes by setting the `vim.g.formatters_by_ft` variable to a table of filetypes to
-- formatters in your `.nvim.lua` config file
local default_formatters_by_ft = {
  conf = { "trim_newlines", "trim_whitespace" },
  editorconfig = { "trim_newlines", "trim_whitespace" },
  gitconfig = { "trim_newlines", "trim_whitespace" },
  gitignore = { "trim_newlines", "trim_whitespace" },
  javascript = { "biome" },
  json = { "jq" },
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
  typescript = { "biome" },
  typst = { lsp_format = "first" }, -- Tinymist
  vim = { "trim_newlines", "trim_whitespace" },
  yaml = { "yamlfmt", "trim_newlines" },
  zsh = { "shfmt" }, -- Not actually for zsh, but works fine for me
}

-- NOTE: if necessary, define Mason package names for formatters by settings the `vim.g.formatter_to_mason_name` variable
-- in your `.nvim.lua` config file
local default_formatter_to_mason_name = {
  ruff_organize_imports = "ruff",
  rustfmt = false, -- Should be installed with rustup
  trim_newlines = false,
  trim_whitespace = false,
}

-- NOTE: disable autoformatting on some files by setting `vim.g.disable_autoformat_on_files` to a list of path patterns in your
-- `.nvim.lua` config file
local default_disable_autoformat_on_files = {
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
  cmd = { "AutoformatEnable", "AutoformatDisable", "AutoformatToggle" },
  ft = vim.tbl_keys(default_formatters_by_ft), -- `vim.g.formatters_by_ft` is not known at this time
  opts = function()
    return {
      formatters_by_ft = vim.tbl_deep_extend("force", default_formatters_by_ft, vim.g.formatters_by_ft or {}),
      format_on_save = function(bufnr)
        local enable_message = { lsp_fallback = false, timeout_ms = 500 }

        local autoformat_is_enabled_by_command = vim.b[bufnr].autoformat_mode == "force"
          or (vim.g.autoformat_mode == "force" and (vim.b[bufnr].autoformat_mode or "auto") == "auto")
        if autoformat_is_enabled_by_command then
          return enable_message
        end
        local autoformat_is_disabled_by_command = vim.b[bufnr].autoformat_mode == "disable"
          or (vim.g.autoformat_mode == "disable" and (vim.b[bufnr].autoformat_mode or "auto") == "auto")
        if autoformat_is_disabled_by_command then
          return
        end

        local autoformat_is_disabled_by_config = (
          vim.g.disable_autoformat_on_fts == "*"
          or vim.tbl_contains(vim.g.disable_autoformat_on_fts or {}, vim.bo.filetype)
        )
        if autoformat_is_disabled_by_config then
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
          ipairs(vim.list_extend(default_disable_autoformat_on_files, vim.g.disable_autoformat_on_files or {}))
        do
          local file_is_excluded = relative_file_path:match(excluded_file_pattern)
          if file_is_excluded then
            return
          end
        end

        return enable_message
      end,
    }
  end,
  config = function(_, opts)
    require("conform").setup(opts)

    -- Enable conform formatting with Neovim's builtin formatting with `gq`
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

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

    -- Switch autoformat mode, between "disable", "auto" and "force", globally or per-buffer (the later taking precedence
    -- over the former)
    local function enable_autoformat(args)
      if args.args == "all" and args.bang then
        vim.g.autoformat_mode = "force"
        vim.notify("Autoformat enabled globally (force)", vim.log.levels.INFO, { title = "Autoformat" })
      elseif args.args == "all" then
        vim.g.autoformat_mode = "auto"
        vim.notify("Autoformat enabled globally (auto)", vim.log.levels.INFO, { title = "Autoformat" })
      elseif args.bang then
        vim.b.autoformat_mode = "force"
        vim.notify("Autoformat enabled for current buffer (force)", vim.log.levels.INFO, { title = "Autoformat" })
      else
        vim.b.autoformat_mode = "auto"
        vim.notify("Autoformat enabled for current buffer (auto)", vim.log.levels.INFO, { title = "Autoformat" })
      end
    end
    local function disable_autoformat(args)
      if args.args == "all" then
        vim.g.autoformat_mode = "disable"
        vim.notify("Autoformat disabled globally", vim.log.levels.INFO, { title = "Autoformat" })
      else
        vim.b.autoformat_mode = "disable"
        vim.notify("Autoformat disabled for current buffer", vim.log.levels.INFO, { title = "Autoformat" })
      end
    end
    local function autoformat_is_disabled(args)
      if args.args == "all" then
        return vim.g.autoformat_mode == "disable"
      else
        return vim.b.autoformat_mode == "disable"
      end
    end
    local function toggle_autoformat(args)
      if autoformat_is_disabled(args) then
        enable_autoformat(args)
      else
        disable_autoformat(args)
      end
    end
    vim.api.nvim_create_user_command("AutoformatEnable", enable_autoformat, {
      desc = "Enable autoformat",
      bang = true,
      nargs = "?",
      complete = function() return { "all" } end,
    })
    vim.api.nvim_create_user_command("AutoformatDisable", disable_autoformat, {
      desc = "Disable autoformat",
      nargs = "?",
      complete = function() return { "all" } end,
    })
    vim.api.nvim_create_user_command("AutoformatToggle", toggle_autoformat, {
      desc = "Toggle autoformat",
      bang = true,
      nargs = "?",
      complete = function() return { "all" } end,
    })
  end,
}
