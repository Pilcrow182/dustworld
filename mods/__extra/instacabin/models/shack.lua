local n01 = { name = "default:wood", param2 = 1 }
local n02 = { name = "doors:door_wood_a" }
local n03 = { name = "doors:hidden" }
local n04 = { name = "stairs:slab_junglewood", param2 = 1 }
local n05 = { name = "air" }
local n06 = { name = "default:furnace", param2 = 2 }
local n07 = { name = "default:chest", param2 = 2 }
local n08 = { name = "stairs:slab_junglewood", param2 = 21 }
local n09 = { name = "torch:torch_wood_ceiling" }
local n10 = { name = "bed:bed_top", param2 = 3 }
local n11 = { name = "bed:bed_bottom", param2 = 3 }

instacabin.schems.shack = {
	size = {x = 5, y = 5, z = 5},
	data = {
		n01, n01, n01, n01, n01, -- bottom  --.
		n01, n01, n01, n02, n01, --           |
		n01, n01, n01, n03, n01, --            > front
		n04, n04, n04, n04, n04, --           |
		n05, n05, n05, n05, n05, --  top    --'

		n01, n01, n01, n01, n01,
		n01, n06, n07, n05, n01,
		n01, n05, n05, n05, n01,
		n04, n08, n08, n08, n04,
		n05, n05, n05, n05, n05,

		n01, n01, n01, n01, n01,
		n01, n05, n05, n05, n01,
		n01, n05, n05, n05, n01,
		n04, n08, n09, n08, n04,
		n05, n05, n04, n05, n05,

		n01, n01, n01, n01, n01,
		n01, n10, n11, n05, n01,
		n01, n05, n05, n05, n01,
		n04, n08, n08, n08, n04,
		n05, n05, n05, n05, n05,

		n01, n01, n01, n01, n01, -- bottom  --.
		n01, n01, n01, n01, n01, --           |
		n01, n01, n01, n01, n01, --            > back
		n04, n04, n04, n04, n04, --           |
		n05, n05, n05, n05, n05  --  top    --'
	}
}

