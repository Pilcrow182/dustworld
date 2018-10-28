-----------------
-- ENVIRONMENT --
-----------------

BUILD_MODE = false


------------
-- LEGACY --
------------

minetest.register_alias("instacabin:cabin", "instacabin:shack")


-----------
-- BUILD --
-----------

instacabin = {}

instacabin.build = function(n, value, env, disp, placer)
	local add_node = minetest.add_node
	local look_dir = placer:get_look_dir()
	local count = 0
	value = value:gsub("return%s*{", "", 1):gsub("}%s*$", "", 1)
	local escaped = value:gsub("\\\\", "@@"):gsub("\\\"", "@@"):gsub("(\"[^\"]*\")", function(s) return string.rep("@", #s) end)
	local startpos, startpos1, endpos = 1, 1
	local nodes = {}
	while true do
		startpos, endpos = escaped:find("},%s*{", startpos)
		if not startpos then
			break
		end
		local current = value:sub(startpos1, startpos)
		table.insert(nodes, minetest.deserialize("return " .. current))
		startpos, startpos1 = endpos, endpos
	end
	table.insert(nodes, minetest.deserialize("return " .. value:sub(startpos1)))
	count = #nodes

	if math.abs(look_dir.x) >= math.abs(look_dir.z) then
		if look_dir.x > 0 then
			rot = 2
		else
			rot = 0
		end
	elseif math.abs(look_dir.z) > math.abs(look_dir.x) then
		if look_dir.z > 0 then
			rot = 1
		else
			rot = 3
		end
	end

	if rot == 0 then originx, originy, originz = n.x-disp.x, n.y-disp.y, n.z-disp.z end --   0 degree rotation
	if rot == 1 then originx, originy, originz = n.x-disp.z, n.y-disp.y, n.z+disp.x end --  90 degree rotation
	if rot == 2 then originx, originy, originz = n.x+disp.x, n.y-disp.y, n.z+disp.z end -- 180 degree rotation
	if rot == 3 then originx, originy, originz = n.x+disp.z, n.y-disp.y, n.z-disp.x end -- 270 degree rotation

	for index = 1, count do
		local entry = nodes[index]
		if rot == 0 then entry.x, entry.y, entry.z = originx + entry.x, originy + entry.y, originz + entry.z end --   0 degree rotation
		if rot == 1 then entry.x, entry.y, entry.z = originx + entry.z, originy + entry.y, originz - entry.x end --  90 degree rotation
		if rot == 2 then entry.x, entry.y, entry.z = originx - entry.x, originy + entry.y, originz - entry.z end -- 180 degree rotation
		if rot == 3 then entry.x, entry.y, entry.z = originx - entry.z, originy + entry.y, originz + entry.x end -- 270 degree rotation

		local pt2 = "none"
		if entry and entry.name and minetest.registered_nodes[entry.name] and minetest.registered_nodes[entry.name].paramtype2 then
			pt2 = minetest.registered_nodes[entry.name].paramtype2
		end
		if pt2 == "facedir" then
			entry.param2 = entry.param2 + rot
			if entry.param2 > 3 then entry.param2 = entry.param2 - 4 end
		elseif pt2 == "wallmounted" then
			if rot ~= 0 then
				for i = 1, rot do
					if entry.param2 == 3 then
						entry.param2 = 4
					elseif entry.param2 == 4 then
						entry.param2 = 2
					elseif entry.param2 == 2 then
						entry.param2 = 5
					elseif entry.param2 == 5 then
						entry.param2 = 3
					end
				end
			end
		elseif pt2 ~= "none" and pt2 ~= "flowingliquid" then
			minetest.chat_send_all("ERROR:: Rotation unsupported for node "..entry.name.." at pos "..minetest.pos_to_string(entry))
			print("ERROR:: Rotation unsupported for node "..entry.name.." at pos "..minetest.pos_to_string(entry))
		end

		if minetest.registered_nodes[entry.name] then
			add_node(entry, entry)
		else
			minetest.log("[MOD] instacabin -- error placing node "..entry.name.." (node does not exist?)")
		end
		minetest.after(.5, function() return end)

		if string.find(entry.name, "doors:door_steel") ~= nil then
			local meta = minetest.env:get_meta(entry)
			meta:set_string("infotext", "Owned by "..placer:get_player_name())
			meta:set_string("doors_owner", placer:get_player_name())
		elseif string.find(entry.name, "luacontroller") ~= nil then
			local lc = {}
			lc[1], lc[2], lc[3], lc[4] = "a", "b", "c", "d"
			if rot ~= 0 then
				for i = 1, rot do
					for p = 1, 4 do
						if lc[p] == "a" then
							lc[p] = "b"
						elseif lc[p] == "b" then
							lc[p] = "c"
						elseif lc[p] == "c" then
							lc[p] = "d"
						elseif lc[p] == "d" then
							lc[p] = "a"
						end
					end
				end
			end
			local meta = minetest.env:get_meta(entry)
			meta:set_string("code", 'if event.iid == "on" then\nport.'..lc[4]..' = true\ninterrupt(.1, "")\nelseif pin.'..lc[3]..' then\nport.'..lc[4]..' = false\ninterrupt(.9, "on")\nend')
		end
	end
	--[[
	for index = 1, count do
		local entry = nodes[index]
		env:get_meta(entry):from_table(entry.meta)
	end
	--]]
end


----------
-- VOID --
----------

if BUILD_MODE then
	VOID = "instacabin_void_build.png"
else
	VOID = "instacabin_void.png"
	minetest.register_abm({
		nodenames = {"instacabin:void"},
		interval = 2,
		chance = 1,
		action = function(pos, node)
			minetest.env:remove_node(pos)
		end,
	})
end

minetest.register_node("instacabin:void", {
	tiles = {VOID},
	inventory_image = "instacabin_void_inv.png",
	wield_image = "instacabin_void_inv.png",
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {-0.05, -0.05, -0.05, 0.05, 0.05, 0.05},
	},
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {0, 0, 0, 0, 0, 0},
	},
	groups = {dig_immediate=3,not_in_creative_inventory=1},
	drop = ''
})

