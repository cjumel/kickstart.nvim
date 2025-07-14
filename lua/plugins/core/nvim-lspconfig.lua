-- nvim-lspconfig
--
-- nvim-lspconfig is a "data only" repo, providing basic, default Nvim LSP client configurations for various LSP
-- servers.

local servers_by_ft = {
  json = {
    jsonls = {},
  },
  lua = {
    lua_ls = { -- Basic LS features with type annotation checking and some linting
      settings = {
        Lua = { -- LS settings go in there (see https://luals.github.io/wiki/settings/)
          -- Disable diagnostics when passing to a function a table without the full expected type (e.g. when leaving
          -- some values to their default)
          diagnostics = { disable = { "missing-fields" } },
        },
      },
    },
  },
  markdown = {
    marksman = {},
  },
  python = {
    -- Pyright provides basic LS and advanced type checking features. However, it misses some more advanced LS
    -- features, which are reserved for Pylance, Microsoft's dedicated and close-source LSP.
    -- Basedpyright is built on top of Pyright to provide the more advanced LS features Pyright is missing, as well as
    -- additional type checking features.
    basedpyright = {
      settings = {
        basedpyright = {
          analysis = {
            -- Relax the type checking mode. The default mode raises a lot of warnings and errors, which are more
            -- suited when used as the main type checker of a project, similarly to Mypy's strict mode. Stricter modes
            -- can be used on a per-project basis where basedpyright is used as the main type checker.
            typeCheckingMode = "standard",
          },
        },
      },
      on_init = function(client, _)
        -- Disable semantic tokens as it degrades the syntax highlighting provided by Treesitter
        client.server_capabilities.semanticTokensProvider = nil
      end,
    },
    ruff = {}, -- Linting and formatting, integrated with code actions
  },
  rust = {
    rust_analyzer = {
      settings = {
        ["rust-analyzer"] = { -- LS settings go in there (see https://rust-analyzer.github.io/manual.html)
          -- Add parentheses when completing with a function instead of call snippets
          completion = { callable = { snippets = "add_parentheses" } },
        },
      },
    },
  },
  toml = {
    taplo = {}, -- Linting, formating and known schema validation/documentation
  },
  typescript = {
    ts_ls = {},
  },
  typst = {
    tinymist = { -- Basic LS features with popular formatters support
      settings = {
        formatterMode = "typstyle", -- Default formatter
      },
    },
  },
  yaml = {
    yamlls = {}, -- Validation, completion and documentation for knwon schemas
  },
}

local server_name_to_mason_name = {
  jsonls = "json-lsp",
  lua_ls = "lua-language-server",
  rust_analyzer = "rust-analyzer",
  ts_ls = "typescript-language-server",
  yamlls = "yaml-language-server",
}

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "mason-org/mason.nvim",
    "mason-org/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
  },
  ft = vim.tbl_keys(servers_by_ft),
  init = function()
    local mason_ensure_installed = {}
    for _, ft_servers in pairs(servers_by_ft) do
      for server_name, _ in pairs(ft_servers) do
        local mason_name = server_name_to_mason_name[server_name] or server_name
        table.insert(mason_ensure_installed, mason_name)
      end
    end
    vim.g.mason_ensure_installed = vim.list_extend(vim.g.mason_ensure_installed or {}, mason_ensure_installed)
  end,
  config = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("NvimLspconfigKeymaps", { clear = true }),
      callback = function(event)
        ---@param mode string|string[] The mode(s) of the keymap.
        ---@param lhs string The left-hand side of the keymap.
        ---@param rhs string|function The right-hand side of the keymap.
        ---@param desc string The description of the keymap.
        ---@param opts table|nil Additional options for the keymap.
        local function map(mode, lhs, rhs, desc, opts)
          opts = opts or {}
          opts.desc = desc
          opts.buffer = event.buf
          vim.keymap.set(mode, lhs, rhs, opts)
        end
        map({ "n", "i" }, "<C-s>", vim.lsp.buf.signature_help, "Signature help")
        map("n", "gd", "<cmd>Trouble lsp_definitions<CR>", "Go to definition")
        map("n", "grt", "<cmd>Trouble lsp_type_definitions<CR>", "LSP: type definition")
        map("n", "grd", "<cmd>Trouble lsp_declarations<CR>", "LSP: declation")
        map("n", "gri", "<cmd>Trouble lsp_implementations<CR>", "LSP: implementation")
        map("n", "grr", "<cmd>Trouble lsp_references<CR>", "LSP: references")
        map("n", "gra", vim.lsp.buf.code_action, "LSP: code actions")
        map("n", "grn", vim.lsp.buf.rename, "LSP: rename")
      end,
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()
    capabilities = vim.tbl_deep_extend("force", capabilities, cmp_capabilities)

    for _, ft_servers in pairs(servers_by_ft) do
      for server_name, server_config in pairs(ft_servers) do
        require("lspconfig")[server_name].setup({
          capabilities = capabilities,
          settings = server_config.settings or {},
          on_init = server_config.on_init or nil,
        })
      end
    end

    require("mason-lspconfig").setup({
      automatic_enable = false,
    })
  end,
}
