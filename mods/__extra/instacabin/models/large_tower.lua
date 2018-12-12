local n01 = { name = "air" }
local n02 = { name = "stairs:stair_wood" }
local n03 = { name = "torch:torch_wood_wall", param2 = 1 }
local n04 = { name = "default:cobble" }
local n05 = { name = "default:tree", param2 = 1 }
local n06 = { name = "default:wood", param2 = 1 }
local n07 = { name = "doors:door_wood_a" }
local n08 = { name = "doors:hidden" }
local n09 = { name = "torch:torch_wood_wall", param2 = 2 }
local n10 = { name = "torch:torch_wood_wall" }
local n11 = { name = "default:chest", param2 = 3 }
local n12 = { name = "default:chest", param2 = 1 }
local n13 = { name = "torch:torch_wood_wall", param2 = 3 }
local n14 = { name = "torch:torch_wood_ceiling" }
local n15 = { name = "default:furnace", param2 = 3 }
local n16 = { name = "default:furnace", param2 = 1 }
local n17 = { name = "default:ladder_wood", param2 = 4 }
local n18 = { name = "bed:bed_top", param2 = 3 }
local n19 = { name = "bed:bed_bottom", param2 = 3 }
local n20 = { name = "bed:bed_bottom", param2 = 1 }
local n21 = { name = "bed:bed_top", param2 = 1 }

