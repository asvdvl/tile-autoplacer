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
        name = "toggle-tile-autoplacer-shortcut",
        icon = icon,
        action = "lua",
        toggleable = true,
        localised_name={"custom-input.toggle-tile-autoplacer"}
    },
    {
        type = "custom-input",
        name = "toggle-tile-autoplacer-custom-input",
        key_sequence = "CONTROL + ALT + SPACE",
        localised_name={"custom-input.toggle-tile-autoplacer"},
        action = "lua",
    }
})