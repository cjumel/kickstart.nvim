-- snacks.nvim
--
-- Meta plugin providing a collection of small quality-of-life plugins (and more) for Neovim. All these plugigns work
-- very nicely out-of-the-box, with great default behaviors, and bring many UI improvements as well as new cool atomic
-- features.

return {
  "folke/snacks.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = false,
  priority = 500, -- Main UI stuff should be loaded first (but after the colorscheme)
  keys = {
    -- Bufdelete
    { "<leader><BS>", function() Snacks.bufdelete.delete() end, desc = "Delete current buffer" },
    {
      "<leader><S-BS>",
      function()
        Snacks.bufdelete.all()
        Snacks.dashboard()
      end,
      desc = "Delete all buffers and open dashboard",
    },
    { "<leader><M-BS>", function() Snacks.bufdelete.other() end, desc = "Delete other buffers" },
    {
      "<leader><C-BS>",
      function()
        if vim.fn.confirm("Do you want to delete the file definitely?", "&Yes\n&No") == 1 then
          local fname = vim.api.nvim_buf_get_name(0)
          Snacks.bufdelete.delete() -- Delete the buffer
          vim.fn.delete(fname) -- Delete the file
        end
      end,
      desc = "Delete current file",
    },

    -- Gitbrowse
    { "<leader>gr", function() Snacks.gitbrowse.open() end, desc = "[G]it: open [R]epository" },

    -- Picker
    { "<leader>;", function() Snacks.picker.resume() end, desc = "Resume picker" },
    {
      "<leader><Tab>",
      function()
        Snacks.picker.buffers({
          title = "Buffer Switcher",
          format = "file",
          current = false,
          layout = { preset = "telescope_dropdown" },
          win = { input = { keys = { ["<c-d>"] = { "bufdelete", mode = { "i" } } } } },
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
      "<leader>/",
      function()
        Snacks.picker.search_history({
          sort = { fields = { "score:desc", "idx" } }, -- Don't sort by item length to preserve history order
          layout = { preset = "telescope_dropdown" },
        })
      end,
      desc = "Search history",
    },
    { "<leader>=", function() Snacks.picker.lines() end, desc = "Pick lines" },
    {
      "<leader>ff",
      function()
        local opts = {
          title = "Files",
          layout = { preset = "telescope_horizontal" },
          show_empty = true, -- In case everything is hidden or ignored
        }
        if vim.bo.filetype == "oil" then
          local dir = vim.fn.fnamemodify(require("oil").get_current_dir() --[[@as string]], ":p:~:.")
          opts.title = opts.title .. " in " .. (dir ~= "" and dir or "./")
          opts.cwd = dir
        end
        Snacks.picker.files(opts)
      end,
      desc = "[F]ind: [F]iles",
    },
    {
      "<leader>fo",
      function()
        Snacks.picker.recent({
          title = "Old Files",
          filter = { cwd = true },
          sort = { fields = { "score:desc", "idx" } }, -- Don't sort by item length to preserve history order
          layout = { preset = "telescope_horizontal" },
          show_empty = true, -- In case there's no recent file in the cwd, but we want them from every where
          win = {
            input = {
              keys = {
                ["©"] = { "toggle_cwd", mode = "i", desc = "Toggle cwd" },
              },
            },
          },
        })
      end,
      desc = "[F]ind: [O]ld files",
    },
    {
      "<leader>fd",
      function()
        local opts = {
          title = "Directories",
          layout = { preset = "telescope_horizontal" },
          show_empty = true, -- In case everything is hidden or ignored
        }
        if vim.bo.filetype == "oil" then
          local dir = vim.fn.fnamemodify(require("oil").get_current_dir() --[[@as string]], ":p:~:.")
          opts.title = opts.title .. " in " .. (dir ~= "" and dir or "./")
          opts.cwd = dir
        end
        Snacks.picker.pick("directories", opts)
      end,
      desc = "[F]ind: [D]irectories",
    },
    {
      "<leader>fg",
      function()
        local opts = { title = "Grep", layout = { preset = "telescope_vertical" } }
        if vim.bo.filetype == "oil" then
          local dir = vim.fn.fnamemodify(require("oil").get_current_dir() --[[@as string]], ":p:~:.")
          opts.title = opts.title .. " in " .. (dir ~= "" and dir or "./")
          opts.cwd = dir
        end
        Snacks.picker.grep(opts)
      end,
      desc = "[F]ind: [G]rep",
    },
    {
      "<leader>fg",
      function()
        local opts = { title = "Grep", layout = { preset = "telescope_vertical" } }
        if vim.bo.filetype == "oil" then
          local dir = vim.fn.fnamemodify(require("oil").get_current_dir() --[[@as string]], ":p:~:.")
          opts.title = opts.title .. " in " .. (dir ~= "" and dir or "./")
          opts.cwd = dir
        end
        Snacks.picker.grep_word(opts)
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
          win = {
            input = {
              keys = {
                ["<C-y>"] = { { "yank_add", "close" }, mode = "i" }, -- Add close action
                ["Ú"] = { { "yank_del", "close" }, mode = "i" }, -- <M-y> (instead of <C-S-y>), add close action
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
      "<leader>fc",
      function() Snacks.picker.commands({ layout = { preset = "telescope_horizontal", preview = false } }) end,
      desc = "[F]ind: [C]ommands",
    },
    {
      "<leader>fk",
      function() Snacks.picker.keymaps({ layout = { preset = "telescope_horizontal", preview = false } }) end,
      desc = "[F]ind: [K]eymaps",
    },
    {
      "<leader>gg",
      function()
        Snacks.picker.git_status({
          layout = { preset = "telescope_horizontal" },
          win = {
            input = {
              keys = {
                ["<Tab>"] = { "list_down", mode = "i" }, -- Previously mapped to "git_stage"
                ["Ò"] = { { "git_stage", "list_down" }, mode = "i" }, -- <M-s>
              },
            },
          },
        })
      end,
      desc = "[G]it: status",
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
          layout = { preset = "telescope_horizontal" },
          ---@diagnostic disable-next-line: assign-type-mismatch
          win = { input = { keys = { ["<C-y>"] = { { "yank_commit", "close" }, mode = "i" } } } },
        })
      end,
      desc = "[G]it: [L]og",
    },
    {
      "<leader>gL",
      function()
        Snacks.picker.git_log_file({
          layout = { preset = "telescope_horizontal" },
          ---@diagnostic disable-next-line: assign-type-mismatch
          win = { input = { keys = { ["<C-y>"] = { { "yank_commit", "close" }, mode = "i" } } } },
        })
      end,
      desc = "[G]it: document [L]og",
    },

    -- Scratch buffers
    {
      "<leader>tt",
      function() -- Snacks.scratch.select re-implementation simplified & restricted to the current directory
        local widths = { 0, 0 }
        local items = Snacks.scratch.list()
        local selection_items = {}
        local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:~")
        for _, item in ipairs(items) do
          if item.cwd and vim.fn.fnamemodify(item.cwd, ":p:~") == cwd then
            item.icon = item.icon or Snacks.util.icon(item.ft, "filetype")
            item.name = item.count > 1 and item.name .. " " .. item.count or item.name
            widths[1] = math.max(widths[1], vim.api.nvim_strwidth(item.icon))
            widths[2] = math.max(widths[2], vim.api.nvim_strwidth(item.name))
            table.insert(selection_items, item)
          end
        end
        vim.ui.select(selection_items, {
          prompt = "Temp files",
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
      desc = "[T]emp files: select",
    },
    {
      "<leader>ta",
      function() -- Snacks.scratch.select re-implementation simplified
        local widths = { 0, 0, 0 }
        local items = Snacks.scratch.list()
        for _, item in ipairs(items) do
          item.icon = item.icon or Snacks.util.icon(item.ft, "filetype")
          item.cwd = item.cwd and vim.fn.fnamemodify(item.cwd, ":p:~") or ""
          item.name = item.count > 1 and item.name .. " " .. item.count or item.name
          widths[1] = math.max(widths[1], vim.api.nvim_strwidth(item.cwd))
          widths[2] = math.max(widths[2], vim.api.nvim_strwidth(item.icon))
          widths[3] = math.max(widths[3], vim.api.nvim_strwidth(item.name))
        end
        vim.ui.select(items, {
          prompt = "Temp files (all)",
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
      desc = "[T]emp files: select [A]ll",
    },
    {
      "<leader>to",
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
            local default_base_name = filetype:sub(1, 1):upper() .. filetype:sub(2) .. " file"
            local count = 0
            local suffix = ""
            local default_name = default_base_name
            while vim.tbl_contains(item_names, default_name) do
              count = count + 1
              suffix = " " .. count
              default_name = default_base_name .. suffix
            end
            vim.ui.input({ prompt = "Name", default = default_name }, function(name)
              if name then
                Snacks.scratch.open({ ft = filetype, name = name })
              end
            end)
          end
        end)
      end,
      desc = "[T]emp files: [O]pen",
    },
    {
      "<leader>tf",
      function()
        local items = Snacks.scratch.list()
        local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:~")
        local item_names = {}
        for _, item in ipairs(items) do
          if item.ft == vim.bo.filetype and item.cwd and vim.fn.fnamemodify(item.cwd, ":p:~") == cwd then
            table.insert(item_names, item.name)
          end
        end
        local default_base_name = vim.bo.filetype:sub(1, 1):upper() .. vim.bo.filetype:sub(2) .. " file"
        local count = 0
        local suffix = ""
        local default_name = default_base_name
        while vim.tbl_contains(item_names, default_name) do
          count = count + 1
          suffix = " " .. count
          default_name = default_base_name .. suffix
        end
        vim.ui.input({ prompt = "Name", default = default_name }, function(name)
          if name then
            Snacks.scratch.open({ name = name })
          end
        end)
      end,
      desc = "[T]emp files: open with [F]iletype",
    },
    {
      "<leader>tn",
      function() Snacks.scratch.open({ ft = "markdown", name = "Note" }) end,
      desc = "[T]emp files: open [N]ote",
    },
    {
      "<leader>tl",
      function()
        local items = Snacks.scratch.list()
        local selected = items[1] -- Items are ordered with last opened first
        Snacks.scratch.open({ icon = selected.icon, file = selected.file, name = selected.name, ft = selected.ft })
      end,
      desc = "[T]emp files: open [L]ast",
    },
  },
  opts = {
    bigfile = { enabled = true },

    dashboard = {
      enabled = true,
      sections = {
        { section = "header" },
        { icon = " ", key = "c", desc = "Open [C]wd", action = function() require("oil").open() end },
        {
          icon = " ",
          key = "f",
          desc = "Find [F]iles",
          action = function()
            Snacks.picker.files({
              layout = { preset = "telescope_horizontal" },
              show_empty = true, -- In case everything is hidden or ignored
            })
          end,
        },
        {
          icon = " ",
          key = "o",
          desc = "Find [O]ld Files",
          action = function()
            Snacks.picker.recent({
              title = "Old Files",
              filter = { cwd = true },
              sort = { fields = { "score:desc", "idx" } }, -- Don't sort by item length to preserve history order
              layout = { preset = "telescope_horizontal" },
              show_empty = true, -- In case there's no recent file in the cwd, but we want them from every where
              win = {
                input = {
                  keys = {
                    ["©"] = { "toggle_cwd", mode = "i", desc = "Toggle cwd" },
                  },
                },
              },
            })
          end,
        },
        {
          icon = " ",
          key = "d",
          desc = "Find [D]irectories",
          action = function()
            Snacks.picker.pick("directories", {
              layout = { preset = "telescope_horizontal" },
              show_empty = true, -- In case everything is hidden or ignored
            })
          end,
        },
        {
          icon = "󰚰 ",
          key = "g",
          desc = "[G]it Status",
          action = function()
            Snacks.picker.git_status({
              layout = { preset = "telescope_horizontal" },
              win = {
                input = {
                  keys = {
                    ["<Tab>"] = { "list_down", mode = "i" }, -- Previously mapped to "git_stage"
                    ["Ò"] = { { "git_stage", "list_down" }, mode = "i" }, -- <M-s>
                  },
                },
              },
            })
          end,
        },
        {
          icon = " ",
          key = "b",
          desc = "Git [B]ranch",
          action = function() Snacks.picker.git_branches({ layout = { preset = "telescope_vertical" } }) end,
        },
        {
          icon = " ",
          key = "l",
          desc = "Git [L]og",
          action = function()
            Snacks.picker.git_log({
              layout = { preset = "telescope_horizontal" },
              ---@diagnostic disable-next-line: assign-type-mismatch
              win = { input = { keys = { ["<C-y>"] = { { "yank_commit", "close" }, mode = "i" } } } },
            })
          end,
        },
        { icon = "󰊢 ", key = "n", desc = "Open [N]eogit", action = function() require("neogit").open() end },
        { icon = " ", key = "q", desc = "[Q]uit", action = ":qa" },
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
      sources = {
        directories = {
          finder = function(opts, ctx)
            local cwd = opts.cwd or vim.fn.getcwd()
            local args = { "--type", "d", "--exclude", ".git" }
            if opts.hidden then
              table.insert(args, "--hidden")
            end
            if opts.ignored then
              table.insert(args, "--no-ignore")
            end
            local transform = function(item)
              item.file = vim.fn.fnamemodify(cwd .. "/" .. item.text, ":p")
              item.dir = true
            end
            return require("snacks.picker.source.proc").proc(
              { opts, { cmd = "fd", args = args, transform = transform } },
              ctx
            )
          end,
        },
      },
      formatters = { file = { truncate = 60 } }, -- Increase the displayed file path length
      actions = {
        toggle_cwd = function(picker)
          picker.opts["filter"]["cwd"] = not picker.opts["filter"]["cwd"]
          picker:find()
        end,
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
          vim.cmd("Trouble qflist toggle")
        end,
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
          vim.cmd("Trouble loclist toggle")
        end,
        yank_commit = { action = "yank", field = "commit", reg = "+" },
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
      win = {
        input = {
          keys = {
            ["<Tab>"] = { "list_down", mode = "i" },
            ["<S-Tab>"] = { "list_up", mode = "i" },
            ["<C-CR>"] = { "select_and_next", mode = "i" },
            ["<C-BS>"] = { "select_and_prev", mode = "i" },
            ["<C-g>"] = { "list_top", mode = "i" }, -- Like the `gg` keymap
            ["<C-q>"] = { "qflist_trouble", mode = "i" },
            ["<C-l>"] = { "loclist_trouble", mode = "i" },
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
      -- Don't use nvim user data to avoid deleting files on full re-install
      root = vim.env.HOME .. "/.local/share/scratch-files",
      filekey = { branch = false },
      win = {
        keys = {
          ["delete"] = {
            "<C-BS>",
            function(self)
              if vim.fn.confirm("Do you want to delete the scratch file definitely?", "&Yes\n&No") == 1 then
                local fname = vim.api.nvim_buf_get_name(self.buf)
                vim.cmd([[close]])
                vim.fn.delete(fname)
              end
            end,
            desc = "delete",
          },
          ["open"] = {
            "<C-CR>",
            function(self)
              vim.cmd([[close]])
              vim.api.nvim_set_current_buf(self.buf)
            end,
            desc = "open",
          },
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
          ["select_and_yank"] = {
            "<CR>",
            function()
              vim.cmd([[close]]) -- Close the notification history window, it hides the selection window
              vim.ui.select(Snacks.notifier.get_history({ reverse = true }), {
                prompt = "Notifications",
                format_item = function(item) return item.msg end,
              }, function(selected)
                if selected then
                  vim.fn.setreg('"', selected.msg)
                  vim.notify('Yanked to register `"`:\n```\n' .. selected.msg .. "\n```")
                end
              end)
            end,
          },
        },
      },
    },
  },
  config = function(_, opts)
    Snacks.setup(opts)

    -- Simplify some picker highlights
    vim.api.nvim_set_hl(0, "SnacksPickerDir", { link = "SnacksPickerFile" }) -- For all file pickers
    vim.api.nvim_set_hl(0, "SnacksPickerDirectory", { link = "SnacksPickerFile" }) -- For the directory picker
  end,
}
