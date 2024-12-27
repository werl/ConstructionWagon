
local e
local tint = settings.startup["ct-default-wagon-tint"].value

e = table.deepcopy(data.raw["cargo-wagon"]["cargo-wagon"])
e.name = "ct-construction-wagon"
e.icons = {{icon=e.icon, tint=tint}}
e.minable.result = e.name
e.weight = 4000
e.inventory_size = 100
e.equipment_grid = "ct-construction-wagon-equipment-grid"
e.allow_robot_dispatch_in_automatic_mode = true
e.pictures.rotated.layers[1].tint = tint
e.horizontal_doors.layers[1].tint = tint
e.vertical_doors.layers[1].tint = tint

if mods["elevated-rails"] then
  e.pictures.sloped.layers[1].tint = tint
end

data:extend({
  e,
  {
    type = "item-with-entity-data",
    name = e.name,
    icons = e.icons,
    icon_size = 64, 
    subgroup = "train-transport",
    order = "a[train-system]-g2[cargo-wagon]",
    place_result = e.name,
    stack_size = 5
  },
  {
    type = "recipe",
    name = e.name,
    energy_required = 5,
    enabled = false,
    ingredients =
    {
      {type = "item", name = "iron-gear-wheel", amount = 40},
      {type = "item", name = "steel-plate", amount = 100},
      {type = "item", name = "advanced-circuit", amount = 50}
    },
    results = {{type="item", name=e.name, amount=1}}
  },
  {
    type = "equipment-category",
    name = "ct-construction-wagon-equipment"
  },
  {
    type = "equipment-grid",
    name = "ct-construction-wagon-equipment-grid",
    width = 12,
    height = 10,
    equipment_categories = {"armor", "ct-construction-wagon-equipment"}
  },
  {
    type = "technology",
    name = "ct-construction-train",
    icon_size = 128,
    icon = "__construction-train-werl__/graphics/technology/ct-construction-train.png",
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "ct-construction-wagon"
      }
    },
    prerequisites = {"personal-roboport-equipment", "railway"},
    unit =
    {
      count = 50,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1}
      },
      time = 30
    },
    order = "c-k-d-zz2"
  }
})

if mods["basic-robots"] then
  data.raw.technology["ct-construction-train"].prerequisites = {"basic-robots-robotics", "railway"}
  data.raw.technology["ct-construction-train"].unit.ingredients = {{"automation-science-pack", 1}, {"logistic-science-pack", 1}}
end
if mods["Krastorio2"] then
  data.raw["cargo-wagon"]["ct-construction-wagon"].equipment_grid = "kr-wagons-grid"
  data.raw.recipe["ct-construction-wagon"].energy_required = data.raw.recipe["cargo-wagon"].energy_required
end
if mods["space-exploration"] then
  data.raw["item-with-entity-data"]["ct-construction-wagon"].subgroup = "rail"
end
