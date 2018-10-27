minetest.register_node("temptorch:torch", {
	description = "Temporary torch",
	drawtype = "nodebox",
	tiles = {"temptorch_torch_top.png", "temptorch_torch_bottom.png", "temptorch_torch_side.png"},
	inventory_image = "temptorch_torch_inv.png",
	wield_image = "temptorch_torch_inv.png",
	wield_scale = {x = 1, y = 1, z = 1.25},
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	is_ground_content = false,
	walkable = false,
	light_source = LIGHT_MAX-1,
	node_box = {
		type = "wallmounted",
		wall_top =    {-1/16, -1/16, -1/16,  1/16,  8/16,  1/16},
		wall_bottom = {-1/16, -8/16, -1/16,  1/16,  1/16,  1/16},
		wall_side =   {-8/16, -8/16, -1/16, -6/16,  1/16,  1/16},
	},
	selection_box = {type = "wallmounted"},
	groups = {choppy = 2, dig_immediate = 3, flammable = 1, attached_node = 1, hot = 2},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("temptorch:burnt", {
	description = "Burnt torch",
	drawtype = "nodebox",
	tiles = {"temptorch_burnt_top.png", "temptorch_burnt_bottom.png", "temptorch_burnt_side.png"},
	inventory_image = "temptorch_burnt_inv.png",
	wield_image = "temptorch_burnt_inv.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	is_ground_content = false,
	walkable = false,
	node_box = {
		type = "wallmounted",
		wall_top =    {-1/16, -1/16, -1/16,  1/16,  8/16,  1/16},
		wall_bottom = {-1/16, -8/16, -1/16,  1/16,  1/16,  1/16},
		wall_side =   {-8/16, -8/16, -1/16, -6/16,  1/16,  1/16},
	},
	selection_box = {type = "wallmounted"},
	groups = {choppy = 2, dig_immediate = 3, flammable = 1, attached_node = 1},
	sounds = default.node_sound_wood_defaults(),
	drop = "default:stick",
})

minetest.register_craft({
	type = "cooking",
	output = "temptorch:torch",
	recipe = "default:stick",
	cooktime = 2
})

minetest.register_abm({
	nodenames = {"temptorch:torch"},
	interval = 30,
	chance = 2,
	action = function(pos)
		local node = minetest.get_node(pos)
		node.name = "temptorch:burnt"
		minetest.set_node(pos,node)
	end
})
