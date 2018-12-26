seaflora = {}
seaflora.registered_spawns = {}
local land_types = {"dirt", "sand", "clay"}

local DEBUG, VERBOSE = false, false
local debug_msg = function(message)
	if DEBUG then
		minetest.log("action", message)
		if VERBOSE then
			minetest.chat_send_all(message)
		end
	end
end

local get_family = function(pos, name)
	local minp = {x = pos.x - 2, y = pos.y - 2, z = pos.z - 2}
	local maxp = {x = pos.x + 2, y = pos.y + 2, z = pos.z + 2}
	return #minetest.find_nodes_in_area(minp, maxp, {name})
end

local caps = function(word)
	return string.gsub(" "..word, "%W%l", string.upper):sub(2)
end

seaflora.register_flora = function(color, flora_type, active_spread, passive_spread, growth_rate, makes_dye)
	for _,land in ipairs(land_types) do
		local flora_name = "seaflora:"..land.."_with_"..color.."_"..flora_type
		minetest.register_node(flora_name, {
			description = caps(land).." With "..caps(color).." "..caps(flora_type),
			drawtype = "plantlike_rooted",
			tiles = {"default_"..land..".png"},
			special_tiles = {{name = "seaflora_"..flora_type.."_"..color..".png", tileable_vertical = true}},
			paramtype = "light",
			paramtype2 = "leveled",
			groups = {["flora_type"] = 1, seaflora = 1, snappy = 3, not_in_creative_inventory = 1},
			selection_box = {
				type = "fixed",
				fixed = {
					{-0.5,  0.5, -0.5, 0.5, 1.5, 0.5}, -- flora
					{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}, -- land
				},
			},
			drop = "seaflora:"..flora_type.."_"..color,

			on_construct = function(pos)
				minetest.swap_node(pos, {name=flora_name, param2 = 16})
			end,

			on_dig = function(pos, node, player)
				local replace = {name="default:"..land}
				if node.param2 > 16 then
					replace = node
					replace.param2 = replace.param2 - 16
				end
				minetest.node_dig(pos, node, player)
				minetest.swap_node(pos, replace)
			end,
		})

		seaflora.registered_spawns["default:"..land] = seaflora.registered_spawns["default:"..land] or {}
		table.insert(seaflora.registered_spawns["default:"..land], flora_name)

		minetest.register_abm({
			nodenames = {flora_name},
			interval = 10,
			chance = 1,
			action = function(pos)
				if growth_rate > 0 and math.random(0,99) < growth_rate then
					local growing = minetest.get_node(pos)
					local growpos = {x = pos.x, y = pos.y + ( growing.param2 / 16 ) + 1, z = pos.z}
					if minetest.get_node(growpos).name == "default:water_source" then
						debug_msg("[MOD] seaflora -- "..flora_type.." "..flora_name.." at "..minetest.pos_to_string(pos).." is trying to grow to "..minetest.pos_to_string(growpos))
						growing.param2 = growing.param2 + 16
						minetest.swap_node(pos, growing)
					end
				end

				local lonely, spread = false, false
				if math.random(0,99) < active_spread and get_family(pos, flora_name) < 3 then
					lonely = true
					spread = true
				elseif math.random(0,99) < passive_spread then
					spread = true
				end

				if spread then
					local xoff = math.random(-1, 1)
					local zoff = math.random(-1, 1)
					for yoff=-1,1 do
						local a = {x = pos.x + xoff, y = pos.y + yoff + 1, z = pos.z + zoff}
						local above = minetest.get_node(a)
						if above.name == "default:water_source" then
							local n = {x = pos.x + xoff, y = pos.y + yoff, z = pos.z + zoff}
							local node = minetest.get_node(n)
							for _,land in ipairs(land_types) do
								if node.name == "default:"..land then
									if lonely then
										debug_msg("[MOD] seaflora -- "..flora_type.." "..flora_name.." at "..minetest.pos_to_string(pos).." is lonely and spreading to "..minetest.pos_to_string(n))
									else
										debug_msg("[MOD] seaflora -- "..flora_type.." "..flora_name.." at "..minetest.pos_to_string(pos).." is passively spreading to "..minetest.pos_to_string(n))
									end
									minetest.set_node(n, {name = flora_name})
									return
								end
							end
						end
					end
				end
			end
		})
	end

	minetest.register_craftitem("seaflora:"..flora_type.."_"..color, {
		description = caps(color).." "..caps(flora_type),
		inventory_image = "seaflora_"..flora_type.."_"..color..".png",
		on_place = function(itemstack, placer, pointed_thing)
			local node_above = minetest.get_node(pointed_thing.above)
			local node_under = minetest.get_node(pointed_thing.under)

			if (not placer:get_player_control().sneak) and minetest.registered_nodes[node_under.name] and minetest.registered_nodes[node_under.name].on_rightclick then
				return minetest.registered_nodes[node_under.name].on_rightclick(pointed_thing.under, node_under, placer, itemstack)
			end

			for _,land in ipairs(land_types) do
				if node_above and node_under and node_under.name == "default:"..land then
					minetest.set_node(pointed_thing.under, {name="seaflora:"..land.."_with_"..color.."_"..flora_type})
					itemstack:take_item()
					return itemstack
				end
			end
		end
	})

	if makes_dye then
		minetest.register_craft({
			type = "shapeless",
			output = "dye:"..color.." 4",
			recipe = {"seaflora:"..flora_type.."_"..color},
		})
	end
