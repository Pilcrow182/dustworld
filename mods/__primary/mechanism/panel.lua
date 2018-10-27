local place_panel = function(itemstack, placer, pointed_thing)
	if not pointed_thing then return itemstack end
	local p0 = pointed_thing.under
	local p1 = pointed_thing.above
	local name = itemstack:get_name()
	local param2 = 0

	if pointed_thing.type ~= "node" then return itemstack end

	if placer and not placer:get_player_control().sneak then
		local n = minetest.get_node(p0)
		local nn = n.name
		if minetest.registered_nodes[nn] and minetest.registered_nodes[nn].on_rightclick then
			return minetest.registered_nodes[nn].on_rightclick(p0, n, placer, itemstack) or itemstack, false
		end
	end

	local dir = {x = p0.x - p1.x, y = p0.y - p1.y, z = p0.z - p1.z}
	local uu = {x = p0.x + dir.x, y = p0.y + dir.y, z = p0.z + dir.z}
	param2 = minetest.dir_to_facedir(dir)

	local nodename = ""
	local can_place = false
	if ( minetest.registered_nodes[minetest.get_node(p1).name].buildable_to
	   and minetest.get_item_group(minetest.get_node(p0).name, "hopper") > 1
	   and minetest.get_item_group(minetest.get_node(uu).name, "hopper") > 1 ) then
		can_place = true
		nodename = name
	elseif ( minetest.registered_nodes[minetest.get_node(p1).name].buildable_to
	   and minetest.get_item_group(minetest.get_node(p0).name, "hopper") > 1 ) then
		can_place = true
		nodename = name.."_surface"
	end
	if not can_place then return itemstack end

	if dir.y < 0 then
		minetest.set_node(p1, {name=nodename,param2=4})
	elseif dir.y > 0 then
		minetest.set_node(p1, {name=nodename,param2=8})
	else
		minetest.set_node(p1, {name=nodename,param2=param2})
	end
	itemstack:take_item()
	return itemstack
end

minetest.register_node("mechanism:panel_wood", {
	description = "Pipe-Cover Panel (Wooden)",
	tiles = {"default_wood.png"},
	inventory_image = "default_wood.png",
	wield_image = "default_wood.png",
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {type = "fixed", fixed = {-08/16, -08/16, 24/16, 08/16, 08/16, 25/16}},
	on_place = function(itemstack, placer, pointed_thing) return place_panel(itemstack, placer, pointed_thing) end,
	groups = {choppy=2,oddly_breakable_by_hand=2,flammable=3},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("mechanism:panel_wood_surface", {
	description = "Pipe-Cover Panel (Wooden)",
	tiles = {"default_wood.png"},
	inventory_image = "default_wood.png",
	wield_image = "default_wood.png",
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {type = "fixed", fixed = {-08/16, -08/16, 08/16, 08/16, 08/16, 09/16}},
	on_place = function(itemstack, placer, pointed_thing) return place_panel(itemstack, placer, pointed_thing) end,
	groups = {choppy=2,oddly_breakable_by_hand=2,flammable=3,not_in_creative_inventory=1},
	sounds = default.node_sound_wood_defaults(),
	drop = "mechanism:panel_wood"
})

minetest.register_craft({
	output = 'mechanism:panel_wood 4',
	recipe = {
		{'default:stick', 'default:stick', 'default:stick'},
		{'default:stick', 'group:wood', 'default:stick'},
		{'default:stick', 'default:stick', 'default:stick'},
	}
})
