-- nvim-cmp
--
-- nvim-cmp is a lightweight and extensible completion engine for Neovim written in Lua. It is fairly easy to use
-- (admittedly not as much as alternatives like blink.cmp, but I have issues with the later), and integrates well with
-- many tools, like LSP or code snippets. Having a plugin like this one in a Neovim configuration is really a must-have
-- in my opinion.

return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-path",
  },
  event = { "InsertEnter", "CmdlineEnter" }, -- CmdlineEnter is not covered by InsertEnter
  config = function()
    local cmp = require("cmp")

    cmp.setup({
      enabled = function()
        -- Support new filetypes
        if vim.tbl_contains({ "dap-repl", "dapui_watches", "dapui_hover" }, vim.bo.filetype) then
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
        { name = "luasnip" },
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "buffer" },
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
    cmp.setup.cmdline(":", {
      sources = {
        -- Only show `path` completions when available, to avoid redundancies with `cmdline`
        { name = "path", group_index = 0 },
        { name = "cmdline", group_index = 1 },
      },
    })
    cmp.setup.cmdline({ "/", "?" }, { sources = {
      { name = "buffer" },
    } })
    cmp.setup.filetype("lua", {
      sources = {
        -- Only show `lazydev` completions when available, to skip loading lua_ls completions
        { name = "lazydev", group_index = 0 },
        { name = "luasnip", group_index = 1 },
        { name = "nvim_lsp", group_index = 1 },
        { name = "path", group_index = 1 },
        { name = "buffer", group_index = 1 },
      },
    })
    cmp.setup.filetype("sql", {
      sources = {
        { name = "vim-dadbod-completion" },
      },
    })
    cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
      sources = {
        { name = "dap" },
      },
    })
  end,
}
