minetest.register_node("bed:minibed", {
	description = "Mini-Bed (easteregg)",
	drawtype = "nodebox",
	tiles = {
		"bed_minibed_top.png",
		"bed_minibed_wood.png",
		"bed_minibed_side.png",
		"bed_minibed_side.png^[transformFX",
		"bed_minibed_wood.png",
		"bed_minibed_foot.png",
	    },
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			--bottom
			{-08/32, -16/32, -16/32, -06/32, -09/32, -15/32},
			{ 06/32, -16/32, -16/32,  08/32, -09/32, -15/32},
			{-08/32, -14/32, -16/32,  08/32, -10/32, -15/32},
			{-08/32, -14/32, -16/32, -07/32, -10/32,  00/32},
			{ 07/32, -14/32, -16/32,  08/32, -10/32,  00/32},
			{-07/32, -13/32, -15/32,  07/32, -09/32,  00/32},
			--top
			{-08/32, -16/32,  15/32, -06/32, -05/32,  16/32},
			{ 06/32, -16/32,  15/32,  08/32, -05/32,  16/32},
			{-08/32, -08/32,  15/32,  08/32, -06/32,  16/32},
			{-08/32, -14/32,  15/32,  08/32, -10/32,  16/32},
			{-08/32, -14/32,  00/32, -07/32, -10/32,  16/32},
			{ 07/32, -14/32,  00/32,  08/32, -10/32,  16/32},
			{-07/32, -13/32,  00/32,  07/32, -09/32,  08/32},
			{-07/32, -13/32,  08/32,  07/32, -10/32,  16/32},
			{-06/32, -13/32,  08/32,  06/32, -09/32,  15/32},
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {-08/32, -16/32, -16/32,  08/32,  -05/32, 16/32},
	},
	on_rightclick = function(pos, node, clicker)
		bed.on_rightclick(pos, clicker)
	end,
	groups = {snappy = 1, choppy = 2, oddly_breakable_by_hand = 2, flammable = 3, bed = 2, not_in_creative_inventory = 1},
})
