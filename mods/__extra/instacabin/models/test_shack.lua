local n1 = { name = "default:wood", param2 = 1 }
local n2 = { name = "doors:door_wood_a" }
local n3 = { name = "doors:hidden" }
local n4 = { name = "stairs:slab_junglewood", param2 = 1 }
local n5 = { name = "instacabin:void" }
local n6 = { name = "stairs:slab_junglewood", param2 = 21 }
local n8 = { name = "default:meselamp" }

instacabin.schems.test_shack = {
	size = {x = 5, y = 6, z = 4},
	data = {
		n1, n1, n1, n1, n1,
		n1, n1, n1, n2, n1,
		n1, n1, n1, n3, n1,
		n8, n8, n8, n8, n8,
		n4, n4, n4, n4, n4,
		n5, n5, n5, n5, n5,

		n1, n1, n1, n1, n1,
		n1, n5, n5, n5, n1,
		n1, n5, n5, n5, n1,
		n8, n8, n8, n8, n8,
		n4, n6, n6, n6, n4,
		n5, n5, n5, n5, n5,

		n1, n1, n1, n1, n1,
		n1, n5, n5, n5, n1,
		n1, n5, n5, n5, n1,
		n8, n8, n8, n8, n8,
		n4, n6, n6, n6, n4,
		n5, n5, n5, n5, n5,

		n1, n1, n1, n1, n1,
		n1, n1, n1, n1, n1,
		n1, n1, n1, n1, n1,
		n8, n8, n8, n8, n8,
		n4, n4, n4, n4, n4,
		n5, n5, n5, n5, n5
	}
}
