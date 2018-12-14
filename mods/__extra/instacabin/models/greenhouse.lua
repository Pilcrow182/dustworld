local n01 = { name = "air", prob = 0 }
local n02 = { name = "air" }
local n03 = { name = "stairs:slab_junglewood", param2 = 20 }
local n04 = { name = "default:junglewood", param2 = 1 }
local n05 = { name = "doors:door_wood_a" }
local n06 = { name = "glowglass:superblack" }
local n07 = { name = "doors:hidden" }
local n08 = { name = "stairs:slab_junglewood", param2 = 1 }
local n09 = { name = "default:chest", param2 = 3 }
local n10 = { name = "default:chest", param2 = 1 }
local n11 = { name = "homedecor:fence_picket" }
local n12 = { name = "default:dirt" }
local n13 = { name = "default:dirt_with_grass" }
local n14 = { name = "default:desert_sand" }
local n15 = { name = "farming:soil_wet" }
local n16 = { name = "homedecor:fence_picket", param2 = 1 }
local n17 = { name = "default:cactus" }
local n18 = { name = "farming_plus:strawberry_1" }
local n19 = { name = "homedecor:fence_picket", param2 = 3 }
local n20 = { name = "default:water_source" }
local n21 = { name = "farming_plus:potatoe_1" }
local n22 = { name = "farming:cotton_1" }
local n23 = { name = "default:papyrus" }
local n24 = { name = "homedecor:fence_picket", param2 = 2 }

