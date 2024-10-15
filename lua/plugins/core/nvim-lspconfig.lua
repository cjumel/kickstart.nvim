-- nvim-lspconfig
--
-- Plugin containing a collection of configurations for the Neovim builtin LSP client. It does not contain neither
-- the code of the Neovim LSP itself, nor the language servers implementations. It makes super easy setting up a LSP
-- in Neovim, bridging the gap between the LSP client and the language servers implementations.

local config = require("config")

return {
  "neovim/nvim-lspconfig",
  cond = not config.light_mode,
  dependencies = {
    "williamboman/mason.nvim",
    { "williamboman/mason-lspconfig.nvim", cond = not config.light_mode },
    { "hrsh7th/cmp-nvim-lsp", cond = not config.light_mode },
    "RRethy/vim-illuminate",
    "ray-x/lsp_signature.nvim",
    "smjonas/inc-rename.nvim",
  },
  ft = function()
    local filetypes = {}
    for _, server in pairs(config.language_servers) do
      for _, filetype in ipairs(server.filetypes) do
        table.insert(filetypes, filetype)
      end
    end
    return filetypes
  end,
  init = function()
    local mason_ensure_installed = {}
    local server_name_to_mason_name = { -- Specify the name of the Mason package for LSPs where they differ
      jsonls = "json-lsp",
      lua_ls = "lua-language-server",
      yamlls = "yaml-language-server",
    }
    for server_name, _ in pairs(config.language_servers) do
      local mason_name = server_name_to_mason_name[server_name] or server_name
      if
        not vim.tbl_contains(mason_ensure_installed, mason_name)
        and not vim.tbl_contains(vim.g.mason_ensure_installed or {}, mason_name)
      then
        table.insert(mason_ensure_installed, mason_name)
      end
    end
    vim.g.mason_ensure_installed = vim.list_extend(vim.g.mason_ensure_installed or {}, mason_ensure_installed)
  end,
  config = function()
    -- Define a callback run each time when a language server is attached to a particular buffer where we can define
    --  buffer-local keymaps
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
      callback = function(event)
        local keymap = require("keymap")

        local bufnr = event.buf
        local map = keymap.get_buffer_local_map(bufnr)

        map("n", "<C-s>", vim.lsp.buf.signature_help, "Signature help")
        map("n", "gd", "<cmd>Trouble lsp_definitions<CR>", "Go to definitions")
        map("n", "gD", "<cmd>Trouble lsp_type_definitions<CR>", "Go to type definitions")
        map("n", "gra", vim.lsp.buf.code_action, "Code action")
        map("n", "grn", function() return ":IncRename " .. vim.fn.expand("<cword>") end, "Rename", { expr = true })
        map("n", "grr", "<cmd>Trouble lsp_references toggle<CR>", "References")
        map("n", "grx", "<cmd>LspRestart<CR>", "Restart LSP")

        -- Symbols keymaps
        map("n", "<leader>xs", "<cmd>Trouble symbols toggle<CR>", "Trouble: [S]ymbols")
        map(
          "n",
          "<leader>fs",
          function() require("plugins.core.telescope.builtin").lsp_document_symbols() end,
          "[F]ind: buffer [S]ymbols"
        )
        map(
          "n",
          "<leader>fS",
          function() require("plugins.core.telescope.builtin").lsp_workspace_symbols() end,
          "[F]ind: workspace [S]ymbols"
        )

        -- Next/previous reference navigation; let's define illuminate keymaps here to benefit from the "LspAttach"
        --  behavior
        keymap.set_move_pair({ "[r", "]r" }, {
          function() require("illuminate").goto_next_reference() end,
          function() require("illuminate").goto_prev_reference() end,
        }, {
          { desc = "Next reference", buffer = bufnr },
          { desc = "Previous reference", buffer = bufnr },
        })
      end,
    })

    -- LSP servers & clients (Neovim's) are able to communicate to each other what features they support. By default,
    --  Neovim doesn't support everything that is in the LSP Specification. With nvim-cmp, Neovim has more capabilities,
    --  so we create these new capabilities to broadcast them to the servers.
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()
    capabilities = vim.tbl_deep_extend("force", capabilities, cmp_capabilities)

    -- Make sure the language servers are installed and set them up. Mason is responsible for installing and managing
    --  language servers, so it must be setup before mason-lspconfig.
    require("mason").setup()
    require("mason-lspconfig").setup({
      handlers = {
        function(server_name)
          local server = config.language_servers[server_name] or {}
          -- This handles overriding only values explicitly passed by the server configuration above, which can be
          --  useful when disabling certain features of a language server
          server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
          require("lspconfig")[server_name].setup(server)
        end,
      },
    })
  end,
}
