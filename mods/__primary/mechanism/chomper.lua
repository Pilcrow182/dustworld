chomper = {}

chomper.mimic_player = function(pos)
	local player = {
		get_inventory_formspec = function() return end,
		get_look_dir = function() return {x=0,y=0,z=0} end,
		get_look_pitch = function() return 0 end,
		get_look_yaw = function() return end,
		set_look_yaw = function() return end,
		get_player_control = function() return {jump=false,right=false,left=false,LMB=true,RMB=false,sneak=true,aux1=false,down=false,up=false} end,
		get_player_control_bits = function() return end,
		get_player_name = function() return "chomper" end,
		is_player = function() return false end,
		set_inventory_formspec = function() return end,
		set_sky = function() return end,
		get_breath = function() return end,
		set_breath = function() return end,
		set_physics_override = function() return end,
		hud_add = function() return end,
		hud_change = function() return end,
		hud_remove = function() return end,
		hud_get = function() return end,
		hud_set_flags = function() return end,
		hud_get_flags = function() return end,
		hud_set_hotbar_itemcount = function() return end,
		hud_set_hotbar_image = function() return end,
		hud_set_hotbar_selected_image = function() return end,
		hud_replace_builtin = function() return end,
		override_day_night_ratio = function() return end,
		set_eye_offset = function() return end,
		set_local_animation = function() return end,
		getpos = function() return pos end,
		get_armor_groups = function() return end,
		get_hp = function() return 20 end,
		get_inventory = function() return minetest.get_meta(pos):get_inventory() end,
		get_wielded_item = function() return minetest.get_meta(pos):get_inventory():get_stack("main", 1) end,
		get_wield_index = function() return 1 end,
		get_wield_list = function() return end,
		moveto = function() return end,
		punch = function() return end,
		remove = function() return end,
		right_click = function() return end,
		setpos = function() return end,
		set_armor_groups = function() return end,
		set_hp = function() return end,
		set_properties = function() return end,
		set_wielded_item = function (self, newstack) return minetest.get_meta(pos):get_inventory():set_stack("main", 1, newstack) end,
		set_animation = function() return end,
		set_attach = function() return end,
		set_detach = function() return end,
		set_bone_position = function() return end,
	}
	return player
end

local dig_node = function(chomperpos, digpos)
	local chompermeta = minetest.get_meta(chomperpos)
	local chomperinv = chompermeta:get_inventory()

	--check if node exists and is not air/ignore
	local dignode = minetest.get_node(digpos)
	if dignode.name == "air" or dignode.name == "ignore" then
		return
	elseif minetest.registered_nodes[dignode.name] and minetest.registered_nodes[dignode.name].liquidtype ~= "none" then
		return
	end

	--get node definition
	local def = ItemStack({name=dignode.name}):get_definition()
	if not def then
		return
	end

	--handle on_punch callback
	if def.on_punch then
		-- Copy pos and node because callback can modify them
		local pos_copy = {x=digpos.x, y=digpos.y, z=digpos.z}
		local node_copy = {name=node.name, param1=node.param1, param2=node.param2}
		def.on_punch(pos_copy, node_copy, chomper.mimic_player(chomperpos))
	end

	--check node to make sure it is diggable
	if not def.diggable or (def.can_dig and not def.can_dig(digpos, chomper.mimic_player(chomperpos))) then
		return
	end

	--save old meta to table
	local meta = minetest.get_meta(digpos)
	local oldmetadata = meta:to_table()

	--handle node drops
	local facedir = minetest.facedir_to_dir(minetest.get_node(chomperpos).param2)
	local reverse = {x = -facedir.x, y = -facedir.y, z = -facedir.z}
	local connected = minetest.get_node({x = chomperpos.x + reverse.x, y = chomperpos.y + reverse.y, z = chomperpos.z + reverse.z}).name
	local drops = minetest.get_node_drops(dignode.name, "default:pick_mese")
	if minetest.get_item_group(connected, "tube") ~= 0 or minetest.get_item_group(connected, "tubedevice") ~= 0 or minetest.get_item_group(connected, "tubedevice_receiver") ~= 0 then
		for _, dropped_item in ipairs(drops) do
			--add item to pipeworks tube
			local item1 = tube_item({x=chomperpos.x, y=chomperpos.y, z=chomperpos.z}, dropped_item)
			item1:get_luaentity().start_pos = {x=chomperpos.x, y=chomperpos.y, z=chomperpos.z}
			item1:setvelocity(reverse)
			item1:setacceleration({x=0, y=0, z=0})
		end
	else
		for _, dropped_item in ipairs(drops) do
			if chomperinv:room_for_item("main", dropped_item) then
				--add item to chomper's inventory
				chomperinv:add_item("main", dropped_item)
			else
				--drop item if inventory is full
				minetest.add_item(digpos, dropped_item)
			end
		end
	end

	minetest.remove_node(digpos)
	minetest.check_for_falling(digpos)

	--handle post-digging callback
	if def.after_dig_node then
		-- Copy pos and node because callback can modify them
		local pos_copy = {x=digpos.x, y=digpos.y, z=digpos.z}
		local node_copy = {name=node.name, param1=node.param1, param2=node.param2}
		def.after_dig_node(pos_copy, node_copy, oldmetadata, chomper.mimic_player(chomperpos))
	end

	--run digging event callbacks
	for _, callback in ipairs(minetest.registered_on_dignodes) do
		-- Copy pos and node because callback can modify them
		local digpos_copy = {x=digpos.x, y=digpos.y, z=digpos.z}
		local dignode_copy = {name=dignode.name, param1=dignode.param1, param2=dignode.param2}
		callback(digpos_copy, dignode_copy, chomper.mimic_player(chomperpos))
	end
