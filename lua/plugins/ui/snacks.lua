-- snacks.nvim
--
-- Meta plugin providing a collection of small quality-of-life plugins for Neovim. All these plugigns work very nicely
-- out-of-the-box, with great default behaviors, and bring many UI improvements as well as new cool atomic features.

-- Define custom layouts. This is not done in the `opts` table, as it may have side effects in some pickers there.
local horizontal_layout = { -- Adapted from the "telescope" preset layout
  layout = {
    box = "horizontal",
    backdrop = false,
    width = 0.9,
    height = 0.9,
    border = "none",
    {
      box = "vertical",
      {
        win = "input",
        height = 1,
        border = "rounded",
        title = "{title} {live} {flags}",
        title_pos = "center",
      },
      {
        win = "list",
        title = " Results ",
        title_pos = "center",
        border = "rounded",
      },
    },
    {
      win = "preview",
      title = "{preview:Preview}",
      width = 0.5,
      border = "rounded",
      title_pos = "center",
    },
  },
}

local function directory_finder(opts, ctx)
  local cwd = opts.cwd or vim.fn.getcwd()
  local args = { "--type", "d", "--exclude", ".git" }
  if opts.hidden then
    table.insert(args, "--hidden")
  end
  if opts.ignored then
    table.insert(args, "--no-ignore")
  end
  return require("snacks.picker.source.proc").proc({
    opts,
    {
      cmd = "fd",
      args = args,
      transform = function(item)
        item.file = vim.fn.fnamemodify(cwd .. "/" .. item.text, ":p")
        item.dir = true
      end,
    },
  }, ctx)
end

