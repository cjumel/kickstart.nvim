-- nvim-cmp
--
-- Nvim-cmp is a lightweight and extensible completion plugin for neovim written in lua.

return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-path",
    "saadparwaiz1/cmp_luasnip",
    "L3MON4D3/LuaSnip",
    "clementjumel/cmp-gitmoji",
    "windwp/nvim-autopairs",
  },
  event = {
    "BufNewFile",
    "BufReadPre",
    "CmdlineEnter", -- For command line completion
  },
  config = function()
    local cmp = require("cmp")

    local select_next_item_or_complete = function()
      if cmp.visible() then
        cmp.select_next_item()
      else
        cmp.complete()
      end
    end
    local select_prev_item_or_complete = function()
      if cmp.visible() then
        cmp.select_prev_item()
      else
        cmp.complete()
      end
    end

    cmp.setup({
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = { -- By default, mappings are in insert mode
        ["<CR>"] = cmp.mapping.confirm(),
        ["<C-n>"] = select_next_item_or_complete,
        ["<C-p>"] = select_prev_item_or_complete,
        ["<C-c>"] = cmp.mapping.abort(),
        ["<C-d>"] = cmp.mapping.scroll_docs(5),
        ["<C-u>"] = cmp.mapping.scroll_docs(-5),
      },
      -- Sources are grouped by decreasing priority
      sources = cmp.config.sources({
        { name = "luasnip", priority = 2 },
        { name = "nvim_lsp", priority = 1 },
      }, {
        { name = "buffer" },
      }),
      -- Disable menu in completion window
      -- This menu can describe the source of the completion item (e.g. its global source like
      -- "LSP" or "Luasnip", or the module corresponding to a completion item for languages like
      -- Python), however disabling it solves an issue with the documentation window hiding the
      -- completion item (see https://github.com/hrsh7th/nvim-cmp/issues/1154 or
      -- https://github.com/hrsh7th/nvim-cmp/issues/1673).
      formatting = {
        format = function(_, vim_item)
          vim_item.menu = nil
          return vim_item
        end,
      },
    })

    -- Set configuration for specific filetypes
    cmp.setup.filetype({ "gitcommit", "NeogitCommitMessage" }, {
      sources = cmp.config.sources({
        { name = "gitmoji" },
      }, {
        { name = "buffer" },
      }),
    })
    cmp.setup.filetype("oil", {
      sources = cmp.config.sources({
        { name = "luasnip" },
      }),
    })

    -- Set configuration for command line
    local cmdline_mapping = { -- "c =" means command line mode
      ["<CR>"] = { c = cmp.mapping.confirm() },
      ["<C-n>"] = { c = select_next_item_or_complete },
      ["<C-p>"] = { c = select_prev_item_or_complete },
      ["<C-c>"] = { c = cmp.mapping.abort() },
    }
    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmdline_mapping,
      sources = {
        { name = "buffer" },
      },
    })
    cmp.setup.cmdline(":", {
      mapping = cmdline_mapping,
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        { name = "cmdline" },
      }),
    })

    -- Insert brackets & place the cursor between them when selecting a function or method item
    -- This feature creates some noise, but it's useful most often than not and it's easier to
    -- remove the brackets than to add them manually with my keybindings
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

    -- Dirty fix to prevent nvim-autopairs from adding brackets when importing functions in Python
    -- This only works on the first line of an import statement
    -- Source: https://github.com/windwp/nvim-autopairs/issues/206#issuecomment-1916003469
    local autopairs_utils = require("nvim-autopairs.utils")
    local python_handler = cmp_autopairs.filetypes["python"]["("].handler
    local custom_python_handler = function(char, item, bufnr, rules, commit_character)
      local line = autopairs_utils.text_get_current_line(bufnr)
      if line:match("^(from.*import.*)$") then
        return
      end
      python_handler(char, item, bufnr, rules, commit_character)
    end
    cmp_autopairs.filetypes["python"]["("].handler = custom_python_handler
  end,
}
