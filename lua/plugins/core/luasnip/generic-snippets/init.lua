-- Define generic snippets, not specific to a single file type, but used in several ones. Defining these snippets do
-- nothing on its own, the snippets need to be imported and returned in the file-type-specific snippets to be active.

return {
  todo_comments = require("plugins.core.luasnip.generic-snippets.todo-comments"),
}