instacabin.schems.large_tower = {
	size = {x = 9, y = 16, z = 9},
	data = {
		n01, n01, n01, n01, n02, n01, n01, n01, n01,
		n01, n01, n01, n01, n01, n01, n01, n01, n01,
		n01, n01, n01, n03, n01, n03, n01, n01, n01,
		n01, n01, n01, n01, n01, n01, n01, n01, n01,
		n01, n01, n01, n01, n01, n01, n01, n01, n01,
		n01, n01, n01, n01, n01, n01, n01, n01, n01,
		n01, n01, n03, n01, n03, n01, n03, n01, n01,
		n01, n01, n01, n01, n01, n01, n01, n01, n01,
		n01, n01, n01, n01, n01, n01, n01, n01, n01,
		n01, n01, n01, n01, n01, n01, n01, n01, n01,
		n01, n01, n01, n01, n01, n01, n01, n01, n01,
		n01, n01, n01, n01, n01, n01, n01, n01, n01,
		n01, n01, n01, n01, n01, n01, n01, n01, n01,
		n01, n03, n01, n03, n01, n03, n01, n03, n01,
		n01, n01, n01, n01, n01, n01, n01, n01, n01,
		n01, n01, n01, n01, n01, n01, n01, n01, n01,

		n01, n01, n04, n05, n06, n05, n04, n01, n01,
		n01, n01, n04, n05, n07, n05, n04, n01, n01,
		n01, n01, n04, n05, n08, n05, n04, n01, n01,
		n01, n01, n04, n05, n05, n05, n04, n01, n01,
		n01, n01, n04, n04, n04, n04, n04, n01, n01,
		n01, n01, n04, n04, n04, n04, n04, n01, n01,
		n01, n01, n05, n05, n05, n05, n05, n01, n01,
		n01, n01, n04, n04, n04, n04, n04, n01, n01,
		n01, n01, n04, n04, n04, n04, n04, n01, n01,
		n01, n01, n04, n04, n04, n04, n04, n01, n01,
		n01, n01, n04, n04, n04, n04, n04, n01, n01,
		n01, n01, n04, n04, n04, n04, n04, n01, n01,
		n01, n01, n04, n04, n04, n04, n04, n01, n01,
		n09, n05, n05, n05, n05, n05, n05, n05, n10,
		n01, n04, n04, n04, n04, n04, n04, n04, n01,
		n01, n04, n01, n04, n01, n04, n01, n04, n01,

		n01, n04, n06, n06, n06, n06, n06, n04, n01,
		n01, n04, n11, n01, n01, n01, n12, n04, n01,
		n01, n04, n01, n01, n01, n01, n01, n04, n01,
		n01, n04, n01, n13, n01, n13, n01, n04, n01,
		n01, n04, n01, n01, n01, n01, n01, n04, n01,
		n01, n04, n01, n01, n01, n01, n01, n04, n01,
		n09, n05, n06, n06, n06, n06, n06, n05, n10,
		n01, n04, n11, n01, n01, n01, n12, n04, n01,
		n01, n04, n01, n01, n01, n01, n01, n04, n01,
		n01, n04, n01, n13, n01, n13, n01, n04, n01,
		n01, n04, n01, n01, n01, n01, n01, n04, n01,
		n01, n04, n01, n01, n01, n01, n01, n04, n01,
		n01, n04, n06, n06, n06, n06, n06, n04, n01,
		n01, n05, n04, n04, n04, n04, n04, n05, n01,
		n01, n04, n01, n01, n01, n01, n01, n04, n01,
		n01, n01, n01, n13, n01, n13, n01, n01, n01,

		n01, n04, n06, n06, n06, n06, n06, n04, n01,
		n01, n04, n11, n01, n01, n01, n12, n04, n01,
		n01, n04, n01, n01, n01, n01, n01, n04, n01,
		n01, n04, n10, n01, n01, n01, n09, n04, n01,
		n01, n04, n01, n01, n01, n01, n01, n04, n01,
		n01, n04, n01, n14, n01, n14, n01, n04, n01,
		n01, n05, n06, n06, n06, n06, n06, n05, n01,
		n01, n04, n11, n01, n01, n01, n12, n04, n01,
		n01, n04, n01, n01, n01, n01, n01, n04, n01,
		n01, n04, n10, n01, n01, n01, n09, n04, n01,
		n01, n04, n01, n01, n01, n01, n01, n04, n01,
		n01, n04, n01, n14, n01, n14, n01, n04, n01,
		n01, n04, n06, n06, n06, n06, n06, n04, n01,
		n09, n05, n04, n04, n04, n04, n04, n05, n10,
		n01, n04, n01, n01, n01, n01, n01, n04, n01,
		n01, n04, n10, n01, n01, n01, n09, n04, n01,

		n01, n04, n06, n06, n06, n06, n06, n04, n01,
		n01, n04, n15, n01, n01, n01, n16, n04, n01,
		n01, n04, n01, n01, n01, n01, n01, n04, n01,
		n01, n04, n01, n01, n01, n01, n01, n04, n01,
		n01, n04, n01, n01, n01, n01, n01, n04, n01,
		n01, n04, n01, n01, n01, n01, n01, n04, n01,
		n09, n05, n06, n06, n06, n06, n06, n05, n10,
		n01, n04, n15, n01, n01, n01, n16, n04, n01,
		n01, n04, n01, n01, n01, n01, n01, n04, n01,
		n01, n04, n01, n01, n01, n01, n01, n04, n01,
		n01, n04, n01, n01, n01, n01, n01, n04, n01,
		n01, n04, n01, n01, n01, n01, n01, n04, n01,
		n01, n04, n06, n06, n06, n06, n06, n04, n01,
		n01, n05, n04, n04, n04, n04, n04, n05, n01,
		n01, n04, n01, n01, n01, n01, n01, n04, n01,
		n01, n01, n01, n01, n01, n01, n01, n01, n01,

		n01, n04, n06, n06, n06, n06, n06, n04, n01,
		n01, n04, n01, n01, n17, n01, n01, n04, n01,
		n01, n04, n01, n01, n17, n01, n01, n04, n01,
		n01, n04, n10, n01, n17, n01, n09, n04, n01,
		n01, n04, n01, n01, n17, n01, n01, n04, n01,
		n01, n04, n01, n14, n17, n14, n01, n04, n01,
		n01, n05, n06, n06, n17, n06, n06, n05, n01,
		n01, n04, n01, n01, n17, n01, n01, n04, n01,
		n01, n04, n01, n01, n17, n01, n01, n04, n01,
		n01, n04, n10, n01, n17, n01, n09, n04, n01,
		n01, n04, n01, n01, n17, n01, n01, n04, n01,
		n01, n04, n01, n14, n17, n14, n01, n04, n01,
		n01, n04, n06, n06, n17, n06, n06, n04, n01,
		n09, n05, n04, n04, n17, n04, n04, n05, n10,
		n01, n04, n01, n01, n01, n01, n01, n04, n01,
		n01, n04, n10, n01, n01, n01, n09, n04, n01,

		n01, n04, n06, n06, n06, n06, n06, n04, n01,
		n01, n04, n18, n19, n04, n20, n21, n04, n01,
		n01, n04, n01, n01, n04, n01, n01, n04, n01,
		n01, n04, n01, n03, n04, n03, n01, n04, n01,
		n01, n04, n01, n01, n04, n01, n01, n04, n01,
		n01, n04, n01, n01, n04, n01, n01, n04, n01,
		n09, n05, n06, n06, n04, n06, n06, n05, n10,
		n01, n04, n18, n19, n04, n20, n21, n04, n01,
		n01, n04, n01, n01, n04, n01, n01, n04, n01,
		n01, n04, n01, n03, n04, n03, n01, n04, n01,
		n01, n04, n01, n01, n04, n01, n01, n04, n01,
		n01, n04, n01, n01, n04, n01, n01, n04, n01,
		n01, n04, n06, n06, n04, n06, n06, n04, n01,
		n01, n05, n04, n04, n04, n04, n04, n05, n01,
		n01, n04, n01, n01, n01, n01, n01, n04, n01,
		n01, n01, n01, n03, n01, n03, n01, n01, n01,

		n01, n01, n04, n04, n04, n04, n04, n01, n01,
		n01, n01, n04, n04, n04, n04, n04, n01, n01,
		n01, n01, n04, n04, n04, n04, n04, n01, n01,
		n01, n01, n04, n04, n04, n04, n04, n01, n01,
		n01, n01, n04, n04, n04, n04, n04, n01, n01,
		n01, n01, n04, n04, n04, n04, n04, n01, n01,
		n01, n01, n05, n05, n05, n05, n05, n01, n01,
		n01, n01, n04, n04, n04, n04, n04, n01, n01,
		n01, n01, n04, n04, n04, n04, n04, n01, n01,
		n01, n01, n04, n04, n04, n04, n04, n01, n01,
		n01, n01, n04, n04, n04, n04, n04, n01, n01,
		n01, n01, n04, n04, n04, n04, n04, n01, n01,
		n01, n01, n04, n04, n04, n04, n04, n01, n01,
		n09, n05, n05, n05, n05, n05, n05, n05, n10,
		n01, n04, n04, n04, n04, n04, n04, n04, n01,
		n01, n04, n01, n04, n01, n04, n01, n04, n01,

		n01, n01, n01, n01, n01, n01, n01, n01, n01,
		n01, n01, n01, n01, n01, n01, n01, n01, n01,
		n01, n01, n01, n01, n01, n01, n01, n01, n01,
		n01, n01, n01, n01, n01, n01, n01, n01, n01,
		n01, n01, n01, n01, n01, n01, n01, n01, n01,
		n01, n01, n01, n01, n01, n01, n01, n01, n01,
		n01, n01, n13, n01, n13, n01, n13, n01, n01,
		n01, n01, n01, n01, n01, n01, n01, n01, n01,
		n01, n01, n01, n01, n01, n01, n01, n01, n01,
		n01, n01, n01, n01, n01, n01, n01, n01, n01,
		n01, n01, n01, n01, n01, n01, n01, n01, n01,
		n01, n01, n01, n01, n01, n01, n01, n01, n01,
		n01, n01, n01, n01, n01, n01, n01, n01, n01,
		n01, n13, n01, n13, n01, n13, n01, n13, n01,
		n01, n01, n01, n01, n01, n01, n01, n01, n01,
		n01, n01, n01, n01, n01, n01, n01, n01, n01
	}
}

