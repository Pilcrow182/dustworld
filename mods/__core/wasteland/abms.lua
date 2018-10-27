minetest.register_abm({
	nodenames = {"default:water_flowing", "default:water_source"},
	interval = 10,
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
			if math.random(0,2) == 1 and minetest.get_node(adjacent[i]).name == "wasteland:dust" then minetest.set_node(adjacent[i], {name = "default:clay"}) end
		end
	end
})

minetest.register_abm({
	nodenames = {"default:clay"},
	interval = 10,
	chance = 2,
	action = function(pos)
		local wet = false
		local adjacent = {
			{x=pos.x+1,y=pos.y,z=pos.z}, -- east
			{x=pos.x-1,y=pos.y,z=pos.z}, -- west
			{x=pos.x,y=pos.y+1,z=pos.z}, -- up
			{x=pos.x,y=pos.y-1,z=pos.z}, -- down
			{x=pos.x,y=pos.y,z=pos.z+1}, -- north
			{x=pos.x,y=pos.y,z=pos.z-1}  -- south
		}
		for i=1,6 do
			local name = minetest.get_node(adjacent[i]).name
			if name == "default:water_flowing" or name == "default:water_source" then wet = true break end
		end
		if wet == false then minetest.set_node(pos, {name="wasteland:dust"}) end
	end
})