return {
  "folke/snacks.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = false,
  priority = 500, -- Main UI stuff should be loaded first (but after the colorscheme)
  keys = {
    -- Bufdelete
    { "<leader><BS>", function() Snacks.bufdelete.delete() end, desc = "Delete current buffer" },
    { "<leader><C-BS>", function() Snacks.bufdelete.all() end, desc = "Delete all buffers" },
    { "<leader><M-BS>", function() Snacks.bufdelete.other() end, desc = "Delete other buffers" },

    -- Gitbrowse
    { "<leader>gr", function() Snacks.gitbrowse.open() end, desc = "[G]it: open [R]epository" },

    -- Notifier
    { "<leader>n", function() Snacks.notifier.show_history() end, desc = "[N]otifications" },

    -- Picker
    { "<leader>=", function() Snacks.picker.lines({ title = "" }) end, desc = "Pick lines" },
    { "<leader>+", function() Snacks.picker.resume() end, desc = "Resume picker" },
    { "<leader>-", function() Snacks.picker.explorer({ title = "" }) end, desc = "File Explorer" },
    {
      "<leader>ff",
      function()
        local opts = { title = "Files", search = require("visual_mode").get_text_if_on(), layout = horizontal_layout }
        if vim.bo.filetype == "oil" then
          local dir = vim.fn.fnamemodify(require("oil").get_current_dir() --[[@as string]], ":p:~:.")
          opts.title = opts.title .. " (" .. dir .. ")"
          opts.cwd = dir
        end
        Snacks.picker.files(opts)
      end,
      mode = { "n", "x" },
      desc = "[F]ind: [F]iles",
    },
    {
      "<leader>fr",
      function()
        local opts = { title = "Recent Files", filter = { cwd = true }, layout = horizontal_layout }
        if vim.bo.filetype == "oil" then
          local dir = vim.fn.fnamemodify(require("oil").get_current_dir() --[[@as string]], ":p:~:.")
          opts.title = opts.title .. " (" .. dir .. ")"
          opts.cwd = dir
        end
        Snacks.picker.recent(opts)
      end,
      desc = "[F]ind: [R]ecent files",
    },
    {
      "<leader>fo",
      function() Snacks.picker.recent({ title = "Old Files", layout = horizontal_layout }) end,
      desc = "[F]ind: [O]ld files",
    },
    {
      "<leader>fd",
      function()
        local opts = {
          title = "Directories",
          finder = directory_finder,
          layout = horizontal_layout,
        }
        if vim.bo.filetype == "oil" then
          local dir = vim.fn.fnamemodify(require("oil").get_current_dir() --[[@as string]], ":p:~:.")
          opts.title = opts.title .. " (" .. dir .. ")"
          opts.cwd = dir
        end
        Snacks.picker.pick(opts)
      end,
      desc = "[F]ind: [D]irectories",
    },
    {
      "<leader>fg",
      function()
        local opts = { title = "Grep", layout = horizontal_layout }
        if vim.bo.filetype == "oil" then
          local dir = vim.fn.fnamemodify(require("oil").get_current_dir() --[[@as string]], ":p:~:.")
          opts.title = opts.title .. " (" .. dir .. ")"
          opts.cwd = dir
        end
        Snacks.picker.grep(opts)
      end,
      mode = "n",
      desc = "[F]ind: [G]rep",
    },
    {
      "<leader>fg",
      function()
        local opts = { title = "Grep", layout = horizontal_layout }
        if vim.bo.filetype == "oil" then
          local dir = vim.fn.fnamemodify(require("oil").get_current_dir() --[[@as string]], ":p:~:.")
          opts.title = opts.title .. " (" .. dir .. ")"
          opts.cwd = dir
        end
        Snacks.picker.grep_word(opts)
      end,
      mode = "x",
      desc = "[F]ind: [G]rep",
    },
    {
      "<leader>fs",
      function() Snacks.picker.lsp_symbols({ title = "Document Symbols", layout = horizontal_layout }) end,
      desc = "[F]ind: document [S]ymbols",
    },
    {
      "<leader>fS",
      function()
        Snacks.picker.lsp_symbols({
          title = "Document Symbols (all)",
          filter = { default = true },
          layout = horizontal_layout,
        })
      end,
      desc = "[F]ind: document [S]ymbols (all)",
    },
    {
      "<leader>fw",
      function() Snacks.picker.lsp_workspace_symbols({ title = "Workspace Symbols", layout = horizontal_layout }) end,
      desc = "[F]ind: [W]orkspace symbols",
    },
    {
      "<leader>fW",
      function()
        Snacks.picker.lsp_workspace_symbols({
          title = "Workspace Symbols (all)",
          filter = { default = true },
          layout = horizontal_layout,
        })
      end,
      desc = "[F]ind: [W]orkspace symbols (all)",
    },
    {
      "<leader>fu",
      function()
        Snacks.picker.undo({
          title = "Undo Tree",
          win = {
            input = {
              keys = {
                ["<C-y>"] = { { "yank_add", "close" }, mode = "i" }, -- Add close action
                ["Ú"] = { { "yank_del", "close" }, mode = "i" }, -- <M-y> (instead of <C-S-y>), add close action
              },
            },
          },
          layout = horizontal_layout,
        })
      end,
      desc = "[F]ind: [U]ndo tree",
    },

    -- Scratch buffers
    { "<leader>tt", function() Snacks.scratch.select() end, desc = "[T]emp: select" },
    {
      "<leader>tn",
      function() Snacks.scratch.open({ name = "Note", ft = "markdown" }) end,
      desc = "[T]emp: [N]ote",
    },
    {
      "<leader>tf",
      function() Snacks.scratch.open({ name = "File (" .. vim.bo.filetype .. ")" }) end,
      desc = "[T]emp: [F]ile",
    },

    -- Zen mode
    { "<leader>z", function() Snacks.zen() end, desc = "[Z]en mode" },
  },
  opts = {
    bigfile = { enabled = true },

    dashboard = {
      enabled = true,
      sections = {
        { section = "header" },
        { icon = " ", key = "c", desc = "Open current directory", action = function() require("oil").open() end },
        {
          icon = " ",
          key = "f",
          desc = "Find Files",
          action = function() Snacks.picker.files({ title = "Files", layout = horizontal_layout }) end,
        },
        {
          icon = " ",
          key = "r",
          desc = "Find Recent files",
          action = function()
            Snacks.picker.recent({ title = "Recent Files", filter = { cwd = true }, layout = horizontal_layout })
          end,
        },
        {
          icon = " ",
          key = "o",
          desc = "Find Old files",
          action = function() Snacks.picker.recent({ title = "Old Files", layout = horizontal_layout }) end,
        },
        {
          icon = " ",
          key = "d",
          desc = "Find Directories",
          action = function()
            Snacks.picker.pick({ title = "Directories", finder = directory_finder, layout = horizontal_layout })
          end,
        },
        {
          icon = "󰚰 ",
          key = "g",
          desc = "View Git Status",
          action = function() require("plugins.core.telescope.pickers").git_status() end,
        },
        {
          icon = " ",
          key = "b",
          desc = "View Git Branch",
          action = function() require("plugins.core.telescope.pickers").git_branches() end,
        },
        {
          icon = " ",
          key = "l",
          desc = "View Git Log",
          action = function() require("plugins.core.telescope.pickers").git_commits() end,
        },
        { icon = "󰊢 ", key = "n", desc = "Open Neogit", action = function() require("neogit").open() end },
        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
      },
    },

    input = {
      enabled = true,
      win = {
        keys = {
          i_ctrl_n = { "<C-n>", "hist_down", mode = "i" },
          i_ctrl_p = { "<C-p>", "hist_up", mode = "i" },
          i_meta_bs = { "<M-BS>", "<c-s-w>", mode = "i", expr = true },
          i_esc = { "<Esc>", "cancel", mode = "i" },
          i_ctrl_c = { "<C-C>", "cancel", mode = "i" },
        },
      },
    },

    notifier = { enabled = true },

    picker = {
      enabled = true, -- Use Snacks picker for vim.ui.select
      formatters = {
        file = {
          truncate = 60, -- Increase the displayed file path length
        },
      },
      win = {
        input = {
          keys = {
            ["<Tab>"] = { "list_down", mode = "i" },
            ["<S-Tab>"] = { "list_up", mode = "i" },
            ["<C-CR>"] = { "select_and_next", mode = "i" },
            ["<C-BS>"] = { "select_and_prev", mode = "i" },
            ["<C-g>"] = { "list_top", mode = "i" }, -- Like the `gg` keymap
            ["<C-j>"] = { "preview_scroll_down", mode = "i" },
            ["<C-k>"] = { "preview_scroll_up", mode = "i" },
            ["<Esc>"] = { "cancel", mode = "i" },
            -- Toggles
            ["π"] = { "toggle_preview", mode = "i" }, -- <M-p>
            ["Ì"] = { "toggle_hidden", mode = "i" }, -- <M-h>
            ["î"] = { "toggle_ignored", mode = "i" }, -- <M-i>
            -- Insert-mode keymaps to keep
            ["<C-a>"] = false,
            ["<C-e>"] = false,
            ["<C-b>"] = false,
            ["<C-f>"] = false,
            ["<C-u>"] = false,
            ["<M-BS>"] = { "<C-S-w>", mode = "i", expr = true }, -- Fix <M-BS>
          },
        },
      },
    },

    quickfile = { enabled = true },

    scratch = {
      autowrite = false, -- Prevent untimely scratch file creation
      win = {
        keys = {
          ["delete"] = {
            "<C-BS>",
            function(self)
              if vim.fn.confirm("Do you want to delete the scratch file definitely?", "&Yes\n&No") == 1 then
                local fname = vim.api.nvim_buf_get_name(self.buf)
                vim.cmd([[close]]) -- Close the scratch buffer
                vim.fn.delete(fname) -- Delete the scratch file
              end
            end,
            desc = "delete",
          },
        },
      },
      win_by_ft = {
        lua = {
          keys = {
            ["source"] = {
              "<C-CR>",
              function(self)
                local command = "luajit"
                local fname = vim.api.nvim_buf_get_name(self.buf)
                local res = vim.system({ command, fname }, { text = true }):wait()
                if res.code ~= 0 then
                  Snacks.notify.error(res.stderr or "Unknown error.")
                else
                  Snacks.notify(res.stdout)
                end
              end,
              desc = "source",
            },
          },
        },
        python = {
          keys = {
            ["source"] = {
              "<C-CR>",
              function(self)
                local command = "python"
                local fname = vim.api.nvim_buf_get_name(self.buf)
                local res = vim.system({ command, fname }, { text = true }):wait()
                if res.code ~= 0 then
                  Snacks.notify.error(res.stderr or "Unknown error.")
                else
                  Snacks.notify(res.stdout)
                end
              end,
              desc = "source",
            },
          },
        },
      },
    },

    scroll = { enabled = true },

    words = { enabled = true },

    zen = {
      toggles = { dim = false },
      win = { width = 125 }, -- Support line-length up until 120
    },

    styles = {
      notification = { wo = { wrap = true } }, -- Don't truncate notifications
      notification_history = { wo = { number = false, relativenumber = false } },
      zen = { wo = { number = false, relativenumber = false, signcolumn = "yes" } },
    },
  },
  config = function(_, opts)
    Snacks.setup(opts)

    -- Simplify some picker highlights
    vim.api.nvim_set_hl(0, "SnacksPickerDir", { link = "SnacksPickerFile" }) -- For all file pickers
    vim.api.nvim_set_hl(0, "SnacksPickerDirectory", { link = "SnacksPickerFile" }) -- For the directory picker
  end,
}
