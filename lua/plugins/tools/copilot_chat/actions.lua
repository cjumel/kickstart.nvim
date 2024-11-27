local M = {}

function M.toggle() require("CopilotChat").toggle() end

function M.stop() require("CopilotChat").stop() end

function M.reset() require("CopilotChat").reset() end

function M.select_model() require("CopilotChat").select_model() end

function M.select_action()
  local actions = require("CopilotChat.actions")
  require("CopilotChat.actions").pick(actions.prompt_actions())
end

return M
