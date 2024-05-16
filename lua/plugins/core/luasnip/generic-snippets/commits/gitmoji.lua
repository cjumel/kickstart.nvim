local ls = require("luasnip")

local custom_conditions = require("plugins.core.luasnip.conditions")

local i = ls.insert_node
local c = ls.choice_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

local gitmojis_data = {
  { name = "art", emoji = "🎨" },
  { name = "zap", emoji = "⚡️" },
  { name = "fire", emoji = "🔥" },
  { name = "bug", emoji = "🐛" },
  { name = "ambulance", emoji = "🚑️" },
  { name = "sparkles", emoji = "✨" },
  { name = "memo", emoji = "📝" },
  { name = "rocket", emoji = "🚀" },
  { name = "lipstick", emoji = "💄" },
  { name = "tada", emoji = "🎉" },
  { name = "white_check_mark", emoji = "✅" },
  { name = "lock", emoji = "🔒️" },
  { name = "closed_lock_with_key", emoji = "🔐" },
  { name = "bookmark", emoji = "🔖" },
  { name = "rotating_light", emoji = "🚨" },
  { name = "construction", emoji = "🚧" },
  { name = "green_heart", emoji = "💚" },
  { name = "arrow_down", emoji = "⬇️" },
  { name = "arrow_up", emoji = "⬆️" },
  { name = "pushpin", emoji = "📌" },
  { name = "construction_worker", emoji = "👷" },
  { name = "chart_with_upwards_trend", emoji = "📈" },
  { name = "recycle", emoji = "♻️" },
  { name = "heavy_plus_sign", emoji = "➕" },
  { name = "heavy_minus_sign", emoji = "➖" },
  { name = "wrench", emoji = "🔧" },
  { name = "hammer", emoji = "🔨" },
  { name = "globe_with_meridians", emoji = "🌐" },
  { name = "pencil2", emoji = "✏️" },
  { name = "poop", emoji = "💩" },
  { name = "rewind", emoji = "⏪️" },
  { name = "twisted_rightwards_arrows", emoji = "🔀" },
  { name = "package", emoji = "📦️" },
  { name = "alien", emoji = "👽️" },
  { name = "truck", emoji = "🚚" },
  { name = "page_facing_up", emoji = "📄" },
  { name = "boom", emoji = "💥" },
  { name = "bento", emoji = "🍱" },
  { name = "wheelchair", emoji = "♿️" },
  { name = "bulb", emoji = "💡" },
  { name = "beers", emoji = "🍻" },
  { name = "speech_balloon", emoji = "💬" },
  { name = "card_file_box", emoji = "🗃️" },
  { name = "loud_sound", emoji = "🔊" },
  { name = "mute", emoji = "🔇" },
  { name = "busts_in_silhouette", emoji = "👥" },
  { name = "children_crossing", emoji = "🚸" },
  { name = "building_construction", emoji = "🏗️" },
  { name = "iphone", emoji = "📱" },
  { name = "clown_face", emoji = "🤡" },
  { name = "egg", emoji = "🥚" },
  { name = "see_no_evil", emoji = "🙈" },
  { name = "camera_flash", emoji = "📸" },
  { name = "alembic", emoji = "⚗️" },
  { name = "mag", emoji = "🔍️" },
  { name = "label", emoji = "🏷️" },
  { name = "seedling", emoji = "🌱" },
  { name = "triangular_flag_on_post", emoji = "🚩" },
  { name = "goal_net", emoji = "🥅" },
  { name = "dizzy", emoji = "💫" },
  { name = "wastebasket", emoji = "🗑️" },
  { name = "passport_control", emoji = "🛂" },
  { name = "adhesive_bandage", emoji = "🩹" },
  { name = "monocle_face", emoji = "🧐" },
  { name = "coffin", emoji = "⚰️" },
  { name = "test_tube", emoji = "🧪" },
  { name = "necktie", emoji = "👔" },
  { name = "stethoscope", emoji = "🩺" },
  { name = "bricks", emoji = "🧱" },
  { name = "technologist", emoji = "🧑‍💻" },
  { name = "money_with_wings", emoji = "💸" },
  { name = "thread", emoji = "🧵" },
  { name = "safety_vest", emoji = "🦺" },
}

local function make_snippet(gitmoji_data)
  local keyword = gitmoji_data.name
  local emoji = gitmoji_data.emoji

  return s({ trig = ":" .. keyword .. ": " .. emoji, show_condition = custom_conditions.line_begin }, {
    c(1, {
      sn(nil, { t(emoji .. " "), i(1) }),
      sn(nil, { t(emoji .. " ("), i(1), t("): ") }), -- With scope
    }),
  })
end

local snippets = {}
for _, gitmoji_data in ipairs(gitmojis_data) do
  table.insert(snippets, make_snippet(gitmoji_data))
end

return snippets
