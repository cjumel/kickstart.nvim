return {
  "folke/snacks.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = false,
  priority = 500, -- Main UI stuff should be loaded first (but after the colorscheme)
  keys = {
    -- Bufdelete
    {
      "<leader>bb",
      function() Snacks.bufdelete.delete() end,
      desc = "[B]uffer: [B]ufdelete",
    },
    {
      "<leader>ba",
      function()
        Snacks.bufdelete.all()
        Snacks.dashboard()
      end,
      desc = "[B]uffer: bufdelete [A]ll",
    },
    {
      "<leader>bo",
      function() Snacks.bufdelete.other() end,
      desc = "[B]uffer: bufdelete [O]thers",
    },
    {
      "<leader>bd",
      function()
        if vim.fn.confirm("Do you want to delete the file definitely?", "&Yes\n&No") == 1 then
          local fname = vim.api.nvim_buf_get_name(0)
          Snacks.bufdelete.delete() -- Delete the buffer
          vim.fn.delete(fname) -- Delete the file
        end
      end,
      desc = "[B]uffer: [D]elete file",
    },

    -- Gitbrowse
    { "<leader>gr", function() Snacks.gitbrowse.open() end, desc = "[G]it: open [R]epository" },

    -- Notifier
    { "<leader>?", function() Snacks.notifier.show_history() end, desc = "Notification history" },

    -- Picker
    { "<leader>,", function() Snacks.picker.resume() end, desc = "Resume picker" },
    {
      "<leader><Tab>",
      function()
        Snacks.picker.buffers({
          title = "Buffer Switcher",
          current = false,
          sort = { fields = { "score:desc", "idx" } }, -- Don't sort by item length to preserve recency order
          layout = { preset = "telescope_dropdown" },
          win = {
            input = {
              keys = {
                ["<C-y>"] = { { "yank_path", "close" }, mode = "i" },
                ["<C-d>"] = { "bufdelete", mode = { "i" } },
              },
            },
          },
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
    { "<leader>=", function() Snacks.picker.lines() end, desc = "Search lines" },
    {
      "<leader>ff",
      function()
        Snacks.picker.files({
          title = "Files",
          layout = { preset = "telescope_horizontal" },
          show_empty = true, -- In case everything is hidden or ignored
          cwd = vim.bo.filetype == "oil" and require("oil").get_current_dir() or nil,
          win = {
            input = {
              keys = {
                ["<C-y>"] = { { "yank_path", "close" }, mode = "i" }, ---@diagnostic disable-line: assign-type-mismatch
              },
            },
          },
          _oil_cwd = require("oil").get_current_dir(),
        })
      end,
      desc = "[F]ind: [F]iles",
    },
    {
      "<leader>fr",
      function()
        Snacks.picker.recent({
          title = "Recent Files",
          filter = { cwd = true },
          sort = { fields = { "score:desc", "idx" } }, -- Don't sort by item length to preserve history order
          layout = { preset = "telescope_horizontal" },
          win = {
            input = {
              keys = {
                ["<C-y>"] = { { "yank_path", "close" }, mode = "i" }, ---@diagnostic disable-line: assign-type-mismatch
              },
            },
          },
        })
      end,
      desc = "[F]ind: [R]ecent files",
    },
    {
      "<leader>fR",
      function()
        Snacks.picker.recent({
          title = "All Recent Files",
          sort = { fields = { "score:desc", "idx" } }, -- Don't sort by item length to preserve history order
          layout = { preset = "telescope_horizontal" },
          win = {
            input = {
              keys = {
                ---@diagnostic disable-next-line: assign-type-mismatch
                ["<C-y>"] = { { "yank_path", "close" }, mode = "i" },
              },
            },
          },
        })
      end,
      desc = "[F]ind: [R]ecent files (all)",
    },
    {
      "<leader>fd",
      function()
        Snacks.picker.pick("directories", {
          title = "Directories",
          layout = { preset = "telescope_horizontal" },
          show_empty = true, -- In case everything is hidden or ignored
          cwd = vim.bo.filetype == "oil" and require("oil").get_current_dir() or nil,
          win = {
            input = {
              keys = {
                ---@diagnostic disable-next-line: assign-type-mismatch
                ["<C-y>"] = { { "yank_path", "close" }, mode = "i" },
              },
            },
          },
          _oil_cwd = require("oil").get_current_dir(),
        })
      end,
      desc = "[F]ind: [D]irectories",
    },
    {
      "<leader>fg",
      function()
        Snacks.picker.grep({
          title = "Grep",
          layout = { preset = "telescope_vertical" },
          cwd = vim.bo.filetype == "oil" and require("oil").get_current_dir() or nil,
          _oil_cwd = require("oil").get_current_dir(),
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
          show_empty = true, -- In case everything is hidden or ignored
          cwd = vim.bo.filetype == "oil" and require("oil").get_current_dir() or nil,
          _oil_cwd = require("oil").get_current_dir(),
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
        })
      end,
      desc = "[F]ind: [S]ymbols",
    },
    {
      "<leader>fS",
      function()
        Snacks.picker.lsp_workspace_symbols({
          title = "Workspace Symbols",
          layout = { preset = "telescope_horizontal" },
        })
      end,
      desc = "[F]ind: [S]ymbols (workspace) ",
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
                ["<C-y>"] = { { "yank_add", "close" }, mode = "i" },
                ["Ú"] = { { "yank_del", "close" }, mode = "i" }, -- <M-y>
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
          win = {
            input = {
              keys = {
                ---@diagnostic disable-next-line: assign-type-mismatch
                ["<C-y>"] = { { "yank_commit", "close" }, mode = "i" },
              },
            },
          },
        })
      end,
      desc = "[G]it: [L]og",
    },
    {
      "<leader>gL",
      function()
        Snacks.picker.git_log_file({
          title = "Buffer Commits",
          layout = { preset = "telescope_horizontal" },
          win = {
            input = {
              keys = {
                ---@diagnostic disable-next-line: assign-type-mismatch
                ["<C-y>"] = { { "yank_commit", "close" }, mode = "i" },
              },
            },
          },
        })
      end,
      desc = "[G]it: [L]og (buffer)",
    },

    -- Scratch buffers
    {
      "<leader>ss",
      function() -- Based on Snacks.scratch.select, restricted to the current working directory
        local items = Snacks.scratch.list()
        local selection_items = {}
        local widths = { 0, 0, 0 }
        local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:~")
        for _, item in ipairs(items) do
          if vim.fn.fnamemodify(item.cwd, ":p:~") == cwd then
            item.icon = item.icon or Snacks.util.icon(item.ft, "filetype")
            item.name = item.count > 1 and item.name .. " " .. item.count or item.name
            item.branch = item.branch and ("   %s"):format(item.branch) or ""
            widths[1] = math.max(widths[1], vim.api.nvim_strwidth(item.icon))
            widths[2] = math.max(widths[2], vim.api.nvim_strwidth(item.name))
            widths[3] = math.max(widths[3], vim.api.nvim_strwidth(item.branch))
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
            local parts = { item.icon, item.name, item.branch }
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
        local widths = { 0, 0, 0, 0 }
        for _, item in ipairs(items) do
          item.cwd = vim.fn.fnamemodify(item.cwd, ":p:~") .. "  "
          item.icon = item.icon or Snacks.util.icon(item.ft, "filetype")
          item.name = item.count > 1 and item.name .. " " .. item.count or item.name
          item.branch = item.branch and ("   %s"):format(item.branch) or ""
          widths[1] = math.max(widths[1], vim.api.nvim_strwidth(item.cwd))
          widths[2] = math.max(widths[2], vim.api.nvim_strwidth(item.icon))
          widths[3] = math.max(widths[3], vim.api.nvim_strwidth(item.name))
          widths[4] = math.max(widths[4], vim.api.nvim_strwidth(item.branch))
          table.insert(selection_items, item)
        end
        if vim.tbl_isempty(items) then
          vim.notify("No scratch file found", vim.log.levels.WARN)
          return
        end
        vim.ui.select(selection_items, {
          prompt = "All scratch files",
          format_item = function(item)
            local parts = { item.cwd, item.icon, item.name, item.branch }
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
      "<leader>so",
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
      desc = "[S]cratch: [O]pen",
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
      desc = "[S]cratch: open with [F]iletype",
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
        { icon = "󰚰 ", key = "g", desc = "[G]it Status", action = "<leader>gg" },
        { icon = " ", key = "b", desc = "Git [B]ranch", action = "<leader>gb" },
        { icon = " ", key = "l", desc = "Git [L]og", action = "<leader>gl" },
        { icon = "󰊢 ", key = "m", desc = "Git [M]enu", action = "<leader>gm" },
        { icon = "󰚸 ", key = "s", desc = "Select [S]cratch File", action = "<leader>ss" },
        { icon = "󱞁 ", key = "n", desc = "Open Scratch [N]ote", action = "<leader>sn" },
        { icon = " ", key = "q", desc = "[Q]uit", action = ":qa" },
      },
    },

    input = {
      enabled = true,
      win = {
        keys = {
          i_ctrl_n = { "<C-\\>", "hist_down", mode = "i" }, -- <C-`>, like in command-line mode
          i_ctrl_p = { "<C-]>", "hist_up", mode = "i" }, -- <C-$>, like in command-line mode
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
        yank_path = { action = "yank", field = "path", reg = '"' },
        yank_commit = { action = "yank", field = "commit", reg = '"' },
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
            ["<CR>"] = { "confirm", mode = "i" },
            ["<C-CR>"] = { "select_and_next", mode = "i" },
            ["<C-BS>"] = { "select_and_prev", mode = "i" },
            ["<Tab>"] = { "list_down", mode = "i" },
            ["<S-Tab>"] = { "list_up", mode = "i" },
            ["<C-n>"] = { "list_down", mode = "i" },
            ["<C-p>"] = { "list_up", mode = "i" },
            ["<C-g>"] = { "list_top", mode = "i" }, -- Like the `gg` keymap
            ["<C-s>"] = { "edit_split", mode = "i" },
            ["<C-v>"] = { "edit_vsplit", mode = "i" },
            ["<C-t>"] = { "tab", mode = "i" },
            ["<C-q>"] = { "qflist_trouble", mode = "i" },
            ["<C-l>"] = { "loclist_trouble", mode = "i" },
            ["<C-j>"] = { "preview_scroll_down", mode = "i" },
            ["<C-k>"] = { "preview_scroll_up", mode = "i" },
            ["<Esc>"] = { "cancel", mode = "i" },
            ["π"] = { "toggle_preview", mode = "i" }, -- <M-p>
            ["Ì"] = { "toggle_hidden", mode = "i" }, -- <M-h>
            ["î"] = { "toggle_ignored", mode = "i" }, -- <M-i>
            ["<C-a>"] = false,
            ["<C-e>"] = false,
            ["<C-b>"] = false,
            ["<C-f>"] = false,
            ["<C-u>"] = false,
          },
        },
      },
    },

    quickfile = { enabled = true },

    scratch = {
      -- Don't use nvim user data to avoid losing the scratch files on full nvim cleaning
      root = vim.env.HOME .. "/.local/share/scratch-files",
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
            desc = "delete",
          },
          ["expand"] = {
            "<localleader>e",
            function(self)
              vim.cmd([[close]])
              vim.api.nvim_set_current_buf(self.buf)
            end,
            desc = "expand",
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
      notification_history = { wo = { number = false, relativenumber = false, signcolumn = "yes" } },
    },
  },
  config = function(_, opts)
    Snacks.setup(opts)

    -- Simplify some picker highlights
    vim.api.nvim_set_hl(0, "SnacksPickerDir", { link = "SnacksPickerFile" }) -- For all file pickers
    vim.api.nvim_set_hl(0, "SnacksPickerDirectory", { link = "SnacksPickerFile" }) -- For the directory picker
  end,
}
