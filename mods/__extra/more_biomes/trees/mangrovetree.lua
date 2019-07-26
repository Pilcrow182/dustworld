--function
local function add_leaves(pos, leave)
	local p = {x=pos.x, y=pos.y+1, z=pos.z}
	local n = minetest.get_node(p)
	if (n.name=="air") then
	  minetest.add_node({x=pos.x, y=pos.y, z=pos.z}, {name="trees:tree_mangrove"})
	  minetest.add_node(p, {name="trees:leaves_mangrove"})
	end
	for x = 1, -1, -1 do
		for z = 1, -1, -1 do
			local p = {x=pos.x+x, y=pos.y, z=pos.z+z}
			local n = minetest.get_node(p)
			if (n.name=="air") then
				minetest.add_node(p, {name=leave})
			end
		end
	end
end

abstract_trees.grow_mangrovetree = function(pos)
  local size = 5+math.random(11)  
  local trunk_node = "trees:tree_mangrove"
  local leaves_node = "trees:leaves_mangrove"
  
  local top = {x=pos.x, y=pos.y+size, z=pos.z}
  
  add_leaves({x=top.x+math.ceil(math.random(3))-2, y=top.y, z=top.z+math.ceil(math.random(3))-2},leaves_node)
    add_leaves({x=top.x+math.ceil(math.random(3))-2, y=top.y, z=top.z+math.ceil(math.random(3))-2},leaves_node)
  
  for i=1, size, 1 do
    if math.ceil(math.random(2)) == 1 then
      local dir = {
        x=math.ceil(math.random(3))-2,
        y=math.ceil(math.random(3))-2,
        z=math.ceil(math.random(3))-2,
      }
      if i < size/2 then
        add_leaves({x=pos.x+dir.x, y=top.y-i, z=pos.z+dir.z},leaves_node)
      end
    end
    minetest.add_node({x=top.x, y=top.y-i, z=top.z}, {name=trunk_node})
  end
  minetest.add_node({x=pos.x-1, y=pos.y, z=pos.z}, {name=trunk_node})
  minetest.add_node({x=pos.x+1, y=pos.y, z=pos.z}, {name=trunk_node})
  minetest.add_node({x=pos.x, y=pos.y, z=pos.z+1}, {name=trunk_node})
  minetest.add_node({x=pos.x, y=pos.y, z=pos.z-1}, {name=trunk_node})
end

--abm
minetest.register_abm({
  nodenames = "trees:sapling_mangrove",
  interval = 60,
  chance = 20,
  action = function(pos, node, _, _)
    minetest.get_node({x = pos.x, y = pos.y + 1, z = pos.z})
    if above.name == "air" or above.name == "default:water_source" then
      abstract_trees.grow_mangrovetree({x = pos.x, y = pos.y, z = pos.z})
      end
    end
})

--spawning
plantslib:register_generate_plant({
    surface = "default:dirt",
    max_count = 30,
    near_nodes = {"default:water_source"},
    near_nodes_size = 1,
    near_nodes_vertical = 3,
    near_nodes_count = 6,
    avoid_nodes = {"group:tree", "default:sand"},
    avoid_radius = 3,
    rarity = 50,
    seed_diff = 666,
    min_elevation = -3,
    max_elevation = 2,
    plantlife_limit = -0.5,
    check_air = false,
    humidity_max = -1,
    humidity_min = 0.5,
    temp_max = -0.8,
    temp_min = 0,
  },
  "abstract_trees.grow_mangrovetree"
)
