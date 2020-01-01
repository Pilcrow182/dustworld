local shapes = {
	{-5/16,  3/16,  5/16,  8/16,  8/16,  8/16}, --top-north
	{ 5/16,  3/16, -8/16,  8/16,  8/16,  5/16}, --top-south
	{-8/16,  3/16, -8/16,  5/16,  8/16, -5/16}, --top-east
	{-8/16,  3/16, -5/16, -5/16,  8/16,  8/16}, --top-west
	{-5/16, -3/16, -5/16,  5/16,  3/16,  5/16}, --middle
	{-2/16, -2/16,  5/16,  2/16,  2/16,  8/16}, --spout-side
	{-2/16, -8/16, -2/16,  2/16, -3/16,  2/16}, --spout-down
}

minetest.register_node("ductworks:hopper", {
	description = "Hopper",
	drawtype = "nodebox",
	tiles = {"ductworks_base.png^ductworks_hopper.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	is_ground_content = false,
	node_box = {
		type = "fixed",
		fixed = {
			shapes[1], shapes[2],
			shapes[3], shapes[4],
			shapes[5], shapes[6]
		},
	},
	groups = {hopper=1,cracky=2,oddly_breakable_by_hand=1},
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("output", minetest.pos_to_string(minetest.facedir_to_dir(minetest.get_node(pos).param2)))
		meta:set_string("formspec", "size[10,7] list[current_name;src;2.5,1;5,1;] list[current_player;main;0,3;10,4;]")
		meta:get_inventory():set_size("src", 5*1)
	end,
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		if pointed_thing.above.y ~= pointed_thing.under.y then
			minetest.swap_node(pos, {name = "ductworks:hopper_down"})
			minetest.get_meta(pos):set_string("output", "(0,-1,0)")
		end
	end
})

minetest.register_node("ductworks:hopper_down", {
	description = "Hopper (facing downwards)",
	drawtype = "nodebox",
	tiles = {"ductworks_base.png"},
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	node_box = {
		type = "fixed",
		fixed = {
			shapes[1], shapes[2],
			shapes[3], shapes[4],
			shapes[5], shapes[7]
		},
	},
	groups = {hopper=1,cracky=2,oddly_breakable_by_hand=1,not_in_creative_inventory=1},
	drop = "ductworks:hopper"
})

minetest.register_abm({
	nodenames = {"ductworks:hopper", "ductworks:hopper_down"},
	interval = 1,
	chance = 1,
	action = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		for _,object in ipairs(minetest.get_objects_inside_radius({x = pos.x, y = pos.y + 0.5, z = pos.z}, 1)) do
			if not object:is_player() and object:get_luaentity() and object:get_luaentity().name == "__builtin:item" then
				local stack = ItemStack(object:get_luaentity().itemstring)
				if inv:room_for_item("src", stack) then
					minetest.log("action", "adding itemstring '"..object:get_luaentity().itemstring.."' to hopper's inventory")
					inv:add_item("src", stack)
					object:remove()
				end
			end
		end

		local node = minetest.get_node(pos)

		local dst = ((node.name == "ductworks:hopper_down") and {x = 0, y = -1, z = 0}) or minetest.facedir_to_dir(node.param2)
		local dstpos = {x = pos.x + dst.x, y = pos.y + dst.y, z = pos.z + dst.z}

		if minetest.registered_nodes[minetest.get_node(dstpos).name].groups["itemduct"] then
			dstpos = ductworks.find_dst(dstpos, "itemduct")
		end

		if dstpos and ductworks.valid_dst(dstpos, "itemduct") then
			ductworks.transfer(pos, dstpos, "hopper")
			ductworks.transfer({x = pos.x, y = pos.y + 1, z = pos.z}, dstpos, "itemduct")
		end
	end
})

