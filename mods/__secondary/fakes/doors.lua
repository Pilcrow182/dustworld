fakes.make_doors = function(name, tiles)
	if string.find(name, "__camodoor") then return end

	local register_door = function(doorname, doortiles, nodebox, swapname)
		minetest.register_node(":"..doorname,{
			description = "Camo Door ("..name..")",
			inventory_image = "fakes_camodoor_inv.png",
			wield_image = "fakes_camodoor_inv.png",
			tiles = tiles,
			drawtype="nodebox",
			paramtype = "light",
			paramtype2 = "facedir",
			node_box = {type = "fixed", fixed = {nodebox}},
			on_rightclick = function(pos, node, clicker, itemstack)
				if not clicker then return end
				local p2 = minetest.get_node(pos).param2
				minetest.set_node(pos, {name=swapname, param2=p2})
			end,
			groups = {dig_immediate=2, not_in_creative_inventory=1},
			sounds = default.node_sound_leaves_defaults(),
			drop="fakes:camodoor"
		})
	end

	register_door(name.."__camodoor", tiles, {-8/16,-8/16,-8/16,8/16,24/16,-6/16}, name.."__camodoor_open")
	register_door(name.."__camodoor_open", tiles, {-8/16,-8/16,-8/16,-6/16,24/16,8/16}, name.."__camodoor")
end

minetest.register_craftitem("fakes:camodoor", {
	description = "Camo Door",
	inventory_image = "fakes_camodoor_inv.png",
	wield_image = "fakes_camodoor_inv.png",
	wield_scale = {x=1,y=1,z=1+1/16},
	liquids_pointable = true,
	on_place = function(itemstack, placer, pointed_thing)
		if not minetest.registered_nodes[minetest.get_node(pointed_thing.under).name] then
			return itemstack
		elseif minetest.registered_nodes[minetest.get_node(pointed_thing.under).name].on_rightclick and not placer:get_player_control().sneak then
			return minetest.registered_nodes[minetest.get_node(pointed_thing.under).name].on_rightclick(pointed_thing.under, minetest.get_node(pointed_thing.under), placer, itemstack)
		end
		local above = pointed_thing.above
		local under = pointed_thing.under
		local a2 = {x = above.x, y = above.y + 1, z = above.z}
		if minetest.registered_nodes[minetest.get_node(above).name].buildable_to and minetest.registered_nodes[minetest.get_node(a2).name].buildable_to then
			local n = minetest.get_node(under)
			local nn = n.name:gsub("__camodoor_open", ""):gsub("__camodoor", ""):gsub("__camowindow", ""):gsub("__fake", "")

			if not minetest.registered_nodes[nn.."__camodoor"] then
				print("WARNING: "..nn.."__camodoor does not exist!")
				minetest.chat_send_all("that node is unsupported by the fakes mod")
				return
			end

			local p2 = n.param2
			
			if not string.find(n.name, "__camodoor") then
				local lookdir = placer:get_look_dir()
				local placedir = {y=0}

				if math.abs(lookdir.z) > math.abs(lookdir.x) then
					placedir.x = 0
					if lookdir.z < 0 then placedir.z = -1 else placedir.z = 1 end
				else
					if lookdir.x < 0 then placedir.x = -1 else placedir.x = 1 end
					placedir.z = 0
				end
				p2 = minetest.dir_to_facedir(placedir, false)
			end

			minetest.add_node(above, {name = nn.."__camodoor", param2 = p2})
			minetest.add_node(a2, {name = "air"})

			if not minetest.setting_getbool("creative_mode") then
				itemstack:take_item()
			end
		end
		return itemstack
	end
})

minetest.register_craft({
	output = "fakes:camodoor",
	recipe = {
		{"fakes:camoblock", "fakes:camoblock"},
		{"fakes:camoblock", "fakes:camoblock"},
		{"fakes:camoblock", "fakes:camoblock"},
	}
})

minetest.register_craft({
	output = "fakes:camoblock 6",
	recipe = {
		{"fakes:camodoor"},
	}
})
