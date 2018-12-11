local n01 = { name = "default:dirt" }
local n02 = { name = "default:junglewood", param2 = 1 }
local n03 = { name = "default:fence_wood", param2 = 3 }
local n04 = { name = "air" }
local n05 = { name = "default:fence_wood" }
local n06 = { name = "farming:soil_wet" }
local n07 = { name = "farming_plus:potatoe_1" }
local n08 = { name = "default:dirt_with_grass" }
local n09 = { name = "default:papyrus" }
local n10 = { name = "default:water_source" }

instacabin.schems.garden = {
	size = {x = 7, y = 6, z = 6},
	data = {
		n01, n01, n01, n01, n01, n01, n01,
		n02, n02, n02, n02, n02, n02, n02,
		n03, n03, n03, n04, n03, n05, n03,
		n04, n04, n04, n04, n04, n04, n04,
		n04, n04, n04, n04, n04, n04, n04,
		n04, n04, n04, n04, n04, n04, n04,

		n01, n01, n01, n01, n01, n01, n01,
		n02, n06, n06, n06, n06, n06, n02,
		n03, n07, n07, n07, n07, n07, n03,
		n04, n04, n04, n04, n04, n04, n04,
		n04, n04, n04, n04, n04, n04, n04,
		n04, n04, n04, n04, n04, n04, n04,

		n01, n01, n01, n01, n01, n01, n01,
		n02, n06, n06, n06, n06, n06, n02,
		n03, n07, n07, n07, n07, n07, n03,
		n04, n04, n04, n04, n04, n04, n04,
		n04, n04, n04, n04, n04, n04, n04,
		n04, n04, n04, n04, n04, n04, n04,

		n01, n01, n01, n01, n01, n01, n01,
		n02, n08, n08, n08, n08, n08, n02,
		n03, n09, n09, n09, n09, n09, n03,
		n04, n04, n04, n04, n04, n04, n04,
		n04, n04, n04, n04, n04, n04, n04,
		n04, n04, n04, n04, n04, n04, n04,

		n01, n08, n08, n01, n01, n01, n01,
		n02, n10, n10, n10, n10, n10, n02,
		n03, n04, n04, n04, n04, n04, n03,
		n04, n04, n04, n04, n04, n04, n04,
		n04, n04, n04, n04, n04, n04, n04,
		n04, n04, n04, n04, n04, n04, n04,

		n01, n01, n01, n01, n01, n01, n01,
		n02, n02, n02, n02, n02, n02, n02,
		n03, n03, n03, n03, n05, n03, n03,
		n04, n04, n04, n04, n04, n04, n04,
		n04, n04, n04, n04, n04, n04, n04,
		n04, n04, n04, n04, n04, n04, n04
	}
}

