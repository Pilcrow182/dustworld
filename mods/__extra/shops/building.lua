local layers = {
	"333333"..
	"333333"..
	"333333"..
	"333333"..
	"333333"..
	"333333",

	"222222"..
	"211112"..
	"211512"..
	"211592"..
	"272222"..
	"111111",

	"222222"..
	"211112"..
	"211112"..
	"211182"..
	"212662"..
	"111111",

	"444444"..
	"555555"..
	"211112"..
	"211112"..
	"222222"..
	"111111",

	"111111"..
	"111111"..
	"444444"..
	"444444"..
	"444444"..
	"444444"
}

local nodes = {
	"air",
	"default:desert_stonebrick",
	"default:desert_sandstone_block",
	"stairs:slab_junglewood",
	"default:junglewood",
	"default:glass",
	"doors:door_wood_b",
	"shops:shopkeeper_upper",
	"shops:shopkeeper",
}

local map = {}
for y = 1, 5 do
	for x = 1, 6 do
		for z = 1, 6 do
			local strpos = 6 * (x - 1) + z
			local index = tonumber(layers[y]:sub(strpos, strpos))
			table.insert(map, {x = x - 6, y = y - 1, z = z - 2, name = nodes[index]})
		end
	end
end

-- make an isolated copy of the map created above, so we can modify it without changing the original
local get_map = function()
	local out = {}
	for k1,v1 in pairs(map) do
		out[k1] = {}
		for k2,v2 in pairs(v1) do
			out[k1][k2] = v2
		end
	end
	return out
end

shops.spawn_shop = function(pos)
	minetest.log("action", "[MOD] shops -- building new shop at "..minetest.pos_to_string(pos))
-- 	minetest.chat_send_all("[MOD] shops -- building new shop at "..minetest.pos_to_string(pos))
	for _,entry in pairs(get_map()) do
		entry.x, entry.y, entry.z = entry.x + pos.x, entry.y + pos.y, entry.z + pos.z
		minetest.after(math.random(1, 6) / 2, function(entry)
			minetest.set_node(entry, entry) -- entry functions both as pos and as node
		end, entry)
	end
end

minetest.register_chatcommand("spawn_shop", {
	params = "",
	description = "Spawn a shop into the world",
	privs = {protection_bypass=true},
	func = function(name, param)
		local pos = minetest.get_player_by_name(name):getpos()
		pos.x, pos.y, pos.z = math.floor(pos.x + 0.5), math.ceil(pos.y - 1), math.floor(pos.z + 0.5)
		shops.spawn_shop(pos)
	end,
})

local valid_spawn = function(pos)
	local ignore = minetest.find_node_near(pos, 6, {"ignore"})
	if ignore then return false end
	for x = pos.x - 6, pos.x do
		for z = pos.z - 2, pos.z + 4 do
			local node = minetest.get_node({x = x, y = pos.y, z = z})
			if string.find(node.name, "tree") then return false end -- don't overwrite trees
			for _,name in pairs({"air", "default:water_source", "default:water_flowing"}) do
				if node.name == name then return false end
			end
		end
	end
	return true
end

local find_surface = function(x, z)
	local vm = minetest.get_voxel_manip()
	local ground_level, y, pos, node = nil, nil, nil, nil
	for y = 96, -100, -1 do   
		pos = {x = x, y = y, z = z}
		vm:read_from_map(pos, pos)
		node = minetest.get_node(pos)
		if not ( node.name == "air" or node.name == "ignore" or string.find(node.name, "leaves") ) then
			ground_level = y
			break
		end
	end
	if not ground_level then return false end
	return {x=x, y=ground_level, z=z}
end

minetest.register_on_generated(function(minp, maxp, blockseed)
	if math.random(1, 100) > 5 then return end -- 5% chance of generating trader hut
	local pos = find_surface((maxp.x - minp.x) / 2 + minp.x, (maxp.z - minp.z) / 2 + minp.z)
	if pos and valid_spawn(pos) then shops.spawn_shop(pos) end
end)
