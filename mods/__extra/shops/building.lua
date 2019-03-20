local DEBUG, VERBOSE = true, false
local debug_msg = function(message)
	if DEBUG then
		minetest.log("action", message)
		if VERBOSE then
			minetest.chat_send_all(message)
		end
	end
end

shops.build_map = function(foundation)
	if not minetest.registered_nodes[foundation] then
		foundation = "default:stone"
	end

	local n01 = { name = foundation }
	local n02 = { name = "default:desert_sandstone_block" }
	local n03 = { name = "air" }
	local n04 = { name = "stairs:slab_junglewood", param2 = 1 }
	local n05 = { name = "default:desert_stonebrick", param2 = 1 }
	local n06 = { name = "doors:door_wood_b", param2 = 1 }
	local n07 = { name = "doors:hidden" }
	local n08 = { name = "default:glass" }
	local n09 = { name = "default:junglewood", param2 = 1 }
	local n10 = { name = "shops:shopkeeper", param2 = 1 }
	local n11 = { name = "shops:shopkeeper_upper", param2 = 1 }

	local map = {
		size = {x = 6, y = 10, z = 6},
		data = {
			n01, n01, n01, n01, n01, n01,
        	n01, n01, n01, n01, n01, n01,
			n01, n01, n01, n01, n01, n01,
			n01, n01, n01, n01, n01, n01,
			n01, n01, n01, n01, n01, n01,
			n02, n02, n02, n02, n02, n02,
			n03, n03, n03, n03, n03, n03,
			n03, n03, n03, n03, n03, n03,
			n03, n03, n03, n03, n03, n03,
			n04, n04, n04, n04, n04, n04,

			n01, n01, n01, n01, n01, n01,
			n01, n01, n01, n01, n01, n01,
			n01, n01, n01, n01, n01, n01,
			n01, n01, n01, n01, n01, n01,
			n01, n01, n01, n01, n01, n01,
			n02, n02, n02, n02, n02, n02,
			n05, n06, n05, n05, n05, n05,
			n05, n07, n05, n08, n08, n05,
			n05, n05, n05, n05, n05, n05,
			n04, n04, n04, n04, n04, n04,

			n01, n01, n01, n01, n01, n01,
			n01, n01, n01, n01, n01, n01,
			n01, n01, n01, n01, n01, n01,
			n01, n01, n01, n01, n01, n01,
			n01, n01, n01, n01, n01, n01,
			n02, n02, n02, n02, n02, n02,
			n05, n03, n03, n09, n10, n05,
			n05, n03, n03, n03, n11, n05,
			n05, n03, n03, n03, n03, n05,
			n04, n04, n04, n04, n04, n04,

			n01, n01, n01, n01, n01, n01,
			n01, n01, n01, n01, n01, n01,
			n01, n01, n01, n01, n01, n01,
			n01, n01, n01, n01, n01, n01,
			n01, n01, n01, n01, n01, n01,
			n02, n02, n02, n02, n02, n02,
			n05, n03, n03, n09, n03, n05,
			n05, n03, n03, n03, n03, n05,
			n05, n03, n03, n03, n03, n05,
			n04, n04, n04, n04, n04, n04,

			n01, n01, n01, n01, n01, n01,
			n01, n01, n01, n01, n01, n01,
			n01, n01, n01, n01, n01, n01,
			n01, n01, n01, n01, n01, n01,
			n01, n01, n01, n01, n01, n01,
			n02, n02, n02, n02, n02, n02,
			n05, n03, n03, n03, n03, n05,
			n05, n03, n03, n03, n03, n05,
			n09, n09, n09, n09, n09, n09,
			n03, n03, n03, n03, n03, n03,

			n01, n01, n01, n01, n01, n01,
			n01, n01, n01, n01, n01, n01,
			n01, n01, n01, n01, n01, n01,
			n01, n01, n01, n01, n01, n01,
			n01, n01, n01, n01, n01, n01,
			n02, n02, n02, n02, n02, n02,
			n05, n05, n05, n05, n05, n05,
			n05, n05, n05, n05, n05, n05,
			n04, n04, n04, n04, n04, n04,
			n03, n03, n03, n03, n03, n03
		}
	}
	return map
end
shops.spawn_shop = function(pos)
	debug_msg("[MOD] shops -- building new shop at "..minetest.pos_to_string(pos))
	local map = shops.build_map(minetest.get_node({x=pos.x, y=pos.y-2, z=pos.z}).name)
	minetest.place_schematic({x = pos.x, y = pos.y - 5, z = pos.z}, map, 0, nil, true)
	minetest.registered_nodes["shops:shopkeeper"].on_construct({x = pos.x + 4, y = pos.y + 1, z = pos.z + 2})
end

minetest.register_chatcommand("spawn_shop", {
	params = "",
	description = "Manually spawn a shop somewhere already generated",
	privs = {protection_bypass=true},
	func = function(name, param)
		local pos = minetest.get_player_by_name(name):getpos()
		pos.x, pos.y, pos.z = math.floor(pos.x + 0.5), math.ceil(pos.y - 1), math.floor(pos.z + 0.5)
		shops.spawn_shop(pos)
	end,
})

local valid_spawn = function(pos)
	debug_msg("[MOD] shops -- checking if pos "..minetest.pos_to_string(pos).." is valid")
	if minetest.get_modpath("wasteland") then return false end -- don't spawn shops when playing dustworld
	local under = minetest.get_node({x = pos.x, y = pos.y - 1, z = pos.z})
	if under and under.name and minetest.get_item_group(under.name, "leaves") > 0 then return false end -- don't spawn on top of leaves
	local ignore = minetest.find_node_near(pos, 6, {"ignore"})
	if ignore then return false end
	local map = shops.build_map("default:stone")
	for x = pos.x, pos.x + map.size.x - 1 do
		for z = pos.z, pos.z + map.size.z - 1 do
			local node = minetest.get_node({x = x, y = pos.y, z = z})
			if string.find(node.name, "tree") or string.find(node.name, "cactus") then return false end -- don't overwrite trees/cactus
			for _,name in pairs({"default:water_source", "default:water_flowing", "default:river_water_source", "default:river_water_flowing"}) do
				if node.name == name then return false end -- don't spawn shops in water
			end
		end
	end
	debug_msg("[MOD] shops -- SUCCESS! Pos "..minetest.pos_to_string(pos).." is valid!")
	return true
end

local spawn_list = {}
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
	if pos and valid_spawn(pos) then table.insert(spawn_list, minetest.pos_to_string(pos)) end
end)

local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer >= 1 then
		timer = 0
		if #spawn_list == 0 then return end
		for k,v in pairs(spawn_list) do
			local pos = minetest.string_to_pos(v)
			local node = minetest.get_node(pos)
			if node and node.name ~= "ignore" then
				shops.spawn_shop(pos)
				spawn_list[k] = nil
			end
		end
	end
end)

