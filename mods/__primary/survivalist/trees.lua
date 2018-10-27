survivalist.big_tree = function(pos, trunk, leaves, fruit)
	local height = 7
	for i=0,height-2 do minetest.set_node({x = pos.x, y = pos.y + i, z = pos.z}, {name = trunk}) end
	for j=3,height do
		for k=-3,3 do
			for l=-3,3 do
				local limit = 5
				if j==3 or j==height then limit = 4 end
				local testpos = {x = pos.x + k, y = pos.y + j, z = pos.z + l}
				if math.abs(k)+math.abs(l) < limit and minetest.get_node(testpos).name == "air" then
					local leaf_or_fruit = leaves
					if math.random(0,5) == 2 then leaf_or_fruit = fruit end
					minetest.set_node({x = pos.x + k, y = pos.y + j, z = pos.z + l}, {name = leaf_or_fruit})
				end
			end
		end
	end
end

survivalist.small_tree = function(pos, trunk, leaves, fruit)
	local height = 5
	for i=0,height-1 do minetest.set_node({x = pos.x, y = pos.y + i, z = pos.z}, {name = trunk}) end
	for j=2,height do
		for k=-2,2 do
			for l=-2,2 do
				local limit = 4
				local testpos = {x = pos.x + k, y = pos.y + j, z = pos.z + l}
				if math.abs(k)+math.abs(l) < limit and minetest.get_node(testpos).name == "air" then
					local leaf_or_fruit = leaves
					if math.random(0,5) == 2 then leaf_or_fruit = fruit end
					minetest.set_node({x = pos.x + k, y = pos.y + j, z = pos.z + l}, {name = leaf_or_fruit})
				end
			end
		end
	end
end

survivalist.grow_tree = function(pos, trunk, leaves, fruit)
	if math.random(0,4) > 2 then
		survivalist.big_tree(pos, trunk, leaves, fruit)
	else
		survivalist.small_tree(pos, trunk, leaves, fruit)
	end
end

minetest.register_abm({
	nodenames = {"survivalist:acorn"},
	interval = 20,
	chance = 3,
	action = function(pos)
		minetest.set_node(pos, {name = "survivalist:oak_sapling"})
	end
})

minetest.register_abm({
	nodenames = {"survivalist:apple_core"},
	interval = 20,
	chance = 3,
	action = function(pos)
		minetest.set_node(pos, {name = "survivalist:apple_sapling"})
	end
})

minetest.register_abm({
	nodenames = {"survivalist:oak_sapling"},
	interval = 60,
--	interval = 20,
	chance = 20,
--	chance = 4,
	action = function(pos)
		survivalist.grow_tree(pos, "default:tree", "default:leaves", "default:leaves")
	end
})

minetest.register_abm({
	nodenames = {"survivalist:apple_sapling"},
	interval = 60,
--	interval = 20,
	chance = 20,
--	chance = 4,
	action = function(pos)
		survivalist.grow_tree(pos, "default:tree", "survivalist:apple_leaves", "default:apple")
	end
})

minetest.register_abm({
	nodenames = {"survivalist:silk_leaves"},
	interval = 20,
	chance = 1,
	action = function(pos)
		local adjacent = {
			{x=pos.x+1,y=pos.y,z=pos.z}, -- east
			{x=pos.x-1,y=pos.y,z=pos.z}, -- west
			{x=pos.x,y=pos.y+1,z=pos.z}, -- up
			{x=pos.x,y=pos.y-1,z=pos.z}, -- down
			{x=pos.x,y=pos.y,z=pos.z+1}, -- north
			{x=pos.x,y=pos.y,z=pos.z-1}  -- south
		}
		for i=1,6 do
			if math.random(0,2) == 1 then
				local name = minetest.get_node(adjacent[i]).name
				if name == "default:leaves" or name == "survivalist:apple_leaves" then
					minetest.set_node(adjacent[i], {name = "survivalist:silk_leaves"})
				end
			end
		end
	end
})
