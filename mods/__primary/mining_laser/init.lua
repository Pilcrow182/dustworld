mining_laser = {}

mining_laser.dig = function(machinepos, digpos)
	local digger = {
		is_player = function() return false end,
		get_player_name = function() return "Mining Laser" end,
		getpos = function() return machinepos end,
		get_player_control = function() return {jump=false,right=false,left=false,LMB=false,RMB=false,sneak=false,aux1=false,down=false,up=false} end,
		get_inventory = function() return minetest.get_meta(machinepos):get_inventory() end,
	}

	local node = minetest.get_node(digpos)
	if not node then return false end

	--check node to make sure it is solid
	for _,checkname in pairs({"air", "ignore", "mining_laser:beam"}) do if node.name == checkname then return false end end
	if minetest.registered_nodes[node.name].liquidtype ~= "none" then return false end

	--check node to make sure it is diggable
	local def = ItemStack({name=node.name}):get_definition()
	if #def ~= 0 and not def.diggable or (def.can_dig and not def.can_dig(digpos, digger)) then --node is not diggable
		return false
	end

	--handle node drops
	local inv = minetest.get_meta(machinepos):get_inventory()
	local drops = minetest.get_node_drops(node.name, "default:pick_mese")
	for _, dropped_item in ipairs(drops) do
		if inv:room_for_item("main", dropped_item) then
			inv:add_item("main", dropped_item)
		else
			minetest.add_item({x = machinepos.x, y = machinepos.y - 1, z = machinepos.z}, dropped_item)
		end
	end

	minetest.remove_node(digpos)

	--handle post-digging callback
	if def.after_dig_node then
		-- Copy pos and node because callback can modify them
		local pos_copy = {x=digpos.x, y=digpos.y, z=digpos.z}
		local node_copy = {name=node.name, param1=node.param1, param2=node.param2}
		def.after_dig_node(pos_copy, node_copy, oldmetadata, digger)
	end

	--run digging event callbacks
	for _, callback in ipairs(minetest.registered_on_dignodes) do
		-- Copy pos and node because callback can modify them
		local pos_copy = {x=digpos.x, y=digpos.y, z=digpos.z}
		local node_copy = {name=node.name, param1=node.param1, param2=node.param2}
		callback(pos_copy, node_copy, digger)
	end
	return true
end

mining_laser.fabricate = function(pos, dig_table, count)
	local items = {}
	for k, v in pairs(dig_table) do
		if k ~= "__total" then
			table.insert(items, {k, tonumber(v)})
		end
	end
-- 	table.sort(items, function(a, b) return a[2] < b[2] end)
-- 	minetest.chat_send_all("items = "..minetest.serialize(items))
-- 	print("items = "..minetest.serialize(items))

	if #items < 1 then
-- 		minetest.chat_send_all("ERROR: fabricate was called, but no items have been dug yet!")
		return false
	end

	for c = 1, count do
		local rarity = math.random(1, tonumber(dig_table["__total"]))
		local processed = 0
		local name = ""
		for d = 1, #items do
			processed = processed + items[d][2]
			if processed >= rarity then name = items[d][1] break end
		end
-- 		if name == "" then print("ERROR: fabricate loop completed, but no available was found!") end
-- 		minetest.chat_send_all("fabricating "..name)
-- 		print("fabricating "..name)

		local inv = minetest.get_meta(pos):get_inventory()
		local drops = minetest.get_node_drops(name, "default:pick_mese")
		for _, dropped_item in ipairs(drops) do
			if inv:room_for_item("main", dropped_item) then
				inv:add_item("main", dropped_item)
			else
				minetest.add_item({x = pos.x, y = pos.y - 1, z = pos.z}, dropped_item)
			end
		end
	end
end

