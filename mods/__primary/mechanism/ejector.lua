-- initial variables

local ejector = {}

local getdir = {
	[0] = {{x= 0, y= 0, z= 1}, "red"    }, -- north
	[1] = {{x= 0, y= 0, z=-1}, "cyan"   }, -- south
	[2] = {{x= 1, y= 0, z= 0}, "green"  }, -- east
	[3] = {{x=-1, y= 0, z= 0}, "magenta"}, -- west
	[4] = {{x= 0, y= 1, z= 0}, "blue"   }, -- up
	[5] = {{x= 0, y=-1, z= 0}, "yellow" }  -- down
}


-- node functions

ejector.make_inventory = function(pos, pagenum)
	local page = 
	"label[0.4,0.1;Inventory]".."button[2,0;2,1;page1;Configuration]"..
	"list[current_name;main;2.95,1.5;4,3;]"
	if pagenum == 1 then
		page = 
		"button[0,0;2,1;page0;Inventory]".."label[2.15,0.1;Configuration]"..
		"list[current_name;red;0.75,1.5;4,1;]".."image[0.5,1.25;5.4,1.6;mechanism_ejector_cfg_red.png]"..
		"list[current_name;cyan;5.05,1.5;4,1;]".."image[4.8,1.25;5.4,1.6;mechanism_ejector_cfg_cyan.png]"..
		"list[current_name;green;0.75,2.85;4,1;]".."image[0.5,2.6;5.4,1.6;mechanism_ejector_cfg_green.png]"..
		"list[current_name;magenta;5.05,2.85;4,1;]".."image[4.8,2.6;5.4,1.6;mechanism_ejector_cfg_magenta.png]"..
		"list[current_name;blue;0.75,4.2;4,1;]".."image[0.5,3.95;5.4,1.6;mechanism_ejector_cfg_blue.png]"..
		"list[current_name;yellow;5.05,4.2;4,1;]".."image[4.8,3.95;5.4,1.6;mechanism_ejector_cfg_yellow.png]"
	end

	ejector.inv_formspec = 
		"size[10,10]"..
		page..
		"list[current_player;main;0,6;10,4;]"
	local meta = minetest.get_meta(pos)
	meta:set_string("formspec",ejector.inv_formspec)
	meta:set_string("infotext", "Ejector")
	local inv = meta:get_inventory()
	inv:set_size("main", 4*3)
	inv:set_size("red", 4*1)
	inv:set_size("cyan", 4*1)
	inv:set_size("green", 4*1)
	inv:set_size("magenta", 4*1)
	inv:set_size("blue", 4*1)
	inv:set_size("yellow", 4*1)
end

ejector.dig_ejector = function(pos,player)
	local inv = minetest.get_meta(pos):get_inventory()
	for _,label in ipairs({"main", "red", "cyan", "green", "magenta", "blue", "yellow"}) do
		if not inv:is_empty(label) then
			minetest.chat_send_player(player:get_player_name(), "Cannot dig ejector. "..label.." inventory not empty.")
			return false
		end
	end
	return true
end


-- registry

