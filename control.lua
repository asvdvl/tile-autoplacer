local tile_name = "refined-concrete"

local function on_player_changed_position(event)
    local player = game.get_player(event.player_index)

    player.build_from_cursor{position=player.position}
end

script.on_event(defines.events.on_player_changed_position, on_player_changed_position)
