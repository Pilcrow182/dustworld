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
	"list[current_name;main;2.45,1.5;4,3;]"
	if pagenum == 1 then
		page = 
		"button[0,0;2,1;page0;Inventory]".."label[2.15,0.1;Configuration]"..
		"list[current_name;red;0.25,1.5;4,1;]".."image[0,1.25;5.4,1.6;mechanism_ejector_cfg_red.png]"..
		"list[current_name;cyan;4.55,1.5;4,1;]".."image[4.3,1.25;5.4,1.6;mechanism_ejector_cfg_cyan.png]"..
		"list[current_name;green;0.25,2.85;4,1;]".."image[0,2.6;5.4,1.6;mechanism_ejector_cfg_green.png]"..
		"list[current_name;magenta;4.55,2.85;4,1;]".."image[4.3,2.6;5.4,1.6;mechanism_ejector_cfg_magenta.png]"..
		"list[current_name;blue;0.25,4.2;4,1;]".."image[0,3.95;5.4,1.6;mechanism_ejector_cfg_blue.png]"..
		"list[current_name;yellow;4.55,4.2;4,1;]".."image[4.3,3.95;5.4,1.6;mechanism_ejector_cfg_yellow.png]"
	end

	ejector.inv_formspec = 
		"size[9,10]"..
		page..
		"list[current_player;main;0.45,6;8,4;]"
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

ejector.push = function(dst, inv, index, name, count, wear)
	local dstinv, dstlabel, dstlist, is_hopper, dstms, dstmeta, dstitem, dstamount, dstwear = mechanism.check_storage(dst, {"main", "src"})
	local drop_items = not ( minetest.registered_nodes[minetest.get_node(dst).name].walkable )

	if not ( dstlabel or drop_items or dstms ~= 0 ) then return count end

	if drop_items then
-- 		minetest.chat_send_all("ejector: dropping "..name.." into air at"..minetest.pos_to_string(dst)..", name = "..minetest.get_node(dst).name)
		minetest.add_item(dst, {name=name, count=1, wear=wear})
		inv:set_stack("main", index, nil)
		return count-1
	end

	if dstlabel and dstinv:room_for_item(dstlabel, {name=name, count=1, wear=wear}) then
-- 		minetest.chat_send_all("ejector: injecting "..name.." into inventory at "..minetest.pos_to_string(dst)..", name = "..minetest.get_node(dst).name)
		dstinv:add_item(dstlabel, {name=name, count=1, wear=wear})
		inv:set_stack("main", index, {name=name, count=count-1, wear=wear})
		return count-1
	elseif dstms ~= 0 and ( dstitem == "" or ( dstitem == name and dstwear == wear ) ) and dstamount + 1 <= 9999 then
-- 		minetest.chat_send_all("ejector: injecting "..name.." into metastorage at "..minetest.pos_to_string(dst)..", name = "..minetest.get_node(dst).name)
		dstmeta:set_string("stored", name)
		dstmeta:set_string("amount", tostring(dstamount+1))
		dstmeta:set_string("wear", wear)
		dstmeta:set_string("infotext", name.." "..dstamount+1)
		inv:set_stack("main", index, {name=name, count=count-1, wear=wear})
		return count-1
	else
		return count
	end
end


-- ABMs

minetest.register_abm({
	nodenames = {"mechanism:ejector"},
	interval = 2,
	chance = 1,
	action = function(pos)
		local inv = minetest.get_meta(pos):get_inventory()
		local invlist = inv:get_list("main")
		local invsize = inv:get_size("main")
		for i=1,invsize do
			local name, count, wear = invlist[i]:get_name(), invlist[i]:get_count(), invlist[i]:get_wear()
			if name ~= nil and name ~= "" then
				local ejectable = false
				local is_available = {}
				for c = 1,count do
					if count <= 0 then break end
					for facedir = 0, 5 do
						local dir, color = getdir[facedir][1], getdir[facedir][2]
						local dst = {x = pos.x + dir.x, y = pos.y + dir.y, z = pos.z + dir.z}
						local outlist = inv:get_list(color)
						local outsize = inv:get_size(color)
						for j=1,outsize do
							local outname = outlist[j]:get_name()
							if outname == name then
								ejectable = true
								outstack = outlist[j]:get_count()
								for k=1,outstack do
									count = ejector.push(dst, inv, i, name, count, wear)
									if count <= 0 then break end
								end
							end
							if outlist[j]:is_empty() then is_available[color] = true end
							if count <= 0 then break end
						end
						if count <= 0 then break end
					end
					if ejectable == false then
						for facedir = 0, 5 do
							local dir, color = getdir[facedir][1], getdir[facedir][2]
							local dst = {x = pos.x + dir.x, y = pos.y + dir.y, z = pos.z + dir.z}
							local dstinv, dstlabel, dstlist, is_hopper, dstms, dstmeta, dstitem, dstamount = mechanism.check_storage(dst, {"main", "src"})
							local stack = inv:get_stack("main", i):to_table()

							local ms_avail = false
							if dstms ~= 0 and ( dstitem == "" or dstitem == stack.name ) then ms_avail = true end

							if is_hopper == 0 and is_available[color] and ( dstlabel or ms_avail ) then
								inv:add_item(color, {name=stack.name, count=1, wear=stack.wear})
								inv:set_stack("main", i, {name=stack.name, count=stack.count-1})
								count = count - 1
								break
							end
						end
					end
					if count <= 0 then break end
				end
			end
		end
	end
})
