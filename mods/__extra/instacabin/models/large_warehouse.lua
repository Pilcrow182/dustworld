local n1 = { name = "instacabin:void" }
local n2 = { name = "torch:torch_wood_wall", param2 = 1 }
local n3 = { name = "default:wood", param2 = 1 }
local n4 = { name = "stairs:stair_wood" }
local n5 = { name = "default:chest", param2 = 2 }
local n6 = { name = "doors:door_wood_a" }
local n7 = { name = "doors:hidden" }
local n8 = { name = "stairs:stair_wood", param2 = 1 }
local n9 = { name = "stairs:stair_wood", param2 = 3 }
local n10 = { name = "stairs:slab_wood", param2 = 1 }
local n11 = { name = "default:chest", param2 = 3 }
local n12 = { name = "default:chest", param2 = 1 }
local n13 = { name = "torch:torch_wood_ceiling" }
local n14 = { name = "default:chest" }
local n15 = { name = "default:furnace" }
local n16 = { name = "stairs:stair_wood", param2 = 2 }

instacabin.schems.large_warehouse = {
	yslice_prob = {
		
	},
	size = {
		y = 6,
		x = 11,
		z = 12
	}
,
	data = {
n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
n1, n1, n1, n1, n1, n1, n1, n1, n1, n2, n1, n2, n1, n1, n1, n1, n1, 
n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n3, 
n3, n3, n3, n4, n3, n3, n3, n3, n1, n1, n3, n3, n3, n3, n1, n3, n3, 
n3, n3, n1, n1, n3, n3, n3, n3, n1, n3, n3, n3, n3, n1, n1, n3, n3, 
n3, n3, n3, n3, n3, n3, n3, n1, n1, n4, n4, n4, n4, n4, n4, n4, n4, 
n4, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n3, n3, n3, n3, 
n3, n3, n3, n3, n3, n3, n3, n3, n3, n5, n5, n5, n6, n5, n5, n5, n3, 
n3, n3, n3, n5, n5, n5, n7, n5, n5, n5, n3, n3, n3, n3, n5, n5, n5, 
n5, n5, n5, n5, n3, n3, n8, n3, n3, n3, n3, n3, n3, n3, n3, n3, n9, 
n1, n10, n10, n10, n10, n10, n10, n10, n10, n10, n1, n3, n3, n3, n3, 
n3, n3, n3, n3, n3, n3, n3, n3, n11, n1, n1, n1, n1, n1, n1, n1, n12, 
n3, n3, n11, n1, n1, n1, n1, n1, n1, n1, n12, n3, n3, n11, n1, n1, 
n1, n1, n1, n1, n1, n12, n3, n8, n3, n3, n3, n3, n3, n3, n3, n3, n3, 
n9, n1, n10, n10, n10, n10, n10, n10, n10, n10, n10, n1, n3, n3, n3, 
n3, n3, n3, n3, n3, n3, n3, n3, n3, n11, n1, n1, n1, n1, n1, n1, n1, 
n12, n3, n3, n11, n1, n1, n1, n1, n1, n1, n1, n12, n3, n3, n11, n1, 
n1, n1, n1, n1, n1, n1, n12, n3, n8, n3, n3, n13, n3, n3, n3, n13, 
n3, n3, n9, n1, n10, n10, n10, n10, n10, n10, n10, n10, n10, n1, n3, 
n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n11, n1, n1, n1, n1, n1, 
n1, n1, n12, n3, n3, n11, n1, n1, n1, n1, n1, n1, n1, n12, n3, n3, 
n11, n1, n1, n1, n1, n1, n1, n1, n12, n3, n8, n3, n3, n3, n3, n3, n3, 
n3, n3, n3, n9, n1, n10, n10, n10, n10, n10, n10, n10, n10, n10, n1, 
n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n11, n1, n1, n1, n1, 
n1, n1, n1, n12, n3, n3, n11, n1, n1, n1, n1, n1, n1, n1, n12, n3, 
n3, n11, n1, n1, n1, n1, n1, n1, n1, n12, n3, n8, n3, n3, n3, n3, 
n13, n3, n3, n3, n3, n9, n1, n10, n10, n10, n10, n10, n10, n10, n10, 
n10, n1, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n11, n1, n1, 
n1, n1, n1, n1, n1, n12, n3, n3, n11, n1, n1, n1, n1, n1, n1, n1, 
n12, n3, n3, n11, n1, n1, n1, n1, n1, n1, n1, n12, n3, n8, n3, n3, 
n3, n3, n3, n3, n3, n3, n3, n9, n1, n10, n10, n10, n10, n10, n10, 
n10, n10, n10, n1, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, 
n11, n1, n1, n1, n1, n1, n1, n1, n12, n3, n3, n11, n1, n1, n1, n1, 
n1, n1, n1, n12, n3, n3, n11, n1, n1, n1, n1, n1, n1, n1, n12, n3, 
n8, n3, n3, n13, n3, n3, n3, n13, n3, n3, n9, n1, n10, n10, n10, n10, 
n10, n10, n10, n10, n10, n1, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, 
n3, n3, n11, n1, n1, n1, n1, n1, n1, n1, n12, n3, n3, n11, n1, n1, 
n1, n1, n1, n1, n1, n12, n3, n3, n11, n1, n1, n1, n1, n1, n1, n1, 
n12, n3, n8, n3, n3, n3, n3, n3, n3, n3, n3, n3, n9, n1, n10, n10, 
n10, n10, n10, n10, n10, n10, n10, n1, n3, n3, n3, n3, n3, n3, n3, 
n3, n3, n3, n3, n3, n3, n14, n14, n14, n14, n14, n14, n14, n3, n3, 
n3, n3, n14, n14, n15, n15, n15, n14, n14, n3, n3, n3, n3, n14, n14, 
n14, n14, n14, n14, n14, n3, n3, n8, n3, n3, n3, n3, n3, n3, n3, n3, 
n3, n9, n1, n10, n10, n10, n10, n10, n10, n10, n10, n10, n1, n1, n3, 
n3, n3, n3, n3, n3, n3, n3, n3, n1, n1, n3, n3, n3, n3, n3, n3, n3, 
n3, n3, n1, n1, n3, n3, n3, n3, n3, n3, n3, n3, n3, n1, n1, n3, n3, 
n3, n3, n3, n3, n3, n3, n3, n1, n1, n16, n16, n16, n16, n16, n16, 
n16, n16, n16, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 

}
}