mining_laser.consume_fuel = function(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local time_left = (tonumber(meta:get_string("burning")) or 0)
	local fuel_stack = inv:get_stack("fuel", 1)
	local fuel_value = minetest.get_craft_result({method="fuel",width=1,items={fuel_stack}}).time
-- 	minetest.chat_send_all("time_left is "..time_left)
	if time_left >= 4 then
		time_left = time_left - 4
-- 		minetest.chat_send_all("subtracted 4 from time_left (now "..time_left..")")
		meta:set_string("burning", time_left)
		return true
	elseif fuel_value > 0 then
		while time_left < 4 and fuel_stack:get_count() > 0 do
			time_left = time_left + fuel_value
-- 			minetest.chat_send_all("added "..fuel_value.." to time_left (now "..time_left..")")
			fuel_stack:take_item(1)
			inv:set_stack("fuel", 1, fuel_stack)
		end
		if time_left >= 4 then
			time_left = time_left - 4
-- 			minetest.chat_send_all("subtracted 4 from time_left (now "..time_left..")")
			meta:set_string("burning", time_left)
			return true
		else
			meta:set_string("burning", time_left)
-- 			minetest.chat_send_all("time_left is less than 4 (now "..time_left..") and fuel wasn't sufficient")
			return false
		end
	else
-- 		minetest.chat_send_all("time_left is less than 4 (now "..time_left..") and no fuel to keep going")
		return false
	end
end

mining_laser.form_beam = function(laserpos)
	local meta = minetest.get_meta(laserpos)
	local beampos = {x = laserpos.x, y = laserpos.y - 1, z = laserpos.z}
	local beam_end = minetest.deserialize(meta:get_string("beam_end")) or beampos
	while beampos.y >= beam_end.y do
		local oldnode = minetest.get_node(beampos).name
		if oldnode == "air" then
			minetest.add_node(beampos, {name="mining_laser:beam"})
			beampos.y = beampos.y-1
		elseif oldnode == "mining_laser:beam" then
			beampos.y = beampos.y-1
		elseif oldnode == "ignore" then
			break
		else
-- 			minetest.chat_send_all("blockage found; setting new beam end")
			beam_end = {x = beampos.x, y = beampos.y + 1, z = beampos.z}
			meta:set_string("beam_end", minetest.serialize(beam_end))
			break
		end
	end
end

mining_laser.dig_next_area = function(pos)
	if not mining_laser.consume_fuel(pos) then
		minetest.swap_node(pos, {name = "mining_laser:laser"})
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", mining_laser.get_formspec("off"))
		local beam = {x = pos.x, y = pos.y - 1, z = pos.z}
		while minetest.get_node(beam).name == "mining_laser:beam" do
			minetest.remove_node(beam)
			beam.y = beam.y-1
		end
		return
	end

	local meta = minetest.get_meta(pos)
	local exec = (tonumber(meta:get_string("exec")) or 0) + 1
	local dig_table = minetest.deserialize(meta:get_string("dig_table")) or {}
	local old_end = minetest.deserialize(meta:get_string("beam_end")) or pos
	if old_end.x ~= pos.x or old_end.z ~= pos.z then old_end = pos end
	local beam_end = {x=old_end.x, y=old_end.y-1, z=old_end.z}
	meta:set_string("exec", exec)

-- 	if minetest.get_node({x=beam_end.x, y=beam_end.y-2, z=beam_end.z}).name == "ignore" then
	if minetest.find_node_near(beam_end, 3, {"ignore"}) then
-- 		minetest.chat_send_all("cannot dig next area. fabricating items from dig_table instead.")
		mining_laser.fabricate(pos, dig_table, 9)
		return
	end

-- 	minetest.chat_send_all("digging at level "..beam_end.y)
	for x_offset=-1,1 do for z_offset=-1,1 do
		local digpos = {x=beam_end.x+x_offset, y=beam_end.y, z=beam_end.z+z_offset}
		local nname = minetest.get_node(digpos).name
		local ndef = minetest.registered_nodes[nname]

		if not mining_laser.dig(pos, digpos) then
			mining_laser.fabricate(pos, dig_table, 1)
		elseif ndef.diggable and ndef.is_ground_content then
			dig_table[nname] = tostring((dig_table[nname] or 0) + 1)
			dig_table["__total"] = tostring((dig_table["__total"] or 0) + 1)
		end
	end end
	meta:set_string("dig_table", minetest.serialize(dig_table))

-- 	minetest.chat_send_all("----------------------------- CONTENTS OF DIG_TABLE -----------------------------")
-- 	print("----------------------------- CONTENTS OF DIG_TABLE -----------------------------")
-- 	minetest.chat_send_all(minetest.serialize(dig_table))
-- 	print(minetest.serialize(dig_table))

	if minetest.registered_nodes[minetest.get_node(beam_end).name].buildable_to then
		meta:set_string("beam_end", minetest.serialize(beam_end))
		mining_laser.form_beam(pos)
	end
end

mining_laser.check_beam_source = function(pos)
	local above = minetest.get_node({x=pos.x, y=pos.y+1, z=pos.z})
	if above.name ~= "ignore" and string.find(above.name, "mining_laser") == nil then
		while minetest.get_node(pos).name == "mining_laser:beam" do
			minetest.remove_node(pos)
			pos.y = pos.y-1
		end
	end
end

mining_laser.get_formspec = function(state)
	local formspec =
		"size[10,9]"..
		"list[current_name;main;1,0;8,2;]"..
		"label[3.2,2.6;Fuel:]"..
		"list[current_name;fuel;3,3;1,1;]"..
		"label[6.1,2.6;Power:]"..
		"image_button[6,3;1,1;mining_laser_power_"..state..".png;power;]"..
		"list[current_player;main;0,5;10,4;]"
	return formspec
end

minetest.register_node("mining_laser:laser", {
	description = "Mining Laser",
	sunlight_propagates = true,
	paramtype = "light",
	tiles = {
		"mining_laser_laser_top_off.png",
		"mining_laser_laser_bottom_off.png",
		"mining_laser_laser_side.png",
	},
	groups = {cracky=2,oddly_breakable_by_hand=1},
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", mining_laser.get_formspec("off"))
		meta:set_string("infotext", "Mining Laser")
		local inv = meta:get_inventory()
		inv:set_size("main", 8*2)
		inv:set_size("fuel", 1*1)
	end,
	on_receive_fields = function(pos, formname, fields, sender)
		if fields.power then
			minetest.swap_node(pos, {name = "mining_laser:laser_on"})
			local meta = minetest.get_meta(pos)
			meta:set_string("formspec", mining_laser.get_formspec("on"))
			mining_laser.form_beam(pos)
		end
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main") and inv:is_empty("fuel")
	end,
})

minetest.register_node("mining_laser:laser_on", {
	description = "Mining Laser (on)",
	sunlight_propagates = true,
	paramtype = "light",
	tiles = {
		"mining_laser_laser_top_on.png",
		"mining_laser_laser_bottom_on.png",
		"mining_laser_laser_side.png",
	},
	groups = {cracky=2,oddly_breakable_by_hand=1,not_in_creative_inventory=1},
	drop = "mining_laser:laser",
	on_receive_fields = function(pos, formname, fields, sender)
		if fields.power then
			minetest.swap_node(pos, {name = "mining_laser:laser"})
			local meta = minetest.get_meta(pos)
			meta:set_string("formspec", mining_laser.get_formspec("off"))
			pos.y = pos.y - 1
			if minetest.get_node(pos).name == "mining_laser:beam" then
				minetest.remove_node(pos)
				pos.y = pos.y - 1
				mining_laser.check_beam_source(pos)
			end
		end
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main") and inv:is_empty("fuel")
	end,
})

minetest.register_node("mining_laser:beam", {
	description = "Laser Beam",
	walkable = false,
	diggable = false,
	pointable = false,
	buildable_to = true,
	air_equivalent = false,
	sunlight_propagates = true,
	paramtype = "light",
	tiles = { "mining_laser_beam.png" },
	drawtype = "plantlike",
	after_dig_node = function(pos, oldnode, oldmetadata, digger) return mining_laser.check_beam_source({x = pos.x, y = pos.y - 1, z = pos.z}) end,
	groups = {not_in_creative_inventory=1},
	drop = ""
})

minetest.register_craft({
	output = 'mining_laser:laser',
	recipe = {
		{'default:copperblock', 'default:mese', 'default:copperblock'},
		{'hoverbot:crystal_cpu', 'hoverbot:hoverbot', 'hoverbot:crystal_cpu'},
		{'default:steelblock', 'default:diamondblock', 'default:steelblock'},
	}
})

minetest.register_abm({
	nodenames = {"mining_laser:laser_on"},
	interval = 4,
	chance = 1,
	action = function(pos)
		minetest.after(0, function() mining_laser.dig_next_area(pos) end)
	end
})

minetest.register_abm({
	nodenames = {"mining_laser:beam"},
	interval = 4,
	chance = 1,
	action = function(pos)
		minetest.after(0, function() mining_laser.check_beam_source(pos) end)
	end
})

minetest.register_abm({
	nodenames = {"mining_laser:beam"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		minetest.after(0, function()
			for _,object in ipairs(minetest.get_objects_inside_radius(pos, 0.7)) do
				if not object:is_player() then
					for delay = 0, 8, 2 do
						minetest.after(tonumber("0."..delay), function()
							if object then object:setvelocity({x=0, y=10, z=0}) end
						end)
					end
				end

				if object:get_hp() > 0 then
					object:set_hp(object:get_hp()-2)
				elseif not object:is_player() and object:get_hp() <= 0 and object:get_luaentity().name ~= "__builtin:item" then
					object:remove()
				end
			end
		end)
	end
})
