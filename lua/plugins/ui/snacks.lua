return {
  "folke/snacks.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = false,
  priority = 500, -- Main UI stuff should be loaded first (but after the colorscheme)
  keys = {
    -- Bufdelete
    { "<leader>xx", function() Snacks.bufdelete.delete() end, desc = "Delete: [B]uffer" },
    { "<leader>xa", function() Snacks.bufdelete.all() end, desc = "Delete: [A]ll buffers" },
    { "<leader>xo", function() Snacks.bufdelete.other() end, desc = "Delete: [O]ther buffers" },
    {
      "<leader>xf",
      function()
        if vim.fn.confirm("Do you want to delete the file definitely?", "&Yes\n&No") == 1 then
          local fname = vim.api.nvim_buf_get_name(0)
          Snacks.bufdelete.delete()
          vim.fn.delete(fname)
        end
      end,
      desc = "Delete: [F]ile",
    },

    -- Gitbrowse
    { "<leader>gr", function() Snacks.gitbrowse.open() end, desc = "[G]it: open [R]epository" },

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
          dirs = vim.bo.filetype == "oil" and { require("oil").get_current_dir() } or nil,
          directory = vim.bo.filetype == "oil",
          directory_path = vim.bo.filetype == "oil" and require("oil").get_current_dir() or nil,
          toggles = {
            directory = "d",
          },
          actions = {
            toggle_directory_ = function(picker)
              local opts = picker.opts or {}
              opts.directory = not opts.directory ---@diagnostic disable-line: inject-field
              opts.dirs = opts.directory and { opts.directory_path } or nil ---@diagnostic disable-line: undefined-field, inject-field
              picker:find()
            end,
          },
          win = {
            input = {
              keys = {
                ["<M-d>"] = { "toggle_directory_", mode = { "n", "i" } },
              },
            },
          },
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
            toggle_only_cwd_ = function(picker)
              local opts = picker.opts or {}
              opts.filter = opts.filter or {}
              opts.filter.cwd = not opts.filter.cwd
              opts.only_cwd = not opts.only_cwd ---@diagnostic disable-line: inject-field
              picker:find()
            end,
          },
          win = { input = { keys = { ["<M-c>"] = { "toggle_only_cwd_", mode = { "n", "i" } } } } },
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
          dirs = vim.bo.filetype == "oil" and { require("oil").get_current_dir() } or nil,
          directory = vim.bo.filetype == "oil",
          directory_path = vim.bo.filetype == "oil" and require("oil").get_current_dir() or nil,
          toggles = {
            directory = "d",
          },
          actions = {
            toggle_directory_ = function(picker)
              local opts = picker.opts or {}
              opts.directory = not opts.directory ---@diagnostic disable-line: inject-field
              opts.dirs = opts.directory and { opts.directory_path } or nil ---@diagnostic disable-line: undefined-field, inject-field
              picker:find()
            end,
          },
          win = {
            input = {
              keys = {
                ["<M-d>"] = { "toggle_directory_", mode = { "n", "i" } },
              },
            },
          },
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
          dirs = vim.bo.filetype == "oil" and { require("oil").get_current_dir() } or nil,
          directory = vim.bo.filetype == "oil",
          directory_path = vim.bo.filetype == "oil" and require("oil").get_current_dir() or nil,
          toggles = {
            directory = "d",
          },
          actions = {
            toggle_directory_ = function(picker)
              local opts = picker.opts or {}
              opts.directory = not opts.directory ---@diagnostic disable-line: inject-field
              opts.dirs = opts.directory and { opts.directory_path } or nil ---@diagnostic disable-line: undefined-field, inject-field
              picker:find()
            end,
          },
          win = {
            input = {
              keys = {
                ["<M-d>"] = { "toggle_directory_", mode = { "n", "i" } },
              },
            },
          },
        })
      end,
      desc = "[F]ind: [G]rep",
    },
    {
      "<leader>fg",
      function()
        Snacks.picker.grep_word({
          title = "Grep",
          hidden = true,
          layout = { preset = "telescope_vertical" },
          show_empty = true, -- Some stuff can appear after using toggles
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
            all_symbols = "a",
          },
          actions = {
            toggle_all_symbols_ = function(picker)
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
                ["<M-a>"] = { "toggle_all_symbols_", mode = { "n", "i" } },
              },
            },
          },
        })
      end,
      desc = "[F]ind: [S]ymbols",
    },
    {
      "<leader>fw",
      function()
        Snacks.picker.lsp_workspace_symbols({
          title = "Workspace Symbols",
          layout = { preset = "telescope_horizontal" },
          toggles = {
            all_symbols = "a",
          },
          actions = {
            toggle_all_symbols_ = function(picker)
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
                ["<M-a>"] = { "toggle_all_symbols_", mode = { "n", "i" } },
              },
            },
          },
        })
      end,
      desc = "[F]ind: [W]orkspace symbols",
    },
    {
      "<leader>fu",
      function()
        Snacks.picker.undo({
          title = "Undo Tree",
          layout = { preset = "telescope_horizontal" },
          sort = { fields = { "score:desc", "idx" } }, -- Don't sort by item length to preserve recency order
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
        Snacks.picker.marks({
          transform = function(item)
            return not vim.tbl_contains({
              "0",
              "1",
              "2",
              "3",
              "4",
              "5",
              "6",
              "7",
              "8",
              "9",
              "'",
              '"',
              ".",
              "]",
              "[",
              "<",
              ">",
              "^",
            }, item.label)
          end,
        })
      end,
      desc = "[F]ind: [M]arks",
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
        local cwd = vim.fn.getcwd()
        local git_root = Snacks.git.get_root(cwd)
        Snacks.picker.git_status({
          title = "Git Files",
          layout = { preset = "telescope_horizontal" },
          show_empty = true, -- Some stuff can appear after using toggles
          only_cwd = vim.bo.filetype ~= "oil",
          directory = vim.bo.filetype == "oil",
          directory_path = vim.bo.filetype == "oil" and require("oil").get_current_dir() or nil,
          toggles = {
            only_cwd = "c",
            directory = "d",
            staged = "s",
            unstaged = "u",
            conflicts = "=",
          },
          transform = function(item, ctx)
            local opts = ctx.picker.opts or {}
            local buffer_path = vim.fn.fnamemodify(git_root .. "/" .. item.file, ":p")
            if opts.only_cwd then ---@diagnostic disable-line: undefined-field
              if not vim.startswith(buffer_path, cwd) then
                return false
              end
            end
            if opts.directory and opts.directory_path then ---@diagnostic disable-line: undefined-field
              if not vim.startswith(buffer_path, opts.directory_path) then ---@diagnostic disable-line: undefined-field
                return false
              end
            end
            local status_filters = {}
            if opts.staged then ---@diagnostic disable-line: undefined-field
              vim.list_extend(status_filters, { "M ", "MM", "A ", "AM", "D ", "R " })
            end
            if opts.unstaged then ---@diagnostic disable-line: undefined-field
              vim.list_extend(status_filters, { " M", " D", "MM", "AM", "RM", "??" })
            end
            if opts.conflicts then ---@diagnostic disable-line: undefined-field
              vim.list_extend(status_filters, { "UU", "UD", "DU", "AA" })
            end
            if not vim.tbl_isempty(status_filters) and not vim.tbl_contains(status_filters, item.status) then
              return false
            end
            return true
          end,
          actions = {
            toggle_only_cwd_ = function(picker)
              local opts = picker.opts or {}
              opts.only_cwd = not opts.only_cwd ---@diagnostic disable-line: inject-field
              opts.directory = false ---@diagnostic disable-line: inject-field
              picker:find()
            end,
            toggle_directory_ = function(picker)
              local opts = picker.opts or {}
              opts.directory = not opts.directory ---@diagnostic disable-line: inject-field
              opts.only_cwd = false ---@diagnostic disable-line: inject-field
              picker:find()
            end,
            toggle_staged_ = function(picker)
              local opts = picker.opts or {}
              opts.staged = not opts.staged ---@diagnostic disable-line: inject-field
              opts.unstaged = false ---@diagnostic disable-line: inject-field
              opts.conflicts = false ---@diagnostic disable-line: inject-field
              picker:find()
            end,
            toggle_unstaged_ = function(picker)
              local opts = picker.opts or {}
              opts.staged = false ---@diagnostic disable-line: inject-field
              opts.unstaged = not opts.unstaged ---@diagnostic disable-line: inject-field
              opts.conflicts = false ---@diagnostic disable-line: inject-field
              picker:find()
            end,
            toggle_conflicts_ = function(picker)
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
                ["<Tab>"] = { "list_down", mode = { "n", "i" } }, -- Don't remap to `git_stage`
                ["<C-r>"] = false, -- Don't remap to `git_restore`
                ["<C-t>"] = { "git_stage", mode = { "n", "i" } }, -- Like `toggle stage`
                ["<C-x>"] = { "git_restore", mode = { "n", "i" }, nowait = true },
                ["<M-c>"] = { "toggle_only_cwd_", mode = { "n", "i" } },
                ["<M-d>"] = { "toggle_directory_", mode = { "n", "i" } },
                ["<M-s>"] = { "toggle_staged_", mode = { "n", "i" } },
                ["<M-u>"] = { "toggle_unstaged_", mode = { "n", "i" } },
                ["<M-=>"] = { "toggle_conflicts_", mode = { "n", "i" } },
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
          toggles = {
            current_file = "c", -- "f" is used for "follow rename"
            current_line = "l",
          },
          actions = {
            yank_commit = { action = "yank", field = "commit" },
            toggle_current_file_ = function(picker)
              local opts = picker.opts or {}
              opts.current_file = not opts.current_file ---@diagnostic disable-line: inject-field
              opts.current_line = false ---@diagnostic disable-line: inject-field
              opts.follow = opts.current_file ---@diagnostic disable-line: inject-field
              picker:find()
            end,
            toggle_current_line_ = function(picker)
              local opts = picker.opts or {}
              opts.current_file = false ---@diagnostic disable-line: inject-field
              opts.current_line = not opts.current_line ---@diagnostic disable-line: inject-field
              opts.follow = opts.current_file ---@diagnostic disable-line: inject-field
              picker:find()
            end,
          },
          win = {
            input = {
              keys = {
                ["<C-y>"] = { "yank_commit", mode = { "n", "i" } }, ---@diagnostic disable-line: assign-type-mismatch
                ["<M-c>"] = { "toggle_current_file_", mode = { "n", "i" } },
                ["<M-l>"] = { "toggle_current_line_", mode = { "n", "i" } },
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
      function()
        local cwd = vim.fn.getcwd()
        Snacks.picker.scratch({
          layout = { preset = "telescope_horizontal" },
          show_empty = true, -- Some stuff can appear after using toggles
          only_cwd = true,
          sort = { fields = { "score:desc", "idx" } }, -- Don't sort by item length to preserve recency order
          toggles = {
            only_cwd = "c",
          },
          transform = function(item, ctx)
            local opts = ctx.picker.opts or {}
            if opts.only_cwd then ---@diagnostic disable-line: undefined-field
              if item.item.cwd ~= cwd then
                return false
              end
            end
            return true
          end,
          actions = {
            scratch_delete_ = function(picker, item)
              if vim.fn.confirm("Do you want to delete the scratch file definitely?", "&Yes\n&No") == 1 then
                local current = item.file
                os.remove(current) ---@diagnostic disable-line: param-type-mismatch
                os.remove(current .. ".meta")
                picker:refresh()
              end
            end,
          },
          win = {
            input = {
              keys = {
                ["<C-n>"] = { "list_down", mode = { "n", "i" } }, -- Don't remap to new scratch
                ["<C-x>"] = { "scratch_delete_", mode = { "n", "i" } },
                ["<M-c>"] = { "toggle_only_cwd", mode = { "n", "i" } },
              },
            },
          },
        })
      end,
      desc = "[S]cratch: pick files",
    },
    {
      "<leader>sc",
      function()
        local default_ft = vim.bo.buftype == "" and vim.bo.filetype or nil
        vim.ui.input({ prompt = "Filetype", default = default_ft }, function(ft)
          if ft == nil or ft == "" then
            return
          end
          local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:~")
          local existing_scratch_names = {}
          for _, scratch_file in ipairs(Snacks.scratch.list()) do
            if scratch_file.ft == ft and scratch_file.cwd and vim.fn.fnamemodify(scratch_file.cwd, ":p:~") == cwd then
              table.insert(existing_scratch_names, scratch_file.name)
            end
          end
          local default_base_name = ft:sub(1, 1):upper() .. ft:sub(2) .. " scratch"
          local default_name, count = nil, 1
          while default_name == nil or vim.tbl_contains(existing_scratch_names, default_name) do
            default_name = default_base_name .. " " .. count
            count = count + 1
          end
          vim.ui.input({ prompt = "Name", default = default_name }, function(name)
            if name == nil or name == "" then
              return
            end
            Snacks.scratch.open({ ft = ft, name = name })
          end)
        end)
      end,
      desc = "[S]cratch: [C]reate",
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
        { icon = " ", key = "f", desc = "Find [F]iles", action = "<leader>ff" },
        { icon = " ", key = "r", desc = "Find [R]ecent Files", action = "<leader>fr" },
        { icon = "󰚰 ", key = "g", desc = "Find [G]it Files", action = "<leader>gg" },
        { icon = " ", key = "d", desc = "Find [D]irectories", action = "<leader>fd" },
        { icon = "󰊢 ", key = "m", desc = "Open Git [M]enu", action = "<leader>gm" },
        { icon = "󱞁 ", key = "n", desc = "Open [N]ote", action = "<leader>sn" },
        { icon = " ", key = "q", desc = "[Q]uit", action = ":qa" },
      },
    },

    input = {
      enabled = true,
      win = {
        keys = {
          ["<C-n>"] = { "hist_down", mode = { "n", "i" } },
          ["<C-p>"] = { "hist_up", mode = { "n", "i" } },
        },
      },
    },

    notifier = { enabled = true },

    picker = {
      enabled = true, -- Use Snacks picker for vim.ui.select
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
            local dirs = opts.dirs or {}
            local cwd = #dirs == 0 and vim.fs.normalize(opts.cwd or vim.uv.cwd() or ".") or nil
            if #dirs > 0 then
              dirs = vim.tbl_map(vim.fs.normalize, dirs)
              args[#args + 1] = "."
              vim.list_extend(args, dirs)
            end
            opts.args = args
            opts.transform = function(item)
              item.cwd = cwd
              item.file = item.text
              item.dir = true
            end
            return require("snacks.picker.source.proc").proc(opts, ctx)
          end,
        },
      },
      actions = {
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
            ["<Tab>"] = { "list_down", mode = { "n", "i" } },
            ["<S-Tab>"] = { "list_up", mode = { "n", "i" } },
            ["<C-c>"] = { "cancel", mode = { "n", "i" } },
            ["<C-s>"] = { "select_and_next", mode = { "n", "i" } },
            ["<C-g>"] = { "list_top", mode = { "n", "i" } }, -- Mnemonic: like `gg`
            ["<C-q>"] = { "qflist_trouble", mode = { "n", "i" } },
            ["<C-l>"] = { "loclist_trouble", mode = { "n", "i" } },
            ["<C-j>"] = { "preview_scroll_down", mode = { "n", "i" } },
            ["<C-k>"] = { "preview_scroll_up", mode = { "n", "i" } },
            ["<M-n>"] = { "history_forward", mode = { "n", "i" } },
            ["<M-p>"] = { "history_back", mode = { "n", "i" } },
            ["<M-v>"] = { "toggle_preview", mode = { "n", "i" } },
            ["<M-h>"] = { "toggle_hidden", mode = { "n", "i" } },
            ["<M-i>"] = { "toggle_ignored", mode = { "n", "i" } },
            ["<M-r>"] = { "toggle_regex", mode = { "n", "i" } },
            ["<C-v>"] = false,
            ["<C-t>"] = false,
            -- Make sure insert-mode keymaps are not overridden
            ["<C-f>"] = false,
            ["<C-b>"] = false,
            ["<M-f>"] = false,
            ["<M-b>"] = false,
            ["<C-e>"] = false,
            ["<C-a>"] = false,
            ["<C-w>"] = false,
            ["<C-u>"] = { "list_scroll_up", mode = "n" },
            ["<C-d>"] = { "list_scroll_down", mode = "n" }, -- Out of consistency with <C-u>
          },
        },
      },
    },

    quickfile = { enabled = true },

    scratch = {
      autowrite = false, -- When `true`, write files even if empty and automatically set `buflisted` to false
      -- Don't use nvim user data to avoid losing the scratch files on full nvim cleaning
      root = vim.env.HOME .. "/.local/scratch-files",
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
                vim.fn.delete(fname .. ".meta")
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
          ["<C-c>"] = { "<C-c>", function() vim.cmd([[close]]) end, desc = "Quit" },
          ["q"] = false, -- To make possible the use of macros
          ["source"] = false,
        },
      },
    },

    scroll = { enabled = true },

    words = { enabled = true },

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
      scratch = {
        width = 120,
        height = 40,
        bo = { buflisted = true }, -- To appear in buffer switcher
      },
    },
  },
}
