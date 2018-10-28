minetest.register_node("akalin_addon:rail", {
	description = "Akalin Rail",
	drawtype = "raillike",
	tiles = {"akalin_addon_rail.png", "akalin_addon_rail_curved.png", "akalin_addon_rail_t_junction.png", "akalin_addon_rail_crossing.png"},
	inventory_image = "akalin_addon_rail.png",
	wield_image = "akalin_addon_rail.png",
	paramtype = "light",
	is_ground_content = true,
	walkable = false,
	selection_box = {
		type = "fixed",
                -- but how to specify the dimensions for curved and sideways rails?
                fixed = {-1/2, -1/2, -1/2, 1/2, -1/2+1/16, 1/2},
	},
	groups = {bendy=2,snappy=1,dig_immediate=2,attached_node=1,rail=1,connect_to_raillike=1},
})

minetest.register_craft({
	output = 'akalin_addon:rail 10',
	recipe = {
		{'gloopores:akalin_ingot', '', 'gloopores:akalin_ingot'},
		{'gloopores:akalin_ingot', 'default:stick', 'gloopores:akalin_ingot'},
		{'gloopores:akalin_ingot', '', 'gloopores:akalin_ingot'},
	}
})

minetest.register_craft({
	output = 'carts:powerrail 10',
	recipe = {
		{'gloopores:akalin_ingot', 'default:mese_crystal_fragment', 'gloopores:akalin_ingot'},
		{'gloopores:akalin_ingot', 'default:stick', 'gloopores:akalin_ingot'},
		{'gloopores:akalin_ingot', '', 'gloopores:akalin_ingot'},
	}
})

minetest.register_craft({
	output = 'carts:brakerail 10',
	recipe = {
		{'gloopores:akalin_ingot', 'default:coal_lump', 'gloopores:akalin_ingot'},
		{'gloopores:akalin_ingot', 'default:stick', 'gloopores:akalin_ingot'},
		{'gloopores:akalin_ingot', '', 'gloopores:akalin_ingot'},
	}
})

minetest.register_craft({
	output = 'carts:cart 1',
	recipe = {
		{'gloopores:akalin_ingot', '', 'gloopores:akalin_ingot'},
		{'gloopores:akalin_ingot', 'gloopores:akalin_ingot', 'gloopores:akalin_ingot'},
	}
})
