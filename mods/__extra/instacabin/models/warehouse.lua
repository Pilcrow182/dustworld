local n01 = { name = "air" }
local n02 = { name = "torch:torch_wood_wall", param2 = 1 }
local n03 = { name = "default:wood", param2 = 1 }
local n04 = { name = "stairs:stair_wood" }
local n05 = { name = "default:chest", param2 = 2 }
local n06 = { name = "doors:door_wood_a" }
local n07 = { name = "doors:hidden" }
local n08 = { name = "stairs:stair_wood", param2 = 1 }
local n09 = { name = "stairs:stair_wood", param2 = 3 }
local n10 = { name = "stairs:slab_wood", param2 = 1 }
local n11 = { name = "default:chest", param2 = 3 }
local n12 = { name = "default:chest", param2 = 1 }
local n13 = { name = "torch:torch_wood_ceiling" }
local n14 = { name = "stairs:slab_wood", param2 = 21 }
local n15 = { name = "default:chest" }
local n16 = { name = "stairs:stair_wood", param2 = 2 }

instacabin.schems.warehouse = {
	size = {x = 7, y = 5, z = 8},
	data = {
		n01, n01, n01, n01, n01, n01, n01,
		n01, n01, n01, n01, n01, n01, n01,
		n01, n01, n02, n01, n02, n01, n01,
		n01, n01, n01, n01, n01, n01, n01,
		n01, n01, n01, n01, n01, n01, n01,

		n01, n03, n03, n04, n03, n03, n01,
		n01, n03, n03, n01, n03, n03, n01,
		n01, n03, n03, n01, n03, n03, n01,
		n01, n04, n04, n04, n04, n04, n01,
		n01, n01, n01, n01, n01, n01, n01,

		n03, n03, n03, n03, n03, n03, n03,
		n03, n03, n05, n06, n05, n03, n03,
		n03, n03, n05, n07, n05, n03, n03,
		n08, n03, n03, n03, n03, n03, n09,
		n01, n10, n10, n10, n10, n10, n01,

		n03, n03, n03, n03, n03, n03, n03,
		n03, n11, n01, n01, n01, n12, n03,
		n03, n11, n01, n01, n01, n12, n03,
		n08, n03, n13, n14, n13, n03, n09,
		n01, n10, n10, n10, n10, n10, n01,

		n03, n03, n03, n03, n03, n03, n03,
		n03, n11, n01, n01, n01, n12, n03,
		n03, n11, n01, n01, n01, n12, n03,
		n08, n03, n14, n14, n14, n03, n09,
		n01, n10, n10, n10, n10, n10, n01,

		n03, n03, n03, n03, n03, n03, n03,
		n03, n11, n01, n01, n01, n12, n03,
		n03, n11, n01, n01, n01, n12, n03,
		n08, n03, n13, n14, n13, n03, n09,
		n01, n10, n10, n10, n10, n10, n01,

		n03, n03, n03, n03, n03, n03, n03,
		n03, n03, n15, n15, n15, n03, n03,
		n03, n03, n15, n15, n15, n03, n03,
		n08, n03, n03, n03, n03, n03, n09,
		n01, n10, n10, n10, n10, n10, n01,

		n01, n03, n03, n03, n03, n03, n01,
		n01, n03, n03, n03, n03, n03, n01,
		n01, n03, n03, n03, n03, n03, n01,
		n01, n16, n16, n16, n16, n16, n01,
		n01, n01, n01, n01, n01, n01, n01
	}
}

