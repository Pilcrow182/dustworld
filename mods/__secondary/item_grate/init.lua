minetest.register_node("item_grate:grate", {
	description = "Item Grate",
	tiles = {"default_steel_block.png"},
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-8/16, -8/16, -7/16, -7/16, -7/16,  8/16},
			{-7/16, -8/16,  7/16,  8/16, -7/16,  8/16},
			{ 7/16, -8/16, -8/16,  8/16, -7/16,  7/16},
			{-8/16, -8/16, -8/16,  7/16, -7/16, -7/16},
			{-5/16, -8/16, -7/16, -4/16, -7/16,  7/16},
			{-2/16, -8/16, -7/16, -1/16, -7/16,  7/16},
			{ 1/16, -8/16, -7/16,  2/16, -7/16,  7/16},
			{ 4/16, -8/16, -7/16,  5/16, -7/16,  7/16},
		}
	},
	is_ground_content = false,
	liquids_pointable = true,
	on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing and pointed_thing.type == "node" and placer and not placer:get_player_control().sneak then
			local under = minetest.get_node(pointed_thing.under)
			local underdef = minetest.registered_nodes[under.name]
			if underdef and underdef.on_rightclick then
				return underdef.on_rightclick(pointed_thing.under, under, placer, itemstack, pointed_thing) or itemstack, false
			end
		end
		
		if minetest.registered_nodes[minetest.get_node(pointed_thing.above).name].buildable_to then
			minetest.set_node(pointed_thing.above, {name="item_grate:grate"})
			itemstack:take_item(1)
		end
		return itemstack
	end,
	groups = {cracky=2,oddly_breakable_by_hand=1}
})

minetest.register_craft({
	output = 'item_grate:grate 16',
	recipe = {
		{'default:steel_ingot', 'default:stick', 'default:steel_ingot'},
		{'default:stick', 'default:steel_ingot', 'default:stick'},
		{'default:steel_ingot', 'default:stick', 'default:steel_ingot'},
	}
})

minetest.register_abm({
	nodenames = {"item_grate:grate"},
	interval = 2,
	chance = 1,
	action = function(pos)
		for _,object in ipairs(minetest.get_objects_inside_radius(pos, 1)) do
			if not object:is_player() and object:get_luaentity() and object:get_luaentity().name == "__builtin:item" then
				object:setpos({x = pos.x, y = pos.y - 1, z = pos.z})
			end
		end
	end
})