end

toggle_chomper = function(pos, node, turn_on)
	local swapped = node
end

chomper_on = function(pos, node)
	local digdir = minetest.facedir_to_dir(node.param2)
	local digpos = {x = pos.x + digdir.x, y = pos.y + digdir.y, z = pos.z + digdir.z}
	if node.name == "mechanism:chomper" then
		node.name = "mechanism:chomper_on"
		minetest.swap_node(pos, node)
		dig_node(pos, digpos)
	end
end

chomper_off = function(pos, node)
	if node.name == "mechanism:chomper_on" then
		node.name = "mechanism:chomper"
		minetest.swap_node(pos, node)
	end
end

minetest.register_node("mechanism:chomper", {
	description = "Chomper",
	tiles = {
			"mechanism_chomper_top.png",
			"mechanism_chomper_bottom.png",
			"mechanism_chomper_right.png",
			"mechanism_chomper_left.png",
			"mechanism_chomper_back.png",
			"mechanism_chomper_front.png"
	},
	paramtype2 = "facedir",
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2,mesecon=2},
	mesecons = {effector={action_on=chomper_on, action_off=chomper_off}},
	on_construct = function(pos)
		local inventory = 
			"size[10,9]"..
			"list[current_name;main;1,0;8,4;]"..
			"list[current_player;main;0,5;10,4;]"

		local meta = minetest.get_meta(pos)
		meta:set_string("formspec",inventory)
		local inv = meta:get_inventory()
		inv:set_size("main", 8*4)
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end
})

minetest.register_node("mechanism:chomper_on", {
	description = "Chomper",
	tiles = {
			"mechanism_chomper_top_on.png",
			"mechanism_chomper_bottom_on.png",
			"mechanism_chomper_right_on.png",
			"mechanism_chomper_left_on.png",
			"mechanism_chomper_back_on.png",
			"mechanism_chomper_front_on.png"
	},
	paramtype2 = "facedir",
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2,mesecon=2,not_in_creative_inventory=1},
	mesecons= {effector={action_on=chomper_on, action_off=chomper_off}},
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,
	drop = "mechanism:chomper"
})

minetest.register_craft({
	type = 'shapeless',
	output = 'mechanism:chomper',
	recipe = {'pipeworks:nodebreaker_off', 'default:chest'}
})

