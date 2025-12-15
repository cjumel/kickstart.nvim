return {
  "folke/snacks.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = false,
  priority = 500, -- Main UI stuff should be loaded first (but after the colorscheme)
  keys = {
    -- Bufdelete
    {
      "<leader><BS>",
      function() Snacks.bufdelete.delete() end,
      desc = "Delete buffer",
    },
    {
      -- TODO: when a release of Neovim with the `:restart` command is out, change this to use that command and display
      -- the dashboard again
      "<leader><S-BS>",
      function() Snacks.bufdelete.all() end,
      desc = "Delete all buffers",
    },
    {
      "<leader><M-BS>",
      function() Snacks.bufdelete.other() end,
      desc = "Delete other buffers",
    },
    {
      "<leader><C-BS>",
      function()
        if vim.fn.confirm("Do you want to delete the file definitely?", "&Yes\n&No") == 1 then
          local fname = vim.api.nvim_buf_get_name(0)
          Snacks.bufdelete.delete()
          vim.fn.delete(fname)
        end
      end,
      desc = "Delete buffer and file",
    },

    -- Gitbrowse
    { "<leader>go", function() Snacks.gitbrowse.open() end, desc = "[G]it: [O]pen repository" },

    -- Notifier
    { "<leader>,", function() Snacks.notifier.show_history() end, desc = "Notification history" },

    -- Picker
    { "<leader>.", function() Snacks.picker.resume() end, desc = "Resume picker" },
    {
      "<leader><Tab>",
      function()
        Snacks.picker.buffers({
          title = "Buffer Switcher",
          on_show = function(picker) picker.list.cursor = 2 end,
          sort = { fields = { "score:desc", "idx" } }, -- Don't sort by item length to preserve recency order
          layout = { preset = "telescope_dropdown" },
          win = { input = { keys = { ["<C-d>"] = { "bufdelete", mode = { "i" } } } } },
        })
      end,
      desc = "Buffer switcher",
    },
    {
      "<leader>:",
      function()
        Snacks.picker.command_history({
          sort = { fields = { "score:desc", "idx" } }, -- Don't sort by item length to preserve history order
          layout = { preset = "telescope_dropdown" },
        })
      end,
      desc = "Command history",
    },
    {
      "<leader>?",
      function()
        Snacks.picker.search_history({
          sort = { fields = { "score:desc", "idx" } }, -- Don't sort by item length to preserve history order
          layout = { preset = "telescope_dropdown" },
        })
      end,
      desc = "Search history",
    },
    { "<leader>/", function() Snacks.picker.lines() end, desc = "Search lines" },
    {
      "<leader>ff",
      function()
        Snacks.picker.files({
          title = "Files",
          hidden = true,
          layout = { preset = "telescope_horizontal" },
          show_empty = true, -- Some stuff can appear after using toggles
          cwd = vim.bo.filetype == "oil" and require("oil").get_current_dir() or nil,
          only_directory = vim.bo.filetype == "oil",
        })
      end,
      desc = "[F]ind: [F]iles",
    },
    {
      "<leader>fr",
      function()
        Snacks.picker.recent({
          title = "Recent Files",
          filter = {
            cwd = true,
            paths = false, ---@diagnostic disable-line: assign-type-mismatch
          },
          sort = { fields = { "score:desc", "idx" } }, -- Don't sort by item length to preserve history order
          layout = { preset = "telescope_horizontal" },
          only_cwd = true,
          toggles = { only_cwd = "c" },
          show_empty = true, -- Some stuff can appear after using toggles
          actions = {
            toggle_only_cwd_custom = function(picker)
              local opts = picker.opts or {}
              opts.filter = opts.filter or {}
              opts.filter.cwd = not opts.filter.cwd
              opts.only_cwd = not opts.only_cwd ---@diagnostic disable-line: inject-field
              picker:find()
            end,
          },
          win = { input = { keys = { ["<M-c>"] = { "toggle_only_cwd_custom", mode = "i" } } } },
        })
      end,
      desc = "[F]ind: [R]ecent files",
    },
    {
      "<leader>fd",
      function()
        Snacks.picker.pick("directories", {
          title = "Directories",
          hidden = true,
          layout = { preset = "telescope_horizontal" },
          show_empty = true, -- Some stuff can appear after using toggles
          cwd = vim.bo.filetype == "oil" and require("oil").get_current_dir() or nil,
          only_directory = vim.bo.filetype == "oil",
        })
      end,
      desc = "[F]ind: [D]irectories",
    },
    {
      "<leader>fg",
      function()
        Snacks.picker.grep({
          title = "Grep",
          hidden = true,
          regex = false,
          layout = { preset = "telescope_vertical" },
          cwd = vim.bo.filetype == "oil" and require("oil").get_current_dir() or nil,
          only_directory = vim.bo.filetype == "oil",
        })
      end,
      desc = "[F]ind: [G]rep",
    },
    {
      "<leader>fg",
      function()
        Snacks.picker.grep_word({
          title = "Grep",
          layout = { preset = "telescope_vertical" },
          show_empty = true, -- Some stuff can appear after using toggles
          cwd = vim.bo.filetype == "oil" and require("oil").get_current_dir() or nil,
          only_directory = vim.bo.filetype == "oil",
        })
      end,
      mode = "x",
      desc = "[F]ind: [G]rep",
    },
    {
      "<leader>fs",
      function()
        Snacks.picker.lsp_symbols({
          title = "Symbols",
          sort = { fields = { "score:desc", "idx" } }, -- Don't sort by item length to preserve document order
          layout = { preset = "telescope_horizontal" },
          show_empty = true, -- Some stuff can appear after using toggles
          toggles = {
            workspace = "w",
            all_symbols = "a",
          },
          actions = {
            toggle_workspace_custom = function(picker)
              local opts = picker.opts or {}
              opts.workspace = not opts.workspace ---@diagnostic disable-line: inject-field
              opts.tree = not opts.tree ---@diagnostic disable-line: inject-field
              opts.supports_live = not opts.supports_live
              opts.live = not opts.live
              picker:find()
            end,
            toggle_all_symbols_custom = function(picker)
              local opts = picker.opts or {}
              if not opts.default_filter then
                opts.default_filter = vim.deepcopy(opts.filter) ---@diagnostic disable-line: inject-field
              end
              opts.all_symbols = not opts.all_symbols ---@diagnostic disable-line: inject-field
              if opts.all_symbols then
                for k, _ in pairs(opts.filter) do
                  opts.filter[k] = true
                end
              else
                opts.filter = vim.deepcopy(opts.default_filter)
              end
              picker:find()
            end,
          },
          win = {
            input = {
              keys = {
                ["<M-w>"] = { "toggle_workspace_custom", mode = "i" },
                ["<M-a>"] = { "toggle_all_symbols_custom", mode = "i" },
              },
            },
          },
        })
      end,
      desc = "[F]ind: [S]ymbols",
    },
    {
      "<leader>fu",
      function()
        Snacks.picker.undo({
          title = "Undo Tree",
          layout = { preset = "telescope_horizontal" },
          sort = { fields = { "score:desc", "idx" } }, -- Don't sort by item length to preserve recency order
          win = {
            input = {
              keys = {
                ["<CR>"] = { { "yank_add", "close" }, mode = "i" },
                ["<S-CR>"] = { { "yank_del", "close" }, mode = "i" },
              },
            },
          },
        })
      end,
      desc = "[F]ind: [U]ndo tree",
    },
    {
      "<leader>fh",
      function() Snacks.picker.help({ layout = { preset = "telescope_horizontal" } }) end,
      desc = "[F]ind: [H]elp",
    },
    {
      "<leader>fm",
      function()
        Snacks.picker.man({
          title = "Man Pages",
          layout = { preset = "telescope_horizontal" },
        })
      end,
      desc = "[F]ind: [M]an pages",
    },
    {
      "<leader>fc",
      function()
        Snacks.picker.commands({
          ---@diagnostic disable-next-line: assign-type-mismatch
          layout = { preset = "telescope_horizontal", preview = false },
        })
      end,
      desc = "[F]ind: [C]ommands",
    },
    {
      "<leader>fk",
      function()
        Snacks.picker.keymaps({
          ---@diagnostic disable-next-line: assign-type-mismatch
          layout = { preset = "telescope_horizontal", preview = false },
        })
      end,
      desc = "[F]ind: [K]eymaps",
    },
    {
      "<leader>gg",
      function()
        Snacks.picker.git_status({
          title = "Git Files",
          layout = { preset = "telescope_horizontal" },
          toggles = {
            staged = "s",
            unstaged = "u",
            conflicts = "c",
          },
          transform = function(item, ctx)
            local opts = ctx.picker.opts or {}
            local status_filters = {}
            if opts.staged then ---@diagnostic disable-line: undefined-field
              vim.list_extend(status_filters, { "M ", "MM", "A ", "AM", "D ", "R " })
            end
            if opts.unstaged then ---@diagnostic disable-line: undefined-field
              vim.list_extend(status_filters, { " M", " D", "MM", "??" })
            end
            if opts.conflicts then ---@diagnostic disable-line: undefined-field
              vim.list_extend(status_filters, { "UU" })
            end
            return vim.tbl_isempty(status_filters) and true or vim.tbl_contains(status_filters, item.status)
          end,
          actions = {
            toggle_staged_custom = function(picker)
              local opts = picker.opts or {}
              opts.staged = not opts.staged ---@diagnostic disable-line: inject-field
              opts.unstaged = false ---@diagnostic disable-line: inject-field
              opts.conflicts = false ---@diagnostic disable-line: inject-field
              picker:find()
            end,
            toggle_unstaged_custom = function(picker)
              local opts = picker.opts or {}
              opts.staged = false ---@diagnostic disable-line: inject-field
              opts.unstaged = not opts.unstaged ---@diagnostic disable-line: inject-field
              opts.conflicts = false ---@diagnostic disable-line: inject-field
              picker:find()
            end,
            toggle_conflicts_custom = function(picker)
              local opts = picker.opts or {}
              opts.staged = false ---@diagnostic disable-line: inject-field
              opts.unstaged = false ---@diagnostic disable-line: inject-field
              opts.conflicts = not opts.conflicts ---@diagnostic disable-line: inject-field
              picker:find()
            end,
          },
          win = {
            input = {
              keys = {
                ["<Tab>"] = { "list_down", mode = "i" }, -- Avoid picker-specific remapping
                ["<M-s>"] = { "toggle_staged_custom", mode = "i" },
                ["<M-u>"] = { "toggle_unstaged_custom", mode = "i" },
                ["<M-c>"] = { "toggle_conflicts_custom", mode = "i" },
              },
            },
          },
        })
      end,
      desc = "[G]it: files",
    },
    {
      "<leader>gb",
      function() Snacks.picker.git_branches({ layout = { preset = "telescope_vertical" } }) end,
      desc = "[G]it: [B]ranch",
    },
    {
      "<leader>gl",
      function()
        Snacks.picker.git_log({
          title = "Git Log",
          layout = { preset = "telescope_horizontal" },
          confirm = { { action = "yank", field = "commit", reg = "+" }, "close" },
          toggles = {
            current_file = "c", -- Avoid using "f" to let the <M-f> keymap available
            current_line = "l",
          },
          actions = {
            toggle_current_file_custom = function(picker)
              local opts = picker.opts or {}
              opts.current_file = not opts.current_file ---@diagnostic disable-line: inject-field
              opts.current_line = false ---@diagnostic disable-line: inject-field
              opts.follow = opts.current_file ---@diagnostic disable-line: inject-field
              picker:find()
            end,
            toggle_current_line_custom = function(picker)
              local opts = picker.opts or {}
              opts.current_file = false ---@diagnostic disable-line: inject-field
              opts.current_line = not opts.current_line ---@diagnostic disable-line: inject-field
              opts.follow = opts.current_line ---@diagnostic disable-line: inject-field
              picker:find()
            end,
          },
          win = {
            input = {
              keys = {
                ["<M-c>"] = { "toggle_current_file_custom", mode = "i" },
                ["<M-l>"] = { "toggle_current_line_custom", mode = "i" },
              },
            },
          },
        })
      end,
      desc = "[G]it: [L]og",
    },

    -- Scratch buffers
    {
      "<leader>ss",
      function() -- Based on Snacks.scratch.select, restricted to the current working directory
        local items = Snacks.scratch.list()
        local selection_items = {}
        local widths = { 0, 0 }
        local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:~")
        for _, item in ipairs(items) do
          if vim.fn.fnamemodify(item.cwd, ":p:~") == cwd then
            item.icon = item.icon or Snacks.util.icon(item.ft, "filetype")
            item.name = item.count > 1 and item.name .. " " .. item.count or item.name
            widths[1] = math.max(widths[1], vim.api.nvim_strwidth(item.icon))
            widths[2] = math.max(widths[2], vim.api.nvim_strwidth(item.name))
            table.insert(selection_items, item)
          end
        end
        if vim.tbl_isempty(items) then
          vim.notify("No scratch file found", vim.log.levels.WARN)
          return
        end
        vim.ui.select(selection_items, {
          prompt = "Scratch files",
          format_item = function(item)
            local parts = { item.icon, item.name }
            for i, part in ipairs(parts) do
              parts[i] = part .. string.rep(" ", widths[i] - vim.api.nvim_strwidth(part))
            end
            return table.concat(parts, " ")
          end,
        }, function(selected)
          if selected then
            Snacks.scratch.open({ icon = selected.icon, file = selected.file, name = selected.name, ft = selected.ft })
          end
        end)
      end,
      desc = "[S]cratch: [S]elect",
    },
    {
      "<leader>sa",
      function() -- Based on Snacks.scratch.select
        local items = Snacks.scratch.list()
        local selection_items = {}
        local widths = { 0, 0, 0 }
        for _, item in ipairs(items) do
          item.cwd = vim.fn.fnamemodify(item.cwd, ":p:~") .. "  "
          item.icon = item.icon or Snacks.util.icon(item.ft, "filetype")
          item.name = item.count > 1 and item.name .. " " .. item.count or item.name
          widths[1] = math.max(widths[1], vim.api.nvim_strwidth(item.cwd))
          widths[2] = math.max(widths[2], vim.api.nvim_strwidth(item.icon))
          widths[3] = math.max(widths[3], vim.api.nvim_strwidth(item.name))
          table.insert(selection_items, item)
        end
        if vim.tbl_isempty(items) then
          vim.notify("No scratch file found", vim.log.levels.WARN)
          return
        end
        vim.ui.select(selection_items, {
          prompt = "All scratch files",
          format_item = function(item)
            local parts = { item.cwd, item.icon, item.name }
            for i, part in ipairs(parts) do
              parts[i] = part .. string.rep(" ", widths[i] - vim.api.nvim_strwidth(part))
            end
            return table.concat(parts, " ")
          end,
        }, function(selected)
          if selected then
            Snacks.scratch.open({ icon = selected.icon, file = selected.file, name = selected.name, ft = selected.ft })
          end
        end)
      end,
      desc = "[S]cratch: select [A]ll",
    },
    {
      "<leader>sc",
      function()
        vim.ui.input({ prompt = "Filetype" }, function(filetype)
          if filetype then
            local items = Snacks.scratch.list()
            local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:~")
            local item_names = {}
            for _, item in ipairs(items) do
              if item.ft == filetype and item.cwd and vim.fn.fnamemodify(item.cwd, ":p:~") == cwd then
                table.insert(item_names, item.name)
              end
            end
            local default_base_name = filetype:sub(1, 1):upper() .. filetype:sub(2) .. " scratch"
            local name, count = nil, 1
            while name == nil or vim.tbl_contains(item_names, name) do
              name = default_base_name .. " " .. count
              count = count + 1
            end
            Snacks.scratch.open({ ft = filetype, name = name })
          end
        end)
      end,
      desc = "[S]cratch: [C]reate",
    },
    {
      "<leader>sf",
      function()
        local items = Snacks.scratch.list()
        local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:~")
        local item_names = {}
        for _, item in ipairs(items) do
          if item.ft == vim.bo.filetype and item.cwd and vim.fn.fnamemodify(item.cwd, ":p:~") == cwd then
            table.insert(item_names, item.name)
          end
        end
        local default_base_name = vim.bo.filetype:sub(1, 1):upper() .. vim.bo.filetype:sub(2) .. " scratch"
        local name, count = nil, 1
        while name == nil or vim.tbl_contains(item_names, name) do
          name = default_base_name .. " " .. count
          count = count + 1
        end
        Snacks.scratch.open({ name = name })
      end,
      desc = "[S]cratch: create with [F]iletype",
    },
    {
      "<leader>sn",
      function() Snacks.scratch.open({ ft = "markdown", name = "Note" }) end,
      desc = "[S]cratch: open [N]ote",
    },
    {
      "<leader>sl",
      function()
        local items = Snacks.scratch.list()
        local selected = items[1] -- Items are ordered with last opened first
        Snacks.scratch.open({ icon = selected.icon, file = selected.file, name = selected.name, ft = selected.ft })
      end,
      desc = "[S]cratch: open [L]ast",
    },

    -- Zen mode
    { "<leader>z", function() Snacks.zen.zoom() end, desc = "[Z]oom" },
  },
  opts = {
    bigfile = { enabled = true },

    dashboard = {
      enabled = true,
      sections = {
        { section = "header" },
        { icon = " ", key = "c", desc = "Open [C]wd", action = "-" },
        { icon = " ", key = "f", desc = "Find [F]iles", action = "<leader>ff" },
        { icon = " ", key = "r", desc = "Find [R]ecent Files", action = "<leader>fr" },
        { icon = " ", key = "d", desc = "Find [D]irectories", action = "<leader>fd" },
        { icon = "󰚰 ", key = "g", desc = "[G]it Files", action = "<leader>gg" },
        { icon = " ", key = "b", desc = "Git [B]ranch", action = "<leader>gb" },
        { icon = " ", key = "l", desc = "Git [L]og", action = "<leader>gl" },
        { icon = "󰊢 ", key = "m", desc = "Git [M]enu", action = "<leader>gm" },
        { icon = "󱞁 ", key = "n", desc = "Open [N]ote", action = "<leader>sn" },
        { icon = " ", key = "q", desc = "[Q]uit", action = ":qa" },
      },
    },

    input = {
      enabled = true,
      win = {
        keys = {
          i_ctrl_n = { "<C-n>", "hist_down", mode = "i" },
          i_ctrl_p = { "<C-p>", "hist_up", mode = "i" },
          i_esc = { "<Esc>", "cancel", mode = "i" },
          i_ctrl_c = { "<C-C>", "cancel", mode = "i" },
        },
      },
    },

    notifier = { enabled = true },

    picker = {
      enabled = true, -- Use Snacks picker for vim.ui.select
      toggles = {
        only_directory = "d",
      },
      sources = {
        directories = {
          finder = function(opts, ctx)
            opts.cmd = "fd"
            local args = { "--type", "d", "--exclude", ".git" }
            if opts.hidden then
              table.insert(args, "--hidden")
            end
            if opts.ignored then
              table.insert(args, "--no-ignore")
            end
            opts.args = args
            local cwd = opts.cwd or vim.fn.getcwd()
            opts.transform = function(item)
              item.file = cwd .. "/" .. item.text
              item.dir = true
            end
            return require("snacks.picker.source.proc").proc(opts, ctx)
          end,
        },
      },
      actions = {
        disable_only_directory = function(picker)
          local opts = picker.opts or {}
          if opts.only_directory then
            opts.only_directory = false
            picker:set_cwd(vim.fn.getcwd())
          end
          picker:find()
        end,
        -- Action adatped from https://github.com/folke/snacks.nvim/blob/main/lua/snacks/picker/actions.lua#L447-L447
        qflist_trouble = function(picker)
          picker:close()
          local sel = picker:selected()
          local items = #sel > 0 and sel or picker:items()
          local qf = {}
          for _, item in ipairs(items) do
            qf[#qf + 1] = {
              filename = Snacks.picker.util.path(item),
              bufnr = item.buf,
              lnum = item.pos and item.pos[1] or 1,
              col = item.pos and item.pos[2] + 1 or 1,
              end_lnum = item.end_pos and item.end_pos[1] or nil,
              end_col = item.end_pos and item.end_pos[2] + 1 or nil,
              text = item.line or item.comment or item.label or item.name or item.detail or item.text,
              pattern = item.search,
              valid = true,
            }
          end
          vim.fn.setqflist(qf)
          vim.cmd("Trouble qflist")
        end,
        -- Action adatped from https://github.com/folke/snacks.nvim/blob/main/lua/snacks/picker/actions.lua#L461-L461
        loclist_trouble = function(picker)
          picker:close()
          local sel = picker:selected()
          local items = #sel > 0 and sel or picker:items()
          local qf = {}
          for _, item in ipairs(items) do
            qf[#qf + 1] = {
              filename = Snacks.picker.util.path(item),
              bufnr = item.buf,
              lnum = item.pos and item.pos[1] or 1,
              col = item.pos and item.pos[2] + 1 or 1,
              end_lnum = item.end_pos and item.end_pos[1] or nil,
              end_col = item.end_pos and item.end_pos[2] + 1 or nil,
              text = item.line or item.comment or item.label or item.name or item.detail or item.text,
              pattern = item.search,
              valid = true,
            }
          end
          vim.fn.setloclist(picker.main, qf)
          vim.cmd("Trouble loclist")
        end,
      },
      layouts = {
        -- Custom layouts are adapted from the "telescope" preset and are heavily inspired by my old Telescope layouts
        telescope_horizontal = {
          layout = {
            box = "horizontal",
            backdrop = false,
            width = 0.9,
            height = 0.9,
            border = "none",
            {
              box = "vertical",
              { win = "input", title = "{title} {live} {flags}", title_pos = "center", height = 1, border = "rounded" },
              { win = "list", title = " Results ", title_pos = "center", border = "rounded" },
            },
            { win = "preview", title = "{preview:Preview}", title_pos = "center", width = 0.5, border = "rounded" },
          },
        },
        telescope_vertical = {
          layout = {
            box = "vertical",
            backdrop = false,
            width = 0.9,
            height = 0.9,
            border = "none",
            { win = "input", title = "{title} {live} {flags}", title_pos = "center", height = 1, border = "rounded" },
            { win = "list", title = " Results ", title_pos = "center", border = "rounded" },
            { win = "preview", title = "{preview:Preview}", title_pos = "center", border = "rounded" },
          },
        },
        telescope_dropdown = {
          layout = {
            box = "vertical",
            backdrop = false,
            width = 0.5,
            height = 0.4,
            border = "none",
            { win = "input", title = "{title} {live} {flags}", title_pos = "center", height = 1, border = "rounded" },
            { win = "list", title = " Results ", title_pos = "center", border = "rounded" },
          },
        },
      },
      previewers = { diff = { style = "syntax" } },
      win = {
        input = {
          keys = {
            ["<CR>"] = { "confirm", mode = "i" },
            ["<Tab>"] = { "list_down", mode = "i" },
            ["<S-Tab>"] = { "list_up", mode = "i" },
            ["<Esc>"] = { "cancel", mode = "i" },
            ["<C-n>"] = { "list_down", mode = "i" },
            ["<C-p>"] = { "list_up", mode = "i" },
            ["<C-g>"] = { "list_top", mode = "i" }, -- Mnemonic: like `gg`
            ["<C-s>"] = { "select_and_next", mode = "i" },
            ["<C-q>"] = { "qflist_trouble", mode = "i" },
            ["<C-l>"] = { "loclist_trouble", mode = "i" },
            ["<C-j>"] = { "preview_scroll_down", mode = "i" },
            ["<C-k>"] = { "preview_scroll_up", mode = "i" },
            ["<C-c>"] = { "cancel", mode = "i" },
            ["<M-p>"] = { "toggle_preview", mode = "i" },
            ["<M-h>"] = { "toggle_hidden", mode = "i" },
            ["<M-i>"] = { "toggle_ignored", mode = "i" },
            ["<M-r>"] = { "toggle_regex", mode = "i" },
            ["<M-d>"] = { "disable_only_directory", mode = "i" },
            ["<C-b>"] = false,
            ["<C-f>"] = false,
            ["<C-a>"] = false,
            ["<C-e>"] = false,
            ["<M-b>"] = false,
            ["<M-f>"] = false,
            ["<C-u>"] = false,
            ["<C-d>"] = false,
          },
        },
      },
    },

    quickfile = { enabled = true },

    scratch = {
      -- Don't use nvim user data to avoid losing the scratch files on full nvim cleaning
      root = vim.env.HOME .. "/.local/share/scratch-files",
      filekey = { branch = false },
      win = {
        keys = {
          ["delete"] = {
            "<localleader>d",
            function(self)
              if vim.fn.confirm("Do you want to delete the scratch file definitely?", "&Yes\n&No") == 1 then
                local fname = vim.api.nvim_buf_get_name(self.buf)
                vim.cmd([[close]])
                vim.fn.delete(fname)
              end
            end,
            desc = "[D]elete file",
          },
          ["expand"] = {
            "<localleader>e",
            function(self)
              vim.cmd([[close]])
              vim.api.nvim_set_current_buf(self.buf)
            end,
            desc = "[E]xpand window",
          },
          ["q"] = { "q", function() vim.cmd([[close]]) end, desc = "[Q]uit" },
          ["source"] = false, -- Prefer overseer.nvim to source files
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
      notification = { wo = { wrap = true } }, -- Avoid notification truncation
      notification_history = {
        wo = { number = false, relativenumber = false, signcolumn = "yes" },
        keys = {
          ["expand"] = {
            "<localleader>e",
            function(self)
              vim.cmd([[close]])
              vim.api.nvim_set_current_buf(self.buf)
            end,
            desc = "[E]xpand window",
          },
        },
      },
    },
  },
}