----------
-- MAIN --
----------

local instabuild_list = {
	{"Empty Shack", "shack", "instacabin_shack.png", 5, 1, 4},

	{"House", "house", "instacabin_house_bronze.png", 7, 1, 4},
	{"Large House", "house_large", "instacabin_house_silver.png", 11, 7, 3},
	{"Mansion (unfurnished)", "mansion", "instacabin_house_gold.png", 22, 2, 18},

	{"Tower", "tower", "instacabin_tower_bronze.png", 8, 0, 4},
	{"Large Tower", "tower_large", "instacabin_tower_silver.png", 8, 0, 4},
	{"Apartment", "apartment", "instacabin_tower_gold.png", 13, 1, 5},

	{"Warehouse", "warehouse", "instacabin_warehouse_bronze.png", 7, 0, 4},
	{"Large Warehouse", "warehouse_large", "instacabin_warehouse_silver.png", 11, 0, 6},
	{"Vault", "vault", "instacabin_warehouse_gold.png", 15, 0, 8},

	{"Garden", "garden", "instacabin_garden_bronze.png", 6, 2, 4},
	{"Large Garden", "garden_large", "instacabin_garden_silver.png", 8, 2, 5},
	{"Greenhouse", "greenhouse", "instacabin_garden_gold.png", 15, 1, 8},

	{"Cobble Generator", "cobble_gen", "instacabin_cobble_gen.png", 3, 1, 1},
	{"Obsidian Generator", "obsidian_gen", "instacabin_obsidian_gen.png", 3, 1, 2},
}

for i in ipairs(instabuild_list) do
	local builddesc = instabuild_list[i][1]
	local build = instabuild_list[i][2]
	local inv_image = instabuild_list[i][3]
	local dispx = instabuild_list[i][4]
	local dispy = instabuild_list[i][5]
	local dispz = instabuild_list[i][6]
	local disp = {x = dispx, y = dispy, z = dispz}

	minetest.register_craftitem("instacabin:"..build, {
		description = builddesc,
		inventory_image = inv_image,
		on_place = function(itemstack, placer, pointed_thing)
			if minetest.registered_nodes[minetest.env:get_node(pointed_thing.under).name].on_rightclick then
				return minetest.registered_nodes[minetest.env:get_node(pointed_thing.under).name].on_rightclick(pointed_thing.under, minetest.env:get_node(pointed_thing.under), placer, itemstack)
			end
			if pointed_thing.above then
				local n = pointed_thing.above
				local file = io.open(minetest.get_modpath("instacabin").."/models/"..build..".we")
				local value = file:read("*a")
				file:close()
				minetest.chat_send_all("Spawning building. Please wait...")
				itemstack:take_item()
				instacabin.build(n, value, minetest.env, disp, placer)
			end
			return itemstack
		end,
	})
end

local craft_list = {
	{"shack", "house", "default:clay_brick"},
	{"house", "house_large", "default:clay_brick"},
	{"house_large", "mansion", "default:diamond"},

	{"shack", "tower", "default:cobble"},
	{"tower", "tower_large", "default:cobble"},
	{"tower_large", "apartment", "concrete:concrete"},

	{"shack", "warehouse", "group:wood"},
	{"warehouse", "warehouse_large", "group:wood"},
	{"warehouse_large", "vault", "default:steelblock"},

	{"garden", "garden_large", "default:dirt"},
	{"garden_large", "greenhouse", "group:wood"},
}

for i in ipairs(craft_list) do
	local input = craft_list[i][1]
	local output = craft_list[i][2]
	local material = craft_list[i][3]

	minetest.register_craft({
		output = "instacabin:"..output,
		recipe = {
			{material, material, material},
			{material, "instacabin:"..input, material},
			{material, material, material},
		}
	})
end

minetest.register_craft({
	output = "instacabin:cobble_gen",
	recipe = {
		{"bucket:bucket_lava", "mesecons_luacontroller:luacontroller0000"},
		{"pipeworks:nodebreaker_off", "mesecons_switch:mesecon_switch_off"},
		{"bucket:bucket_water", ""},
	},
	replacements = {
		{"bucket:bucket_lava", "bucket:bucket_empty"},
		{"bucket:bucket_water", "bucket:bucket_empty"}
	}
})

minetest.register_craft({
	output = "instacabin:obsidian_gen",
	recipe = {
		{"", "bucket:bucket_lava", "mesecons_luacontroller:luacontroller0000"},
		{"bucket:bucket_lava", "pipeworks:nodebreaker_off", "mesecons_switch:mesecon_switch_off"},
		{"", "", "bucket:bucket_water"},
	},
	replacements = {
		{"bucket:bucket_lava", "bucket:bucket_empty"},
		{"bucket:bucket_lava", "bucket:bucket_empty"},
		{"bucket:bucket_water", "bucket:bucket_empty"}
	}
})