minetest.register_node("mechanism:ejector", {
	description = "Ejector",
	drawtype = "nodebox",
	tiles = {
		"mechanism_ejector_face_up.png",
		"mechanism_ejector_face_down.png",
		"mechanism_ejector_face_east.png",
		"mechanism_ejector_face_west.png",
		"mechanism_ejector_face_north.png",
		"mechanism_ejector_face_south.png"
	},
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	node_box = {
		type = "fixed",
		fixed = {
			{-4/16, -4/16, -4/16,  4/16,  4/16,  4/16}, --center
			{-3/16,  4/16, -3/16,  3/16,  6/16,  3/16}, --up1
			{-2/16,  6/16, -2/16,  2/16,  8/16,  2/16}, --up2
			{-3/16, -6/16, -3/16,  3/16, -4/16,  3/16}, --down1
			{-2/16, -8/16, -2/16,  2/16, -6/16,  2/16}, --down2
			{-3/16, -3/16,  4/16,  3/16,  3/16,  6/16}, --north1
			{-2/16, -2/16,  6/16,  2/16,  2/16,  8/16}, --north2
			{-3/16, -3/16, -6/16,  3/16,  3/16, -4/16}, --south1
			{-2/16, -2/16, -8/16,  2/16,  2/16, -6/16}, --south2
			{ 4/16, -3/16, -3/16,  6/16,  3/16,  3/16}, --east1
			{ 6/16, -2/16, -2/16,  8/16,  2/16,  2/16}, --east2
			{-6/16, -3/16, -3/16, -4/16,  3/16,  3/16}, --west1
			{-8/16, -2/16, -2/16, -6/16,  2/16,  2/16}, --west2
		},
	},
	on_construct = function(pos) return ejector.make_inventory(pos) end,
	on_receive_fields = function(pos, formname, fields, sender)
		if fields.page0 then ejector.make_inventory(pos, 0) end
		if fields.page1 then ejector.make_inventory(pos, 1) end
	end,
	can_dig = function(pos,player) return ejector.dig_ejector(pos,player) end,
	groups = {hopper=2,cracky=2,oddly_breakable_by_hand=1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	output = 'mechanism:ejector',
	recipe = {
		{'', 'default:diamond', ''},
		{'default:copper_ingot', 'mechanism:hopper', 'default:steel_ingot'},
		{'', 'default:mese_crystal', ''},
	}
})

minetest.register_craft({
	output = 'mechanism:ejector',
	recipe = {
		{'', 'default:diamond', ''},
		{'default:copper_ingot', 'mechanism:reverse_hopper', 'default:steel_ingot'},
		{'', 'default:mese_crystal', ''},
	}
})


-- ABM functions

ejector.push = function(dst, name, wear)
	local dstinv, dstlabel, dstlist, is_hopper, dstms, dstmeta, dstitem, dstamount, dstwear = mechanism.check_storage(dst, {"main", "src"})
	local drop_items = not ( minetest.registered_nodes[minetest.get_node(dst).name].walkable )

	if not ( dstlabel or drop_items or dstms ~= 0 ) then return false end

	if drop_items then
		minetest.add_item(dst, {name=name, count=1, wear=wear})
		return true
	end

	if dstlabel and dstinv:room_for_item(dstlabel, {name=name, count=1, wear=wear}) then
		dstinv:add_item(dstlabel, {name=name, count=1, wear=wear})
		minetest.get_node_timer(dst):start(1.0)
		return true
	elseif dstms ~= 0 and ( dstitem == "" or ( dstitem == name and dstwear == wear ) ) and dstamount + 1 <= 9999 then
		dstmeta:set_string("stored", name)
		dstmeta:set_string("amount", tostring(dstamount+1))
		dstmeta:set_string("wear", wear)
		dstmeta:set_string("infotext", name.." "..dstamount+1)
		return true
	else
		return false
	end
end

ejector.get_table = function(inv, labels_list)
	local invlist = {}
	local invsize = 0
	local invtable = {}
	local itemname = ""
	local itemcount = 0
	local itemtotal = 0

	for _,label in ipairs(labels_list) do
		invlist = inv:get_list(label)
		invsize = inv:get_size(label)
		for i=1,invsize do
			itemname = invlist[i]:get_name()
			itemcount = invlist[i]:get_count()
			if itemcount > 0 then
				itemtotal = invtable[itemname] or 0
				invtable[itemname] = itemtotal + itemcount
			end
		end
	end

	return invtable
end

ejector.get_slots_by_name = function(inv, name, labels_list)
	local invlist = {}
	local invsize = 0
	local slots = {}
	local itemname = ""

	for _,label in ipairs(labels_list) do
		invlist = inv:get_list(label)
		invsize = inv:get_size(label)
		for i=1,invsize do
			itemname = invlist[i]:get_name()
			if itemname == name then
				table.insert(slots, i)
			end
		end
	end

	return slots
end


-- ABMs

minetest.register_abm({
	nodenames = {"mechanism:ejector"},
	interval = 2,
	chance = 1,
	action = function(pos)
		local inv = minetest.get_meta(pos):get_inventory()
		local invsize = inv:get_size("main")
		local invtable = ejector.get_table(inv, {"main"})
		local outtable = ejector.get_table(inv, {"red", "cyan", "green", "magenta", "blue", "yellow"})

		local newout = {}
		for item,_ in pairs(invtable) do
			if not outtable[item] then newout[item] = true end
		end

		if minetest.serialize(newout) ~= "return {}" then
			for item,_ in pairs(newout) do
				local invlist = inv:get_list("main")
				local slots_with_item = ejector.get_slots_by_name(inv, item, {"main"})
				if #slots_with_item > 0 and not outtable[item] then
					local count, wear = invlist[slots_with_item[1]]:get_count(), invlist[slots_with_item[1]]:get_wear()
					for d = 0, 5 do
						local dir, color = getdir[d][1], getdir[d][2]
						if inv:room_for_item(color, {name=item, count=1, wear=wear}) then
							local dst = {x = pos.x + dir.x, y = pos.y + dir.y, z = pos.z + dir.z}
							local dstinv, dstlabel, dstlist, is_hopper, dstms, dstmeta, dstitem, dstamount = mechanism.check_storage(dst, {"main", "src"})

							local ms_avail = false
							if dstms ~= 0 and ( dstitem == "" or dstitem == item ) then ms_avail = true end

							if is_hopper == 0 and ( ms_avail or ( dstlabel and dstinv:room_for_item(dstlabel, {name=item, count=1, wear=wear}) ) ) then
								inv:add_item(color, {name=item, count=1, wear=wear})
								inv:set_stack("main", slots_with_item[1], {name=item, count=count-1})
								invtable = ejector.get_table(inv, {"main"})
								outtable = ejector.get_table(inv, {"red", "cyan", "green", "magenta", "blue", "yellow"})
								break
							end
						end
					end
				end
			end
		end

		for name, count in pairs(outtable) do
			local end_loop = false
			while invtable[name] and invtable[name] >= count and not end_loop do
				local output = {}
				local slots_with_item = ejector.get_slots_by_name(inv, name, {"main"})
				for d = 0, 5 do
					local dir, color = getdir[d][1], getdir[d][2]
					local dst = {x = pos.x + dir.x, y = pos.y + dir.y, z = pos.z + dir.z}
					local push = ejector.get_table(inv, {color})[name] or 0
					for index,slot in pairs(slots_with_item) do
						local invlist = inv:get_list("main")
						local count, wear = invlist[slot]:get_count(), invlist[slot]:get_wear()
						local ejected = false
						while slot and push > 0 and count > 0 do
							ejected = ejector.push(dst, name, wear)
							if ejected then
								inv:set_stack("main", slot, {name=name, count=count-1, wear=wear})
								push, count = push - 1, count - 1
								if count == 0 then slots_with_item[index] = nil end
							elseif count > 0 then
								end_loop = true
								break
							end
						end
					end
				end
				invtable = ejector.get_table(inv, {"main"})
			end
		end
	end
})
