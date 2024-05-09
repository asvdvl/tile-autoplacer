local icon = {
    filename = "__core__/graphics/icons/controller/joycon/color/dpad-down.png",
    width = 40,
    height = 40,
    mipmap_count = 2,
    scale = 0.5,
    load_in_minimal_mode = true,
    flags = {'icon'}
}

data:extend({{
    type = "shortcut",
    name = "toggle-tile-autoplacer",
    icon = icon,
    action = "lua",
    toggleable = true,
}})