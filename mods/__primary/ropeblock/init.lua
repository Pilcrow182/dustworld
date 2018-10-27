ropeblock = {}

--functions
local function change_rope(pos)
  local n = minetest.get_node(pos).name
  local a = {x=pos.x, y=pos.y+1, z=pos.z}
  local an = minetest.get_node(a).name
  if n == "air" or string.find(n, "ropeblock") ~= nil then
    if an == "ropeblock:end" then minetest.add_node(a, {name="ropeblock:rope"}) end
  else
    if an == "ropeblock:rope" then minetest.add_node(a, {name="ropeblock:end"}) end
  end
end

function ropeblock:add_rope(pos)
  change_rope(pos)
  while minetest.get_node(pos).name == "air" do
    minetest.add_node(pos, {name="ropeblock:rope"})
    pos.y = pos.y-1
  end
  change_rope(pos)
end

function ropeblock:remove_rope(pos)
  local above = minetest.get_node({x=pos.x, y=pos.y+1, z=pos.z})
  if string.find(above.name, "ropeblock") ~= nil or above.name == "ignore" or minetest.get_node(pos).name == "ropeblock:source" then
    return false
  else
    while minetest.get_node(pos).name == "ropeblock:rope" or minetest.get_node(pos).name == "ropeblock:end" do
      minetest.add_node(pos, {name="air"})
      pos.y = pos.y-1
    end
  return true
  end
end

--nodes
minetest.register_node("ropeblock:source", {
  description = "Rope Block",
  sunlight_propagates = true,
  paramtype = "light",
  tiles = {"ropeblock_source_top.png", "ropeblock_source_top.png", "ropeblock_source.png"},
  groups = {choppy=2,oddly_breakable_by_hand=1, flammable=2},
  after_place_node = function(pos)
    ropeblock:add_rope({x=pos.x, y=pos.y-1, z=pos.z})
  end
})

for _,name in ipairs({"rope", "end"}) do
  minetest.register_node("ropeblock:"..name, {
    description = "Rope",
    walkable = false,
    climbable = true,
    pointable = false,
    diggable = false,
    buildable_to = true,
    air_equivalent = true,
    sunlight_propagates = true,
    paramtype = "light",
    tile_images = { "ropeblock_"..name..".png" },
    drawtype = "plantlike",
    groups = {flammable=2, not_in_creative_inventory=1},
    drop = ""
  })
end

--craft
minetest.register_craft({
  output = 'ropeblock:source',
  recipe = {
    {'', 'group:wood', ''},
    {'', 'survivalist:silk_string', ''},
    {'', 'survivalist:silk_string', ''},
  }
})

--ABMs
minetest.register_abm({
  nodenames = {"ropeblock:source", "ropeblock:rope", "ropeblock:end"},
  interval = 2,
  chance = 1,
  action = function(pos)
    if not ropeblock:remove_rope(pos) then ropeblock:add_rope({x=pos.x, y=pos.y-1, z=pos.z}) end
  end
})
