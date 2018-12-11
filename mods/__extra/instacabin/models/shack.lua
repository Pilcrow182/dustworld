local n01 = { name = "default:wood", param2 = 1 }
local n02 = { name = "doors:door_wood_a" }
local n03 = { name = "doors:hidden" }
local n04 = { name = "stairs:slab_junglewood", param2 = 1 }
local n05 = { name = "air" }
local n06 = { name = "stairs:slab_junglewood", param2 = 21 }
local n07 = { name = "torch:torch_wood_ceiling" }

instacabin.schems.shack = {
	size = {x = 5, y = 5, z = 5},
	data = {
		n01, n01, n01, n01, n01, -- bottom  --.
		n01, n01, n01, n02, n01, --           |
		n01, n01, n01, n03, n01, --            > front
		n04, n04, n04, n04, n04, --           |
		n05, n05, n05, n05, n05, --  top    --'

		n01, n01, n01, n01, n01,
		n01, n05, n05, n05, n01,
		n01, n05, n05, n05, n01,
		n04, n06, n06, n06, n04,
		n05, n05, n05, n05, n05,

		n01, n01, n01, n01, n01,
		n01, n05, n05, n05, n01,
		n01, n05, n05, n05, n01,
		n04, n06, n07, n06, n04,
		n05, n05, n04, n05, n05,

		n01, n01, n01, n01, n01,
		n01, n05, n05, n05, n01,
		n01, n05, n05, n05, n01,
		n04, n06, n06, n06, n04,
		n05, n05, n05, n05, n05,

		n01, n01, n01, n01, n01, -- bottom  --.
		n01, n01, n01, n01, n01, --           |
		n01, n01, n01, n01, n01, --            > back
		n04, n04, n04, n04, n04, --           |
		n05, n05, n05, n05, n05  --  top    --'
	}
}

