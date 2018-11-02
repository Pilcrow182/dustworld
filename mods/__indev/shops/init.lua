-- Texture order: top, bottom, right, left, back, front

minetest.register_node("shops:shopkeeper_upper", {
	tiles = {
		"shops_shopkeeper_upper_top.png",
		"shops_shopkeeper_upper_bottom.png",
		"shops_shopkeeper_upper_right.png",
		"shops_shopkeeper_upper_left.png",
		"shops_shopkeeper_upper_back.png",
		"shops_shopkeeper_upper_front.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	groups = {oddly_breakable_by_hand=3},
	node_box = {
		type = "fixed",
		fixed = {
			{-4/16,  0/16,-4/16, 4/16, 8/16, 4/16}, -- Head
			{-8/16, -8/16,-2/16, 8/16, 0/16, 2/16}, -- Torso
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{0,0,0,0,0,0}, -- None
		},
	}
})

minetest.register_node("shops:shopkeeper", {
	tiles = {
		"shops_shopkeeper_lower_top.png",
		"shops_shopkeeper_lower_bottom.png",
		"shops_shopkeeper_lower_right.png",
		"shops_shopkeeper_lower_left.png",
		"shops_shopkeeper_lower_back.png",
		"shops_shopkeeper_lower_front.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	groups = {oddly_breakable_by_hand=3},
	node_box = {
		type = "fixed",
		fixed = {
			{-8/16, 4/16,-2/16, 8/16, 8/16, 2/16}, -- Butt
			{-4/16,-8/16,-2/16, 4/16, 4/16, 2/16}, -- Legs
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-4/16,16/16,-4/16, 4/16,24/16, 4/16}, -- Head
			{-8/16, 4/16,-2/16, 8/16,16/16, 2/16}, -- Torso
			{-4/16,-8/16,-2/16, 4/16, 4/16, 2/16}, -- Legs
		},
	}
})
