local mod_gui = require "mod-gui"

function show_construction_wagon_gui(wagon, event)
  local player_info = storage.players[event.player_index]
  if not player_info then
    player_info = {player=game.players[event.player_index]}
    storage.players[event.player_index] = player_info
  end

  destroy_construction_wagon_gui(player_info)
  
  local wagon_info = storage.construction_wagons[wagon.unit_number]
  if not wagon_info then return end

  local gui = {wagon=wagon_info}
  player_info.construction_wagon_gui = gui
  local frame = mod_gui.get_frame_flow(player_info.player).add{type="frame", name="ct_construction_wagon_gui", caption={"ct_construction_wagon_gui"}, direction="vertical"}
  gui.frame = frame

  frame.add{type="label", caption={"ct_construction_wagon_gui_cargo_mode"}}
  gui.cargo_mode_full = frame.add{type="radiobutton", caption={"string-mod-setting.ct-default-cargo-mode-full"}, state=false}
  gui.cargo_mode_disabled = frame.add{type="radiobutton", caption={"string-mod-setting.ct-default-cargo-mode-disabled"}, state=false}
  gui.cargo_mode_fill = frame.add{type="radiobutton", caption={"string-mod-setting.ct-default-cargo-mode-fill"}, state=false}
  gui.cargo_mode_empty = frame.add{type="radiobutton", caption={"string-mod-setting.ct-default-cargo-mode-empty"}, state=false}

  update_construction_wagon_gui(player_info)
end

function destroy_construction_wagon_gui(player_info)
  if player_info.construction_wagon_gui then
    if player_info.construction_wagon_gui.frame.valid then
      player_info.construction_wagon_gui.frame.destroy()
    end
    player_info.construction_wagon_gui = nil
  end
end

function update_construction_wagon_gui(player_info)
  local gui = player_info.construction_wagon_gui
  local wagon_info = gui and gui.wagon
  
  if not wagon_info or not wagon_info.entity.valid or not gui or not gui.frame.valid then
    return destroy_construction_wagon_gui(player_info)
  end
  
  gui.cargo_mode_full.state = wagon_info.cargo_mode == "full"
  gui.cargo_mode_disabled.state = wagon_info.cargo_mode == "disabled"
  gui.cargo_mode_fill.state = wagon_info.cargo_mode == "fill"
  gui.cargo_mode_empty.state = wagon_info.cargo_mode == "empty"
end

function construction_wagon_on_gui_checked_state_changed(event)
  local player_info = storage.players[event.player_index]
  if not player_info or not player_info.construction_wagon_gui then
    return
  end
  
  local gui = player_info.construction_wagon_gui
  if event.element == gui.cargo_mode_full then
    update_cargo_mode(gui.wagon, "full")
  elseif event.element == gui.cargo_mode_disabled then
    update_cargo_mode(gui.wagon, "disabled")
  elseif event.element == gui.cargo_mode_fill then
    update_cargo_mode(gui.wagon, "fill")
  elseif event.element == gui.cargo_mode_empty then
    update_cargo_mode(gui.wagon, "empty")
  end
end
