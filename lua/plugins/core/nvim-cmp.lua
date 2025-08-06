-- nvim-cmp
--
-- A completion engine plugin for neovim written in Lua.

return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-path",
    "windwp/nvim-autopairs",
  },
  event = { "CmdlineEnter" },
  init = function() -- Setup custom lazy-loading event
    vim.api.nvim_create_autocmd("InsertEnter", {
      callback = function()
        if vim.bo.buftype ~= "prompt" then
          Lazy.load({ plugins = { "nvim-cmp" } })
        end
      end,
    })
  end,
  config = function()
    local cmp = require("cmp")
    cmp.setup({
      enabled = function()
        -- Support new filetypes
        if vim.tbl_contains({ "dap-repl", "dapui_watches" }, vim.bo.filetype) then
          return true
        end
        -- Default implementation (see `cmp.config.default`)
        local disabled = false
        disabled = disabled or (vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt")
        disabled = disabled or (vim.fn.reg_recording() ~= "")
        disabled = disabled or (vim.fn.reg_executing() ~= "")
        return not disabled
      end,
      preselect = cmp.PreselectMode.None, -- Always select the first item by default
      snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
      completion = { completeopt = "menu,menuone,noinsert" }, -- Directly select the first sugggestion
      window = { completion = cmp.config.window.bordered(), documentation = cmp.config.window.bordered() },
      mapping = {
        -- <C-c> is mapped to `cmp.abort` and other things in the general keymaps
        ["<C-y>"] = cmp.mapping(cmp.mapping.confirm({ select = true }), { "i", "c" }),
        ["<C-n>"] = cmp.mapping(function()
          if cmp.visible() then
            cmp.select_next_item()
          else
            cmp.complete()
          end
        end, { "i", "c" }),
        ["<C-p>"] = cmp.mapping(function()
          if cmp.visible() then
            cmp.select_prev_item()
          else
            cmp.complete()
          end
        end, { "i", "c" }),
      },
      sources = {
        -- Only show `lazydev` completions when available, to skip loading lua_ls completions
        { name = "lazydev", group_index = 0 },
        { name = "luasnip", group_index = 1 },
        { name = "nvim_lsp", group_index = 1 },
        {
          name = "path",
          group_index = 1,
          option = { get_cwd = function() return vim.fn.getcwd() end },
        },
        {
          name = "buffer",
          group_index = 1,
          option = { get_bufnrs = function() return vim.api.nvim_list_bufs() end },
        },
      },
      -- Fix issue with too long menus in completion window (see https://github.com/hrsh7th/nvim-cmp/issues/1154)
      formatting = {
        format = function(_, vim_item)
          local menu_len = 40
          local menu = vim_item.menu and vim_item.menu or ""
          if #menu > menu_len then
            vim_item.menu = string.sub(menu, 1, menu_len) .. "…"
          end
          return vim_item
        end,
      },
    })

    -- Set up special sources
    cmp.setup.cmdline(":", { sources = { { name = "cmdline" } } })
    cmp.setup.cmdline({ "/", "?" }, { sources = { { name = "buffer" } } })
    cmp.setup.filetype("sql", { sources = { { name = "vim-dadbod-completion" } } })
    cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, { sources = { { name = "dap" } } })

    -- Set up automatic parenthesis insertion when completing a function
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
}
