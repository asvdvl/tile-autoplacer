local base_name = "toggle-"..script.mod_name
local shortcut_name = base_name.."-shortcut"

local function get_setting_value(name, player)
    local setting_name = script.mod_name.."-"..name
    if player then
        return player.mod_settings[setting_name].value
    else
        return settings.global[setting_name].value
    end
end

local function get_radius(player)
    local build_distance = player.build_distance + player.character_build_distance_bonus
    if get_setting_value("allow-radius-more-than-build-distance") or get_setting_value("radius", player) <= build_distance then
        return get_setting_value("radius", player)
    else
        return build_distance
    end
end

local function on_player_changed_position(event)
    local player = game.get_player(event.player_index)
    local tile_check = not (player.surface.get_tile(player.position.x, player.position.y).prototype.mineable_properties.minable and get_setting_value("dont-build-if-on-tile", player))
    local is_tile_in_hand = player.cursor_stack.valid_for_read and game.tile_prototypes[player.cursor_stack.prototype.name]

    if player.is_shortcut_toggled(shortcut_name)
        and tile_check
        and is_tile_in_hand
    then
        player.build_from_cursor{
            position=player.position,
            terrain_building_size=get_radius(player)
        }
    end
end

local function on_lua_shortcut(event)
    local player = game.get_player(event.player_index)

    player.set_shortcut_toggled(shortcut_name, not player.is_shortcut_toggled(shortcut_name))
end

script.on_event(defines.events.on_player_changed_position, on_player_changed_position)
script.on_event(defines.events.on_lua_shortcut, on_lua_shortcut)
script.on_event("toggle-tile-autoplacer-custom-input", on_lua_shortcut)
