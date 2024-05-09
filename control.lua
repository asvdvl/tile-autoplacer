local shortcut_name = "toggle-tile-autoplacer"


local function on_player_changed_position(event)
    local player = game.get_player(event.player_index)

    if player.is_shortcut_toggled(shortcut_name) then
        player.build_from_cursor{position=player.position}
    end
end

local function on_lua_shortcut(event)
    local player = game.get_player(event.player_index)

    player.set_shortcut_toggled(shortcut_name, not player.is_shortcut_toggled(shortcut_name))
end

script.on_event(defines.events.on_player_changed_position, on_player_changed_position)
script.on_event(defines.events.on_lua_shortcut, on_lua_shortcut)