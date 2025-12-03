-- HACK: for some reason, when opening a file which starts the biome LSP for the first time, biome's features are not
-- available until the buffer is reloaded or another file is opened
if not vim.g.biome_is_startup then
  vim.defer_fn(function() vim.cmd("edit") end, 1000)
  vim.g.biome_is_startup = true
end
