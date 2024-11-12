require "construction_wagon_gui"

local function is_storage_wagon(wagon)
  return wagon.name ~= "ct-construction-wagon"
end

local function fill_stack(train, dst_wagon, filter, dst_stack) -- stack may or may not be empty
  local stack_size = prototypes.item[filter.name].stack_size
  local count
  if dst_stack.valid_for_read then
    count = dst_stack.count
    if count >= stack_size then
      -- full already, don't bother
      return
    end
  else
    count = 0 -- not valid_for_read is empty stack
  end
  for _, src_wagon in pairs(train.cargo_wagons) do
    if is_storage_wagon(src_wagon) then
      local src_inv = src_wagon.get_output_inventory()
      while true do -- might be multiple loops because stacks might not be full / compressed
        local src_stack = src_inv.find_item_stack(filter)
        if src_stack then
          dst_stack.transfer_stack(src_stack)
          if dst_stack.count == stack_size then
            return -- finished, full stack
          elseif dst_stack.count == count then -- transfer_stack no-oped, probably damaged and undamaged items not stacking together
            for i=1,#src_inv do
              src_stack = src_inv[i]
              dst_stack.transfer_stack(src_stack)
              if dst_stack.count == stack_size then
                return -- finished, full stack
              end
            end
            break -- quit the while true loop since the find_item_stack result still won't work
          end
          count = dst_stack.count -- save before value for next iteration
        else
          break -- no more stacks
        end
      end
    end
  end
end

local function dump_stack(train, stack)
  for _, wagon in pairs(train.cargo_wagons) do
    if is_storage_wagon(wagon) then
      stack.count = stack.count - wagon.insert(stack)
      if not stack.valid_for_read then
        return
      end
    end
  end
end

function manage_construction_wagon(info, tick)
  if info.cargo_mode_disabled then return end
  local train = info.entity.train
  local inv = info.entity.get_output_inventory()
  if inv then
    for i=1,#inv do
      if (tick + i) % #inv == 0 then
        local stack = inv[i]
        local filter = inv.get_filter(i)
        if filter then
          if info.cargo_mode_fill then
            fill_stack(train, info.entity, filter, stack)
          end
        elseif stack.valid_for_read then
          if info.cargo_mode_empty then
            dump_stack(train, stack)
          end
        end
      end
    end
  end
end

function update_cargo_mode(info, mode)
  info.cargo_mode = mode
  info.cargo_mode_disabled = mode == "disabled"
  info.cargo_mode_fill = mode == "full" or mode == "fill"
  info.cargo_mode_empty = mode == "full" or mode == "empty"
end

script.on_init(function()
  storage.construction_wagons = {}
  storage.players = {}
end)

script.on_event(defines.events.on_tick, function(event)
  for unit_number,info in pairs(storage.construction_wagons) do
    if info.entity.valid then
      manage_construction_wagon(info, unit_number + game.tick)
    else
      storage.construction_wagons[unit_number] = nil
    end
  end
  for _,info in pairs(storage.players) do
    if info.construction_wagon_gui then
      update_construction_wagon_gui(info)
    end
  end
end)

script.on_event(defines.events.on_built_entity, function(event)
    local cargo_mode = settings.get_player_settings(game.players[event.player_index])["ct-default-cargo-mode"].value
    local info = {entity=event.entity}
    update_cargo_mode(info, cargo_mode)
    storage.construction_wagons[event.entity.unit_number] = info
end, {{filter = "name", name = "ct-construction-wagon"}})

script.on_event(defines.events.on_gui_opened, function(event)
  if event.entity and event.entity.name == "ct-construction-wagon" then
    show_construction_wagon_gui(event.entity, event)
  end
end)

script.on_event(defines.events.on_gui_closed, function(event)
  local player_info = storage.players[event.player_index]
  if player_info and player_info.construction_wagon_gui then
    destroy_construction_wagon_gui(player_info)
  end
end)

script.on_event(defines.events.on_gui_checked_state_changed, construction_wagon_on_gui_checked_state_changed)