end

for _,color in ipairs({"red", "green", "blue", "cyan", "magenta", "yellow"}) do
	seaflora.register_flora(color, "coral", 20, 1, 0, true)
end

for _,color in ipairs({"brown", "green"}) do
	seaflora.register_flora(color, "kelp", 20, 1, 10, false)
end

local update_list = {}
minetest.register_on_generated(function(minp, maxp, blockseed)
	local ids = {
		air = minetest.get_content_id("air"),
		ignore = minetest.get_content_id("ignore"),
		water = minetest.get_content_id("default:water_source"),
	}
	for _,land in ipairs(land_types) do
		ids[land] = minetest.get_content_id("default:"..land)
	end

	local x, z = math.ceil((maxp.x - minp.x) / 2 + minp.x), math.ceil((maxp.z - minp.z) / 2 + minp.z)
	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local data = vm:get_data()
	local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
	for x=maxp.x,minp.x,-1 do
		for z=maxp.z,minp.z,-1 do
			for y=maxp.y,minp.y,-1 do
				local vi = area:index(x, y, z)
				local vi_above = area:index(x, y+1, z)
				if ( data[vi] and data[vi_above] ) and ( data[vi] ~= ids.air and data[vi] ~= ids.ignore and data[vi] ~= ids.water and data[vi_above] == ids.water ) then
					local land = minetest.get_name_from_content_id(data[vi])
					if seaflora.registered_spawns[land] then
						if math.random(0, 99) < 1 then -- 1% chance of generating flora
							data[vi] = minetest.get_content_id(seaflora.registered_spawns[land][math.random(1, #seaflora.registered_spawns[land])])
							table.insert(update_list, minetest.pos_to_string({x = x, y = y, z = z}))
						end
					end
				end
			end
		end
	end
	vm:set_data(data)
	vm:write_to_map(data)
end)

local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer >= 1 then
		timer = 0
		if #update_list == 0 then return end
		for k,v in pairs(update_list) do
			local pos = minetest.string_to_pos(v)
			local node = minetest.get_node(pos)
			if node and node.name ~= "ignore" then
				node.param2 = 16
				minetest.swap_node(pos, node)
				update_list[k] = nil
			end
		end
	end
end)

dofile(minetest.get_modpath(minetest.get_current_modname()).."/compat.lua")

