local function is_node(pos)
	if pos == nil then
		return false
	else
		return true
	end
end

minetest.register_craftitem("admin_wands:metadata", {
	description = "Wand of node metadata",
	inventory_image = "admin_wands_metadata.png",
	wield_image = "admin_wands_metadata.png",
	wield_scale = {x=1,y=1,z=1+1/16},
	liquids_pointable = true,
	on_use = function(itemstack, user, pointed_thing)
		if is_node(pointed_thing.under) then
			local meta = minetest.get_meta(pointed_thing.under)
			debug.message("METADATA:: name:: "..minetest.get_node(pointed_thing.under).name, "all")
			debug.message("METADATA:: data:: "..dump(meta:to_table()), "all")
			debug.message("METADATA:: param1:: "..minetest.get_node(pointed_thing.under).param1, "all")
			debug.message("METADATA:: param2:: "..minetest.get_node(pointed_thing.under).param2, "all")
			if minetest.registered_nodes[minetest.get_node(pointed_thing.under).name] then
				debug.message("METADATA:: paramtype2:: "..minetest.registered_nodes[minetest.get_node(pointed_thing.under).name].paramtype2, "all")
				debug.message("METADATA:: drawtype:: "..minetest.registered_nodes[minetest.get_node(pointed_thing.under).name].drawtype, "all")
			end
		end
	end
})

minetest.register_craftitem("admin_wands:removal", {
	description = "Wand of node removal",
	inventory_image = "admin_wands_removal.png",
	wield_image = "admin_wands_removal.png",
	wield_scale = {x=1,y=1,z=1+1/16},
	liquids_pointable = true,
	on_use = function(itemstack, user, pointed_thing)
		if is_node(pointed_thing.under) then
			debug.message(user:get_player_name().." removed node "..minetest.get_node(pointed_thing.under).name.." at position "..minetest.pos_to_string(pointed_thing.under), "all")
			minetest.set_node(pointed_thing.under, {name="air"})
		end
	end
})

minetest.register_craftitem("admin_wands:ownership", {
	description = "Wand of node ownership",
	inventory_image = "admin_wands_ownership.png",
	wield_image = "admin_wands_ownership.png",
	wield_scale = {x=1,y=1,z=1+1/16},
	liquids_pointable = true,
	on_use = function(itemstack, user, pointed_thing)
		if is_node(pointed_thing.under) then
			local meta = minetest.get_meta(pointed_thing.under)
			if meta:get_string("doors_owner") ~= "" then
				meta:set_string("doors_owner", user:get_player_name())
				meta:set_string("infotext", "Owned by "..user:get_player_name())
			elseif meta:get_string("owner") ~= "" then
				meta:set_string("owner", user:get_player_name())
				meta:set_string("infotext", "Locked Chest? (owned by "..user:get_player_name()..")")
			else
				debug.message("ERROR: No owner found for "..minetest.get_node(pointed_thing.under).name, "all")
			end
		end
	end
})

minetest.register_craftitem("admin_wands:rotation", {
	description = "Wand of node rotation",
	inventory_image = "admin_wands_rotation.png",
	wield_image = "admin_wands_rotation.png",
	wield_scale = {x=1,y=1,z=1+1/16},
	liquids_pointable = true,
	on_use = function(itemstack, user, pointed_thing)
		if is_node(pointed_thing.under) then
			local node = minetest.get_node(pointed_thing.under)
			local meta = minetest.get_meta(pointed_thing.under)
			local meta0 = meta:to_table()
			local param2 = node.param2

			param2 = param2 + 1
			if param2 > 23 or user:get_player_control().sneak then param2 = 0 end
			minetest.set_node(pointed_thing.under, {name=node.name, param2=param2})
			meta:from_table(meta0)
			minetest.chat_send_all("param2 data set to "..param2)
		end
	end,
	on_place = function(itemstack, placer, pointed_thing)
		if is_node(pointed_thing.under) then
			local pointed_node = minetest.get_node(pointed_thing.under)
			debug.message('node "'..pointed_node.name..'" at pos '..minetest.pos_to_string(pointed_thing.under)..' has a param2 value of '..pointed_node.param2, 'all')
		end
	end
})
