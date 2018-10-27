crash_site.fuel_cooling = function(pos)
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
		if name == "default:water_flowing" or name == "default:water_source" then
			return true
		end
	end
end

minetest.register_abm({
	nodenames = {"crash_site:fuel", "crash_site:fuel_frozen"},
	interval = 5,
	chance = 1,
	action = function(pos)
		if crash_site.fuel_cooling(pos) then
			if minetest.get_node(pos).name == "crash_site:fuel_frozen" then return end
			minetest.set_node(pos, {name="crash_site:fuel_frozen"})
		else
			if minetest.get_node(pos).name == "crash_site:fuel" then return end
			minetest.set_node(pos, {name="crash_site:fuel"})
		end
	end
})
