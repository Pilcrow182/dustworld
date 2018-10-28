minetest.register_node("mesebay:laptop", {
	description = "Mesebay Laptop",
	tiles = {
		"mesebay_laptop_top.png",   -- Top
		"mesebay_laptop_back.png",  -- Bottom
		"mesebay_laptop_back.png",  -- Side A
		"mesebay_laptop_back.png",  -- Side B
		"mesebay_laptop_back.png",  -- Back
		"mesebay_laptop_front.png", -- Front
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	light_source = 13,
	walkable = true,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.500000,-0.500000,-0.375000,0.500000,-0.406250,0.375000}, -- Keyboard
			{-0.500000,-0.406250,0.281250,0.500000,0.250000,0.375000},   -- Screen
		}
	},
	groups = {cracky=3,dig_immediate=2,oddly_breakable_by_hand=3},
	on_construct = mesebay.make_formspec,
	on_receive_fields = mesebay.on_receive_fields,
	sounds = default.node_sound_glass_defaults(),
	drop = 'mesebay:laptop',
})
