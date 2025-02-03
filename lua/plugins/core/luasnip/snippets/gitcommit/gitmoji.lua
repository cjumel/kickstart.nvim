local conds = require("plugins.core.luasnip.conditions")
local ls = require("luasnip")

local i = ls.insert_node
local c = ls.choice_node
local r = ls.restore_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

-- Data is taken from https://gitmoji.dev/
local gitmojis_data = {
  { name = "art", emoji = "🎨", desc = "Improve structure / format of the code." },
  { name = "zap", emoji = "⚡️", desc = "Improve performance." },
  { name = "fire", emoji = "🔥", desc = "Remove code or files." },
  { name = "bug", emoji = "🐛", desc = "Fix a bug." },
  { name = "ambulance", emoji = "🚑️", desc = "Critical hotfix." },
  { name = "sparkles", emoji = "✨", desc = "Introduce new features." },
  { name = "memo", emoji = "📝", desc = "Add or update documentation." },
  { name = "rocket", emoji = "🚀", desc = "Deploy stuff." },
  { name = "lipstick", emoji = "💄", desc = "Add or update the UI and style files." },
  { name = "tada", emoji = "🎉", desc = "Begin a project." },
  { name = "white_check_mark", emoji = "✅", desc = "Add, update, or pass tests." },
  { name = "lock", emoji = "🔒️", desc = "Fix security or privacy issues." },
  { name = "closed_lock_with_key", emoji = "🔐", desc = "Add or update secrets." },
  { name = "bookmark", emoji = "🔖", desc = "Release / Version tags." },
  { name = "rotating_light", emoji = "🚨", desc = "Fix compiler / linter warnings." },
  { name = "construction", emoji = "🚧", desc = "Work in progress." },
  { name = "green_heart", emoji = "💚", desc = "Fix CI Build." },
  { name = "arrow_down", emoji = "⬇️", desc = "Downgrade dependencies." },
  { name = "arrow_up", emoji = "⬆️", desc = "Upgrade dependencies." },
  { name = "pushpin", emoji = "📌", desc = "Pin dependencies to specific versions." },
  { name = "construction_worker", emoji = "👷", desc = "Add or update CI build system." },
  { name = "chart_with_upwards_trend", emoji = "📈", desc = "Add or update analytics or track code." },
  { name = "recycle", emoji = "♻️", desc = "Refactor code." },
  { name = "heavy_plus_sign", emoji = "➕", desc = "Add a dependency." },
  { name = "heavy_minus_sign", emoji = "➖", desc = "Remove a dependency." },
  { name = "wrench", emoji = "🔧", desc = "Add or update configuration files." },
  { name = "hammer", emoji = "🔨", desc = "Add or update development scripts." },
  { name = "globe_with_meridians", emoji = "🌐", desc = "Internationalization and localization." },
  { name = "pencil2", emoji = "✏️", desc = "Fix typos." },
  { name = "poop", emoji = "💩", desc = "Write bad code that needs to be improved." },
  { name = "rewind", emoji = "⏪️", desc = "Revert changes." },
  { name = "twisted_rightwards_arrows", emoji = "🔀", desc = "Merge branches." },
  { name = "package", emoji = "📦️", desc = "Add or update compiled files or packages." },
  { name = "alien", emoji = "👽️", desc = "Update code due to external API changes." },
  { name = "truck", emoji = "🚚", desc = "Move or rename resources (e.g.: files, paths, routes)." },
  { name = "page_facing_up", emoji = "📄", desc = "Add or update license." },
  { name = "boom", emoji = "💥", desc = "Introduce breaking changes." },
  { name = "bento", emoji = "🍱", desc = "Add or update assets." },
  { name = "wheelchair", emoji = "♿️", desc = "Improve accessibility." },
  { name = "bulb", emoji = "💡", desc = "Add or update comments in source code." },
  { name = "beers", emoji = "🍻", desc = "Write code drunkenly." },
  { name = "speech_balloon", emoji = "💬", desc = "Add or update text and literals." },
  { name = "card_file_box", emoji = "🗃️", desc = "Perform database related changes." },
  { name = "loud_sound", emoji = "🔊", desc = "Add or update logs." },
  { name = "mute", emoji = "🔇", desc = "Remove logs." },
  { name = "busts_in_silhouette", emoji = "👥", desc = "Add or update contributor(s)." },
  { name = "children_crossing", emoji = "🚸", desc = "Improve user experience / usability." },
  { name = "building_construction", emoji = "🏗️", desc = "Make architectural changes." },
  { name = "iphone", emoji = "📱", desc = "Work on responsive design." },
  { name = "clown_face", emoji = "🤡", desc = "Mock things." },
  { name = "egg", emoji = "🥚", desc = "Add or update an easter egg." },
  { name = "see_no_evil", emoji = "🙈", desc = "Add or update a .gitignore file." },
  { name = "camera_flash", emoji = "📸", desc = "Add or update snapshots." },
  { name = "alembic", emoji = "⚗️", desc = "Perform experiments." },
  { name = "mag", emoji = "🔍️", desc = "Improve SEO." },
  { name = "label", emoji = "🏷️", desc = "Add or update types." },
  { name = "seedling", emoji = "🌱", desc = "Add or update seed files." },
  { name = "triangular_flag_on_post", emoji = "🚩", desc = "Add, update, or remove feature flags." },
  { name = "goal_net", emoji = "🥅", desc = "Catch errors." },
  { name = "dizzy", emoji = "💫", desc = "Add or update animations and transitions." },
  { name = "wastebasket", emoji = "🗑️", desc = "Deprecate code that needs to be cleaned up." },
  { name = "passport_control", emoji = "🛂", desc = "Work on code related to authorization, roles and permissions." },
  { name = "adhesive_bandage", emoji = "🩹", desc = "Simple fix for a non-critical issue." },
  { name = "monocle_face", emoji = "🧐", desc = "Data exploration/inspection." },
  { name = "coffin", emoji = "⚰️", desc = "Remove dead code." },
  { name = "test_tube", emoji = "🧪", desc = "Add a failing test." },
  { name = "necktie", emoji = "👔", desc = "Add or update business logic." },
  { name = "stethoscope", emoji = "🩺", desc = "Add or update healthcheck." },
  { name = "bricks", emoji = "🧱", desc = "Infrastructure related changes." },
  { name = "technologist", emoji = "🧑‍💻", desc = "Improve developer experience." },
  { name = "money_with_wings", emoji = "💸", desc = "Add sponsorships or money related infrastructure." },
  { name = "thread", emoji = "🧵", desc = "Add or update code related to multithreading or concurrency." },
  { name = "safety_vest", emoji = "🦺", desc = "Add or update code related to validation." },
}

-- When typing a trigger with a ":" prefix, the ":" is not part of the trigger, but it is replaced by the snippet.
-- Consequently, to enforce the line begin condition, we actually need a prefix condition instead.
local show_condition = conds.make_strict_prefix_condition(":")

local snippets = {}
for _, gitmoji_data in ipairs(gitmojis_data) do
  table.insert(
    snippets,
    s({
      trig = ":" .. gitmoji_data.name .. ": " .. gitmoji_data.emoji,
      show_condition = show_condition,
      desc = gitmoji_data.desc
        .. " (Gitmoji)\n\nMultiple-choice snippet:\n- `"
        .. gitmoji_data.emoji
        .. " …`\n- `"
        .. gitmoji_data.emoji
        .. " (…) …` (with scope)",
    }, {
      c(1, {
        sn(nil, { t(gitmoji_data.emoji .. " "), r(1, "content", i(nil)) }),
        sn(nil, { t(gitmoji_data.emoji .. " ("), i(1), t("): "), r(2, "content") }),
      }),
    })
  )
end

return snippets
