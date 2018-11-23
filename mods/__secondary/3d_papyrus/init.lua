minetest.register_node(":default:papyrus",
	{description = "Papyrus",
	drawtype = "nodebox",
	tiles ={
		"3d_papyrus.png",
		"3d_papyrus.png",
		"3d_papyrus_s1.png",
		"3d_papyrus_s1.png",
		"3d_papyrus_s2.png",
		"3d_papyrus_s2.png",
		},
	inventory_image = "default_papyrus.png",
	wield_image ="default_papyrus.png",
	paramtype = "light",
	is_ground_content = true,
	walkable = false,
	node_box = {
		type = "fixed",
		fixed = {
			--papyrus 1
			{-0.03-0.1,-0.5,-0.03-0.1, 0.03-0.1,0.5,0.03-0.1},
			{-0.06-0.1,-0.02-0.1,-0.06-0.1, 0.06-0.1,0.02-0.1,0.06-0.1},
			--papyrus 2
			{-0.03-0.4,-0.5,-0.03-0.3, 0.03-0.4,0.5,0.03-0.3},
			{-0.06-0.4,-0.02-0.2,-0.06-0.3, 0.06-0.4,0.02-0.2,0.06-0.3},
			--papyrus 3
			{-0.03+0.4,-0.5,-0.03-0.3,0.03+0.4,0.5,0.03-0.3},
			{-0.06+0.4,-0.02+0.2,-0.06-0.3, 0.06+0.4,0.02+0.2,0.06-0.3},
			--papyrus 4
			{-0.03-0.4,-0.5,-0.03+0.4, 0.03-0.4,0.5,0.03+0.4},
			{-0.06-0.4,0.02+0.4,-0.06+0.4, 0.06-0.4,0.02+0.4,0.06+0.4},
			--papyrus 5
			{-0.03-0.2,-0.5,-0.03+0.2, 0.03-0.2,0.5,0.03+0.2},
			{-0.06-0.2,0.02-0.4,-0.06+0.2, 0.06-0.2,0.02-0.4,0.06+0.2},
			--papyrus 6
			{-0.03+0.1,-0.5,-0.03+0.2, 0.03+0.1,0.5,0.03+0.2},
			{-0.06+0.1,0.02+0.3,-0.06+0.2, 0.06+0.1,0.02+0.3,0.06+0.2},
			},
		},
	selection_box = {type="regular"},
	groups = {snappy = 3,flammable = 2},
	sounds = default.node_sound_leaves_defaults(),
})
