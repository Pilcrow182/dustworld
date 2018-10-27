-- nodes
minetest.register_node("ropeblock:source", {
  description = "Rope",
  sunlight_propagates = true,
  paramtype = "light",
  drops = "",
  tile_images = {
    "ropeblock_source.png",
    "ropeblock_source.png",
    "default_wood.png",
    "default_wood.png",
    "ropeblock_source.png",
    "ropeblock_source.png"
  },
  drawtype = "cube",
  groups = {choppy=2,oddly_breakable_by_hand=1},
  after_place_node = function(pos)
    local p = {x=pos.x, y=pos.y-1, z=pos.z}
    local n = minetest.get_node(p)
    if n.name == "air" then
      minetest.add_node(p, {name="ropeblock:end"})
    end
  end,
  after_dig_node = function(pos, node, digger)
    local p = {x=pos.x, y=pos.y-1, z=pos.z}
    local n = minetest.get_node(p)
    while n.name == 'ropeblock:rope' do
      minetest.remove_node(p)
      p = {x=p.x, y=p.y-1, z=p.z}
      n = minetest.get_node(p)
    end
    if n.name == 'ropeblock:end' then
      minetest.remove_node(p)
    end
  end
})

minetest.register_node("ropeblock:rope", {
  description = "Rope",
  walkable = false,
  climbable = true,
  sunlight_propagates = true,
  paramtype = "light",
  tile_images = { "ropeblock_rope.png" },
  drawtype = "plantlike",
  groups = {flammable=2, not_in_creative_inventory=1},
  sounds =  default.node_sound_leaves_defaults(),
  selection_box = {
    type = "fixed",
    fixed = {-1/7, -1/2, -1/7, 1/7, 1/2, 1/7},
  },
})

minetest.register_node("ropeblock:end", {
  description = "Rope",
  walkable = false,
  climbable = true,
  sunlight_propagates = true,
  paramtype = "light",
  drops = "",
  tile_images = { "ropeblock_end.png" },
  drawtype = "plantlike",
  groups = {flammable=2, not_in_creative_inventory=1},
  sounds =  default.node_sound_leaves_defaults(),
  after_place_node = function(pos)
    yesh  = {x = pos.x, y= pos.y-1, z=pos.z}
    minetest.add_node(yesh, "ropeblock:rope")
  end,
  selection_box = {
	  type = "fixed",
	  fixed = {-1/7, -1/2, -1/7, 1/7, 1/2, 1/7},
  },
})

-- craft
minetest.register_craft({
  output = 'ropeblock:source',
  recipe = {
    {'', 'group:wood', ''},
    {'', 'farming:string', ''},
    {'', 'farming:string', ''},
  }
})

-- ABMs
minetest.register_abm({
  nodenames = {"ropeblock:end"},
  interval = 1,
  chance = 1,
  action = function(pos, node, active_object_count, active_object_count_wider)
    local p = {x=pos.x, y=pos.y-1, z=pos.z}
    local n = minetest.get_node(p)
    --remove if top node is removed
    if  n.name == "air" then
      minetest.set_node(pos, {name="ropeblock:rope"})
      minetest.add_node(p, {name="ropeblock:end"})
    end 
  end
})
