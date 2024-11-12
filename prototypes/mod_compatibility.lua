-- Tonka Yellow
local tint = {1.0,0.757,0.169}

--Electric Trains by NerfKidJcb
if mods["electric-trains"] then
    local wagon = table.deepcopy(data.raw["cargo-wagon"]["electric-cargo-wagon"])

    wagon.name = "ct-construction-wagon-electric"
    wagon.icons = {{icon=wagon.icon, tint=tint}}
    wagon.minable.result = wagon.name
    wagon.inventory_size = 140
    wagon.equipment_grid = "ct-construction-wagon-equipment-grid-electric"
    wagon.allow_robot_dispatch_in_automatic_mode = true
    wagon.pictures.rotated.layers[1].tint = tint
    wagon.horizontal_doors.layers[1].tint = tint
    wagon.vertical_doors.layers[1].tint = tint

    if mods["elevated-rails"] then
        wagon.pictures.sloped.layers[1].tint = tint
    end

    local item = table.deepcopy(data.raw["item-with-entity-data"]["electric-cargo-wagon"])
    item.name = wagon.name
    item.icons = {{icon=item.icon, tint=tint}}
    item.place_result = wagon.name

    local recipe = table.deepcopy(data.raw["recipe"]["recipe-electric-cargo-wagon"])
    for ingredient in recipe.ingredients do
        if ingredient.name == "cargo-wagon" then
            ingredient.name = wagon.name
        end
    end

    local ingredient = {
        type = "unlock-recipe",
        recipe = wagon.name
      }
    table.insert(data.raw["technology"]["tech-electric-trains"].effects, ingredient)

    data:extend({
        wagon,
        item,
        {
          type = "equipment-grid",
          name = "ct-construction-wagon-equipment-grid-electric",
          width = 16,
          height = 14,
          equipment_categories = {"armor", "ct-construction-wagon-equipment"}
        }
      })
end