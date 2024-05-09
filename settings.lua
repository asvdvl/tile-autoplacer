local name_pref = "tile-autoplacer-"

local i = 0
local function get_next_order()
    i = i + 1
    return string.rep("a", i)
end

data:extend({
    --global
    {
        type = "bool-setting",
        name = name_pref.."allow-radius-more-than-build-distance",
        setting_type = "runtime-global",
        default_value = false,
        order = get_next_order()
    },

    --per user
    {
        type = "int-setting",
        name = name_pref.."radius",
        setting_type = "runtime-per-user",
        default_value = 1,
        minimum_value = 1,
        maximum_value = 128,
        order = get_next_order()
    },
    {
        type = "bool-setting",
        name = name_pref.."dont-build-if-on-tile",
        setting_type = "runtime-per-user",
        default_value = true,
        order = get_next_order()
    },
    {
        type = "bool-setting",
        name = name_pref.."auto-take-tiles-into-cursor",
        setting_type = "runtime-per-user",
        default_value = true,
        order = get_next_order()
    },
    {
        type = "string-setting",
        name = name_pref.."work-only-with-specific-tile",
        setting_type = "runtime-per-user",
        default_value = "",
        allow_blank = true,
        order = get_next_order()
    },
})
