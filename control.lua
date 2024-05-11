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

local function item_is_tile(item)
    if type(item) == "string" then
        item = game.item_prototypes[item]
    end
    return item.place_as_tile_result and item.place_as_tile_result.result
end

local function on_player_changed_position_logic(event)
    local player = game.get_player(event.player_index)
    if player.is_shortcut_toggled(shortcut_name) then
        --checks that the player is not standing on a tile with which he can interact(mine/place)
        local dont_allow_to_build_tile = player.surface.get_tile(player.position.x, player.position.y).prototype.mineable_properties.minable and get_setting_value("dont-build-if-on-tile", player)
        local hand_not_empty = player.cursor_stack.valid_for_read
        local is_tile_in_hand = hand_not_empty and item_is_tile(player.cursor_stack.prototype.name)
        local filter_item_name = #get_setting_value("work-only-with-specific-tile", player) > 0 and get_setting_value("work-only-with-specific-tile", player)

        if filter_item_name and not game.item_prototypes[filter_item_name] then
            player.print({"?", {"message.tile-autoplacer-item-not-found", filter_item_name}})
            return
        end

        if dont_allow_to_build_tile or (hand_not_empty and not is_tile_in_hand) or (is_tile_in_hand and filter_item_name and is_tile_in_hand.name ~= filter_item_name) then
            --if there is no building permit or there is something else in the cursor, we skip the rest of the logic
            return
        end

        if get_setting_value("auto-take-tiles-into-cursor", player) and not is_tile_in_hand then
            local inventory = player.get_main_inventory().get_contents()
            local best_tile = {name = "", speed = 0}

            if not filter_item_name then
                for key in pairs(inventory) do
                    local place_result = game.item_prototypes[key].place_as_tile_result and game.item_prototypes[key].place_as_tile_result.result
                    if place_result and place_result.valid and place_result.walking_speed_modifier and best_tile.speed < place_result.walking_speed_modifier then
                        best_tile.name = key
                        best_tile.speed = place_result.walking_speed_modifier
                        log(tostring(key)..tostring(place_result.walking_speed_modifier))
                    end
                end
            elseif player.get_main_inventory().find_item_stack(filter_item_name) then
                best_tile.name = filter_item_name
            else
                return
            end

            if #best_tile.name > 0 then
                inventory = player.get_main_inventory()
                for i = 1, #inventory do
                    if inventory[i].name == best_tile.name then
                      player.cursor_stack.transfer_stack(inventory[i])
                      break
                    end
                end
                --for some reason this line didn’t work, on the other hand I don’t care, it works
                --player.cursor_stack.transfer_stack(player.get_main_inventory().find_item_stack(best_tile.name))
                is_tile_in_hand = true
            end
        end

        if is_tile_in_hand then
            player.build_from_cursor{
                position=player.position,
                terrain_building_size=get_radius(player)
            }
        end
    end
end

local function on_lua_shortcut(event)
    local player = game.get_player(event.player_index)

    player.set_shortcut_toggled(shortcut_name, not player.is_shortcut_toggled(shortcut_name))
end

local function on_player_changed_position(event)
    local success, reason = pcall(on_player_changed_position_logic, event)
    if not success then
        local message = "error while handling event: "..reason.."; event data: "..serpent.block(event)
        log(message)
        game.print(message)
    end
end

script.on_event(defines.events.on_player_changed_position, on_player_changed_position)
script.on_event(defines.events.on_lua_shortcut, on_lua_shortcut)
script.on_event("toggle-tile-autoplacer-custom-input", on_lua_shortcut)