instacabin.schems.greenhouse = {
	size = {x = 17, y = 8, z = 17},
	data = {
		n01, n01, n01, n01, n01, n01, n01, n01, n01, n01, n01, n01, n01, n01, n01, n01, n01,
		n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02,
		n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02,
		n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02,
		n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02,
		n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02,
		n03, n03, n03, n03, n03, n03, n03, n03, n03, n03, n03, n03, n03, n03, n03, n03, n03,
		n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02,

		n01, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n01,
		n02, n04, n04, n04, n04, n04, n04, n04, n05, n04, n04, n04, n04, n04, n04, n04, n02,
		n02, n04, n04, n06, n06, n06, n06, n04, n07, n04, n06, n06, n06, n06, n04, n04, n02,
		n02, n04, n04, n06, n06, n06, n06, n04, n04, n04, n06, n06, n06, n06, n04, n04, n02,
		n02, n04, n04, n06, n06, n06, n06, n04, n04, n04, n06, n06, n06, n06, n04, n04, n02,
		n02, n04, n04, n06, n06, n06, n06, n04, n04, n04, n06, n06, n06, n06, n04, n04, n02,
		n03, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n03,
		n02, n08, n08, n08, n08, n08, n08, n08, n08, n08, n08, n08, n08, n08, n08, n08, n02,

		n01, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n01,
		n02, n04, n08, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n08, n04, n02,
		n02, n04, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n04, n02,
		n02, n04, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n04, n02,
		n02, n04, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n04, n02,
		n02, n04, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n04, n02,
		n03, n04, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n04, n03,
		n02, n08, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n08, n02,

		n01, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n01,
		n02, n04, n04, n09, n02, n02, n02, n02, n02, n02, n02, n02, n02, n10, n04, n04, n02,
		n02, n06, n02, n11, n02, n02, n02, n02, n02, n02, n02, n02, n02, n11, n02, n06, n02,
		n02, n06, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n06, n02,
		n02, n06, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n06, n02,
		n02, n06, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n06, n02,
		n03, n04, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n04, n03,
		n02, n08, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n08, n02,

		n01, n04, n04, n12, n12, n12, n13, n13, n13, n13, n13, n12, n12, n12, n04, n04, n01,
		n02, n04, n04, n14, n15, n15, n08, n08, n08, n08, n08, n15, n15, n14, n04, n04, n02,
		n02, n06, n16, n17, n18, n18, n02, n02, n02, n02, n02, n18, n18, n17, n19, n06, n02,
		n02, n06, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n06, n02,
		n02, n06, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n06, n02,
		n02, n06, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n06, n02,
		n03, n04, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n04, n03,
		n02, n08, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n08, n02,

		n01, n04, n04, n12, n12, n12, n12, n12, n12, n12, n12, n12, n12, n12, n04, n04, n01,
		n02, n04, n04, n14, n20, n15, n15, n15, n15, n15, n15, n15, n20, n14, n04, n04, n02,
		n02, n06, n16, n17, n02, n18, n21, n21, n21, n21, n21, n18, n02, n17, n19, n06, n02,
		n02, n06, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n06, n02,
		n02, n06, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n06, n02,
		n02, n06, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n06, n02,
		n03, n04, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n04, n03,
		n02, n08, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n08, n02,

		n01, n04, n04, n12, n12, n12, n12, n12, n12, n12, n12, n12, n12, n12, n04, n04, n01,
		n02, n04, n04, n14, n20, n15, n15, n15, n15, n15, n15, n15, n20, n14, n04, n04, n02,
		n02, n06, n16, n17, n02, n18, n21, n21, n21, n21, n21, n18, n02, n17, n19, n06, n02,
		n02, n06, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n06, n02,
		n02, n06, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n06, n02,
		n02, n06, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n06, n02,
		n03, n04, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n04, n03,
		n02, n08, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n08, n02,

		n01, n04, n04, n12, n12, n12, n12, n12, n12, n12, n12, n12, n12, n12, n04, n04, n01,
		n02, n04, n04, n14, n20, n15, n15, n15, n15, n15, n15, n15, n20, n14, n04, n04, n02,
		n02, n04, n16, n17, n02, n22, n21, n21, n21, n21, n21, n22, n02, n17, n19, n04, n02,
		n02, n04, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n04, n02,
		n02, n04, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n04, n02,
		n02, n04, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n04, n02,
		n03, n04, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n04, n03,
		n02, n08, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n08, n02,

		n01, n04, n04, n12, n12, n12, n12, n12, n12, n12, n12, n12, n12, n12, n04, n04, n01,
		n02, n04, n04, n14, n20, n15, n15, n15, n15, n15, n15, n15, n20, n14, n04, n04, n02,
		n02, n04, n16, n17, n02, n22, n21, n21, n21, n21, n21, n22, n02, n17, n19, n04, n02,
		n02, n04, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n04, n02,
		n02, n04, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n04, n02,
		n02, n04, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n04, n02,
		n03, n04, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n04, n03,
		n02, n08, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n08, n02,

		n01, n04, n04, n12, n12, n12, n12, n12, n12, n12, n12, n12, n12, n12, n04, n04, n01,
		n02, n04, n04, n14, n20, n15, n15, n15, n15, n15, n15, n15, n20, n14, n04, n04, n02,
		n02, n04, n16, n17, n02, n22, n21, n21, n21, n21, n21, n22, n02, n17, n19, n04, n02,
		n02, n04, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n04, n02,
		n02, n04, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n04, n02,
		n02, n04, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n04, n02,
		n03, n04, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n04, n03,
		n02, n08, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n08, n02,

		n01, n04, n04, n12, n12, n12, n12, n12, n12, n12, n12, n12, n12, n12, n04, n04, n01,
		n02, n04, n04, n14, n20, n15, n15, n15, n15, n15, n15, n15, n20, n14, n04, n04, n02,
		n02, n06, n16, n17, n02, n22, n21, n21, n21, n21, n21, n22, n02, n17, n19, n06, n02,
		n02, n06, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n06, n02,
		n02, n06, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n06, n02,
		n02, n06, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n06, n02,
		n03, n04, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n04, n03,
		n02, n08, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n08, n02,

		n01, n04, n04, n12, n12, n12, n12, n12, n12, n12, n12, n12, n13, n12, n04, n04, n01,
		n02, n04, n04, n14, n20, n13, n13, n13, n13, n13, n13, n13, n20, n14, n04, n04, n02,
		n02, n06, n16, n17, n02, n23, n23, n23, n23, n23, n23, n23, n02, n17, n19, n06, n02,
		n02, n06, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n06, n02,
		n02, n06, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n06, n02,
		n02, n06, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n06, n02,
		n03, n04, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n04, n03,
		n02, n08, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n08, n02,

		n01, n04, n04, n12, n13, n12, n12, n13, n13, n12, n12, n13, n12, n12, n04, n04, n01,
		n02, n04, n04, n14, n20, n20, n20, n20, n20, n20, n20, n20, n20, n14, n04, n04, n02,
		n02, n06, n16, n17, n02, n02, n02, n02, n02, n02, n02, n02, n02, n17, n19, n06, n02,
		n02, n06, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n06, n02,
		n02, n06, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n06, n02,
		n02, n06, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n06, n02,
		n03, n04, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n04, n03,
		n02, n08, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n08, n02,

		n01, n04, n04, n12, n12, n12, n12, n12, n12, n12, n12, n12, n12, n12, n04, n04, n01,
		n02, n04, n04, n14, n14, n14, n14, n14, n14, n14, n14, n14, n14, n14, n04, n04, n02,
		n02, n06, n16, n17, n17, n17, n17, n17, n17, n17, n17, n17, n17, n17, n19, n06, n02,
		n02, n06, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n06, n02,
		n02, n06, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n06, n02,
		n02, n06, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n06, n02,
		n03, n04, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n04, n03,
		n02, n08, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n08, n02,

		n01, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n01,
		n02, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n02,
		n02, n04, n02, n24, n24, n24, n24, n24, n24, n24, n24, n24, n24, n24, n02, n04, n02,
		n02, n04, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n04, n02,
		n02, n04, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n04, n02,
		n02, n04, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n04, n02,
		n03, n04, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n04, n03,
		n02, n08, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n06, n08, n02,

		n01, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n01,
		n02, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n02,
		n02, n04, n04, n06, n06, n06, n06, n04, n04, n04, n06, n06, n06, n06, n04, n04, n02,
		n02, n04, n04, n06, n06, n06, n06, n04, n04, n04, n06, n06, n06, n06, n04, n04, n02,
		n02, n04, n04, n06, n06, n06, n06, n04, n04, n04, n06, n06, n06, n06, n04, n04, n02,
		n02, n04, n04, n06, n06, n06, n06, n04, n04, n04, n06, n06, n06, n06, n04, n04, n02,
		n03, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n04, n03,
		n02, n08, n08, n08, n08, n08, n08, n08, n08, n08, n08, n08, n08, n08, n08, n08, n02,

		n01, n01, n01, n01, n01, n01, n01, n01, n01, n01, n01, n01, n01, n01, n01, n01, n01,
		n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02,
		n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02,
		n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02,
		n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02,
		n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02,
		n03, n03, n03, n03, n03, n03, n03, n03, n03, n03, n03, n03, n03, n03, n03, n03, n03,
		n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02, n02
	}
}
