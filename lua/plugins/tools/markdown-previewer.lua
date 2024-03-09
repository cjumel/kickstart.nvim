-- mardown-preview.nvim
--
-- Preview Markdown in your modern browser with synchronised scrolling and flexible configuration.

return {
  "iamcco/markdown-preview.nvim",
  build = function()
    vim.fn["mkdp#util#install"]()
  end,
  cmd = {
    "MarkdownPreview",
    "MarkdownPreviewStop",
    "MarkdownPreviewToggle",
  },
  -- Fix lazy loading
  -- See https://github.com/iamcco/markdown-preview.nvim/issues/585
  init = function()
    local function load_then_exec(cmd)
      return function()
        vim.cmd.delcommand(cmd)
        require("lazy").load({ plugins = { "markdown-preview.nvim" } })
        vim.api.nvim_exec_autocmds("BufEnter", {}) -- commands appear only after BufEnter
        vim.cmd(cmd)
      end
    end
    for _, cmd in pairs({ "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" }) do
      vim.api.nvim_create_user_command(cmd, load_then_exec(cmd), {})
    end
  end,
}
