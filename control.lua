local tile = {name="refined-concrete", position={}}

local function on_player_changed_position(event)
    local player = game.get_player(event.player_index)
    tile.position = player.position
    player.surface.set_tiles({tile}, false, false)
end

script.on_event(defines.events.on_player_changed_position, on_player_changed_position)