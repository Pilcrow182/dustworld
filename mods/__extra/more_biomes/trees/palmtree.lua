--function
abstract_trees.grow_palmtree = function(pos)
  -- (variables)
  local trunk_node = "trees:tree_palm"
  local leaves_node = "trees:leaves_palm"
  local height = 5+math.random(2)
  local offset = {x=pos.x, y=pos.y, z=pos.z}
  -- (trunk)
  for v=0,height-4 do minetest.env:add_node({x = offset.x, y = offset.y + v, z = offset.z}, {name = trunk_node}) end
  offset = {x=offset.x+math.ceil(math.random(3))-2, y=offset.y, z=offset.z+math.ceil(math.random(3))-2}
  for v=height-3,height-2 do minetest.env:add_node({x = offset.x, y = offset.y + v, z = offset.z}, {name = trunk_node}) end
  offset = {x=offset.x+math.ceil(math.random(3))-2, y=offset.y, z=offset.z+math.ceil(math.random(3))-2}
  local v = height-1
  minetest.env:add_node({x = offset.x, y = offset.y + v, z = offset.z}, {name = trunk_node})
  -- (leaves)
  local make_leaves = function(pos, l, v)
    for p=-l,l,l*2 do
      minetest.env:add_node({x = pos.x, y = pos.y + v, z = pos.z + p}, {name = leaves_node})
      minetest.env:add_node({x = pos.x + p, y = pos.y + v, z = pos.z}, {name = leaves_node})
    end
  end
  minetest.env:add_node({x = offset.x, y = offset.y + height, z = offset.z}, {name = leaves_node})
  for l=1,2 do make_leaves(offset, l, height) end
  for l=2,3 do make_leaves(offset, l, height-1) end
  make_leaves(offset, 3, height-2)
end

-- abm
minetest.register_abm({
  nodenames = "trees:sapling_palm",
  interval = 1000,
  chance = 4,
  action = function(pos, node, _, _)
    if minetest.env:get_node({x = pos.x, y = pos.y + 1, z = pos.z}).name == "air" then
      abstract_trees.grow_palmtree({x = pos.x, y = pos.y, z = pos.z})
      end
    end
})

--spawn
plantslib:register_generate_plant({
	surface = "default:sand",
	seed_diff = 330,
	min_elevation = -1,
	max_elevation = 5,
	near_nodes = {"default:water_source"},
	near_nodes_size = 15,
	near_nodes_count = 6,
	avoid_nodes = {"group:tree"},
  avoid_radius = 9,
	plantlife_limit = -0.8,
	temp_min = 0.15,
	temp_max = -0.25,
	rarity = 50,
	max_count = 10,
},
  "abstract_trees.grow_palmtree"
)
