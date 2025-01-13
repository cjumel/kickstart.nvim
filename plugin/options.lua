-- [[ Options ]]

-- Global UI
vim.o.mouse = "a" -- Enable mouse mode in all modes
vim.o.breakindent = true -- After a line wrap, indent the part on the new virtual line
vim.o.splitright = true -- Open new vertical split window on the right
vim.o.splitbelow = true -- Open new horizontal split window below
vim.opt.cursorline = true -- Highlight the cursor line
vim.o.matchpairs = vim.o.matchpairs .. ",<:>" -- Add recognized character pair

-- Side column
vim.wo.number = true -- Enable absolute line numbering
vim.wo.signcolumn = "number" -- Add signs in the number column

-- Search & replace
vim.o.ignorecase = true -- Make search case-insensitive by default
vim.o.smartcase = true -- Enable case-sensitive searching when "\C" or capital in search
vim.o.hlsearch = true -- Highlight matches during search
vim.opt.inccommand = "split" -- Preview modifications in split during incremental commands

-- Folding

-- Custom fold text function with Treesitter syntax highlighting and fold ending, taken from
-- https://www.reddit.com/r/neovim/comments/1fzn1zt/custom_fold_text_function_with_treesitter_syntax/
local function fold_virt_text(result, s, lnum, coloff)
  if not coloff then
    coloff = 0
  end
  local text = ""
  local hl
  for i = 1, #s do
    local char = s:sub(i, i)
    local hls = vim.treesitter.get_captures_at_pos(0, lnum, coloff + i - 1)
    local _hl = hls[#hls]
    if _hl then
      local new_hl = "@" .. _hl.capture
      if new_hl ~= hl then
        table.insert(result, { text, hl })
        text = ""
        hl = nil
      end
      text = text .. char
      hl = new_hl
    else
      text = text .. char
    end
  end
  table.insert(result, { text, hl })
end
function _G.custom_foldtext()
  local start = vim.fn.getline(vim.v.foldstart):gsub("\t", string.rep(" ", vim.o.tabstop))
  local end_str = vim.fn.getline(vim.v.foldend)
  local end_ = vim.trim(end_str)
  local result = {}
  fold_virt_text(result, start, vim.v.foldstart - 1)
  table.insert(result, { " ... ", "Delimiter" })
  fold_virt_text(result, end_, vim.v.foldend - 1, #(end_str:match("^(%s+)") or ""))
  return result
end

vim.opt.foldmethod = "expr" -- Define folding method with `foldexpr`
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- Use Treesitter-based folding
vim.opt.foldlevelstart = 99 -- Open buffers with no fold closed
vim.opt.fillchars = { fold = " " } -- Remove dots filling at the end of folded lines
vim.opt.foldtext = "v:lua.custom_foldtext()" -- Custom folded line text

-- Disable builtin auto-completion
vim.o.complete = ""
vim.o.completeopt = ""

-- Internals
vim.o.undofile = true -- Save undo history to file
vim.o.updatetime = 250 -- Decrease delay for writting swap files
vim.o.timeoutlen = 300 -- Decrease delay between keys in mapped sequences

-- [[ Diagnostics ]]

-- Diagnostics configuration
vim.diagnostic.config({
  float = { border = "rounded" }, -- Better for transparent backgrounds
  severity_sort = true, -- Display most severe diagnostic in sign column
})

-- Use symbols taken from lualine/components/diagnostics/config.lua in sign column
for type, icon in pairs({ Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = "󰋽 " }) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- [[ Filetypes ]]

-- Add custom filetypes to those known by Neovim
vim.filetype.add({
  filename = {
    [".env.example"] = "sh", -- same as `.env`
    [".env.sample"] = "sh", -- same as `.env`
    [".env.test"] = "sh", -- same as `.env`
    [".env.test.example"] = "sh", -- same as `.env`
    [".ideavimrc"] = "vim",
    [".markdownlintrc"] = "json", -- could also be "ini"
    [".prettierignore"] = "conf", -- auto-detected by nvim
    [".shellcheckrc"] = "conf", -- auto-detected by nvim
    [".stow-global-ignore"] = "conf", -- auto-detected by nvim
    [".stow-local-ignore"] = "conf", -- auto-detected by nvim
    [".vimiumrc"] = "vim",
    ["ignore"] = "conf", -- auto-detected by nvim
    ["ripgreprc"] = "conf", -- auto-detected by nvim
  },
})
