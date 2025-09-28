return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-path",
  },
  event = { "CmdlineEnter" }, -- Lazy-loading on a custom `InsertEnter` event is also defined in `./plugin/autocmds.lua`
  config = function()
    local cmp = require("cmp")

    cmp.setup({
      enabled = function()
        -- New filetypes
        if vim.tbl_contains({ "dap-repl", "dapui_watches" }, vim.bo.filetype) then
          return true
        end
        -- Default (see `cmp.config.default`)
        local disabled = false
        disabled = disabled or (vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt")
        disabled = disabled or (vim.fn.reg_recording() ~= "")
        disabled = disabled or (vim.fn.reg_executing() ~= "")
        return not disabled
      end,
      preselect = cmp.PreselectMode.None, -- Always select the first item by default
      -- Keymaps are defined in `./plugin/keymaps.lua`, since they mix nvim-cmp features with others, and to solve an
      -- issue with the custom `InsertEnter` lazy-loading event (keymaps not being available at the first `InsertEnter`
      -- trigger)
      mapping = {},
      snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
      completion = { completeopt = "menu,menuone,noinsert" }, -- Directly select the first sugggestion
      formatting = { -- Truncate too long completion menu items
        format = function(_, vim_item)
          local menu_len = 40
          local menu = vim_item.menu and vim_item.menu or ""
          if #menu > menu_len then
            vim_item.menu = string.sub(menu, 1, menu_len) .. "…"
          end
          return vim_item
        end,
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
      window = { completion = cmp.config.window.bordered(), documentation = cmp.config.window.bordered() },
    })

    cmp.setup.cmdline(":", { sources = { { name = "cmdline" } } })
    cmp.setup.cmdline({ "/", "?" }, { sources = { { name = "buffer" } } })
    cmp.setup.filetype("sql", { sources = { { name = "vim-dadbod-completion" } } })
    cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, { sources = { { name = "dap" } } })
  end,
}
