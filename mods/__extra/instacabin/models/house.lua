local n01 = { name = "air", prob = 0 }
local n02 = { name = "air" }
local n03 = { name = "torch:torch_wood_wall", param2 = 1 }
local n04 = { name = "stairs:slab_junglewood", param2 = 1 }
local n05 = { name = "default:tree", param2 = 1 }
local n06 = { name = "default:brick", param2 = 1 }
local n07 = { name = "default:wood", param2 = 1 }
local n08 = { name = "doors:door_wood_a" }
local n09 = { name = "doors:hidden" }
local n10 = { name = "default:junglewood", param2 = 1 }
local n11 = { name = "default:furnace", param2 = 2 }
local n12 = { name = "default:chest", param2 = 2 }
local n13 = { name = "stairs:slab_junglewood", param2 = 21 }
local n14 = { name = "default:glass" }
local n15 = { name = "torch:torch_wood_ceiling" }
local n16 = { name = "homedecor:nightstand_mahogany_two_drawers", param2 = 3 }
local n17 = { name = "bed:bed_bottom" }
local n18 = { name = "homedecor:table_lamp_max" }
local n19 = { name = "bed:bed_top" }
local n20 = { name = "homedecor:stereo", param2 = 3 }
local n21 = { name = "homedecor:armchair", param2 = 36 }
local n22 = { name = "homedecor:television", param2 = 3 }

instacabin.schems.house = {
	size = {x = 9, y = 7, z = 9},
	data = {
		n01, n01, n01, n01, n01, n01, n01, n01, n01,
		n02, n02, n02, n02, n02, n02, n02, n02, n02,
		n02, n02, n02, n03, n02, n03, n02, n02, n02,
		n02, n02, n02, n02, n02, n02, n02, n02, n02,
		n04, n04, n04, n04, n04, n04, n04, n04, n04,
		n02, n02, n02, n02, n02, n02, n02, n02, n02,
		n02, n02, n02, n02, n02, n02, n02, n02, n02,

		n01, n05, n06, n06, n07, n06, n06, n05, n01,
		n02, n05, n06, n06, n08, n06, n06, n05, n02,
		n02, n05, n06, n06, n09, n06, n06, n05, n02,
		n02, n05, n06, n06, n06, n06, n06, n05, n02,
		n04, n10, n10, n10, n10, n10, n10, n10, n04,
		n02, n02, n02, n02, n02, n02, n02, n02, n02,
		n02, n02, n02, n02, n02, n02, n02, n02, n02,

		n01, n06, n07, n07, n07, n07, n07, n06, n01,
		n02, n06, n11, n11, n02, n12, n12, n06, n02,
		n02, n06, n02, n02, n02, n02, n02, n06, n02,
		n02, n06, n02, n02, n02, n02, n02, n06, n02,
		n04, n10, n13, n13, n13, n13, n13, n10, n04,
		n02, n02, n04, n04, n04, n04, n04, n02, n02,
		n02, n02, n02, n02, n02, n02, n02, n02, n02,

		n01, n06, n07, n07, n07, n07, n07, n06, n01,
		n02, n06, n02, n02, n02, n02, n02, n06, n02,
		n02, n14, n02, n02, n02, n02, n02, n14, n02,
		n02, n14, n02, n02, n02, n02, n02, n14, n02,
		n04, n10, n13, n15, n02, n15, n13, n10, n04,
		n02, n02, n04, n10, n10, n10, n04, n02, n02,
		n02, n02, n02, n02, n02, n02, n02, n02, n02,

		n01, n06, n07, n07, n07, n07, n07, n06, n01,
		n02, n06, n16, n02, n02, n02, n17, n06, n02,
		n02, n14, n18, n02, n02, n02, n02, n14, n02,
		n02, n14, n02, n02, n02, n02, n02, n14, n02,
		n04, n10, n13, n02, n02, n02, n13, n10, n04,
		n02, n02, n04, n10, n13, n10, n04, n02, n02,
		n02, n02, n02, n02, n04, n02, n02, n02, n02,

		n01, n06, n07, n07, n07, n07, n07, n06, n01,
		n02, n06, n02, n02, n02, n02, n19, n06, n02,
		n02, n14, n02, n02, n02, n02, n02, n14, n02,
		n02, n14, n02, n02, n02, n02, n02, n14, n02,
		n04, n10, n13, n15, n02, n15, n13, n10, n04,
		n02, n02, n04, n10, n10, n10, n04, n02, n02,
		n02, n02, n02, n02, n02, n02, n02, n02, n02,

		n01, n06, n07, n07, n07, n07, n07, n06, n01,
		n02, n06, n20, n02, n21, n02, n02, n06, n02,
		n02, n06, n22, n02, n02, n02, n02, n06, n02,
		n02, n06, n02, n02, n02, n02, n02, n06, n02,
		n04, n10, n13, n13, n13, n13, n13, n10, n04,
		n02, n02, n04, n04, n04, n04, n04, n02, n02,
		n02, n02, n02, n02, n02, n02, n02, n02, n02,

		n01, n05, n06, n06, n06, n06, n06, n05, n01,
		n02, n05, n06, n06, n06, n06, n06, n05, n02,
		n02, n05, n06, n14, n14, n14, n06, n05, n02,
		n02, n05, n06, n14, n14, n14, n06, n05, n02,
		n04, n10, n10, n10, n10, n10, n10, n10, n04,
		n02, n02, n02, n02, n02, n02, n02, n02, n02,
		n02, n02, n02, n02, n02, n02, n02, n02, n02,

		n01, n01, n01, n01, n01, n01, n01, n01, n01,
		n02, n02, n02, n02, n02, n02, n02, n02, n02,
		n02, n02, n02, n02, n02, n02, n02, n02, n02,
		n02, n02, n02, n02, n02, n02, n02, n02, n02,
		n04, n04, n04, n04, n04, n04, n04, n04, n04,
		n02, n02, n02, n02, n02, n02, n02, n02, n02,
		n02, n02, n02, n02, n02, n02, n02, n02, n02
 	}
}

