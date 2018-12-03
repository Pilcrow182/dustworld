local DEBUG, VERBOSE = true, false
local debug_msg = function(message)
	if DEBUG then
		minetest.log("action", message)
		if VERBOSE then
			minetest.chat_send_all(message)
		end
	end
end

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
	debug_msg("[MOD] shops -- building new shop at "..minetest.pos_to_string(pos))
	local fill_node = minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z})
	for _,entry in pairs(get_map()) do
		entry.x, entry.y, entry.z = entry.x + pos.x, entry.y + pos.y, entry.z + pos.z
		minetest.after(math.random(1, 6) / 2, function(entry)
			minetest.set_node({x=entry.x, y=entry.y-5, z=entry.z}, fill_node) -- generate shop foundation
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
	debug_msg("[MOD] shops -- checking if pos "..minetest.pos_to_string(pos).."is valid")
	local ignore = minetest.find_node_near(pos, 6, {"ignore"})
	if ignore then return false end
	for x = pos.x - 6, pos.x do
		for z = pos.z - 2, pos.z + 4 do
			local node = minetest.get_node({x = x, y = pos.y, z = z})
			if string.find(node.name, "tree") or string.find(node.name, "cactus") then return false end -- don't overwrite trees/cactus
			for _,name in pairs({"default:water_source", "default:water_flowing", "default:river_water_source", "default:river_water_flowing"}) do
				if node.name == name then return false end -- don't spawn shops in water
			end
		end
	end
	debug_msg("[MOD] shops -- SUCCESS! Pos "..minetest.pos_to_string(pos).."is valid!")
	return true
end

minetest.register_on_generated(function(minp, maxp, blockseed)
	if math.random(1, 100) > 5 then return end -- 5% chance of generating trader hut

	-- find surface
	local c_air = minetest.get_content_id("air")
	local c_ignore = minetest.get_content_id("ignore")
	local x, z = math.ceil((maxp.x - minp.x) / 2 + minp.x), math.ceil((maxp.z - minp.z) / 2 + minp.z)
	debug_msg("[MOD] shops -- trying to find surface at {x = "..x..", z = "..z.."}")
	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local data = vm:get_data()
	local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
	local ground_y = nil
	for y=maxp.y,minp.y,-1 do
		local vi = area:index(x, y, z)
		if data[vi] ~= c_air and data[vi] ~= c_ignore then
			debug_msg("[MOD] shops -- found surface at pos "..minetest.pos_to_string({x = x, y = y, z = z}))
			ground_y = y
			break
		end
	end
	if ground_y == nil then
		debug_msg("[MOD] shops -- no surface found at {x = "..x..", z = "..z.."}")
		return false
	end
	if ground_y > 100 then
		debug_msg("[MOD] shops -- refusing to spawn shop at height "..ground_y.."; height is above max of 100")
		return false
	end
	if ground_y < 0 then
		debug_msg("[MOD] shops -- refusing to spawn shop at height "..ground_y.."; height is below min of 0")
		return false
	end
		

	local pos = {x = x, y = ground_y, z = z}
	if pos and valid_spawn(pos) then shops.spawn_shop(pos) end
end)

