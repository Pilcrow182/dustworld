local n1 = { name = "air", prob = 0 }
local n2 = { name = "instacabin:void" }
local n3 = { name = "torch:torch_wood_wall", param2 = 1 }
local n4 = { name = "stairs:slab_junglewood", param2 = 1 }
local n5 = { name = "default:tree", param2 = 1 }
local n6 = { name = "default:brick", param2 = 1 }
local n7 = { name = "default:wood", param2 = 1 }
local n8 = { name = "doors:door_wood_a" }
local n9 = { name = "doors:hidden" }
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
	yslice_prob = {
		
	},
	size = {
		y = 7,
		x = 9,
		z = 9
	}
,
	data = {
n1, n1, n1, n1, n1, n1, n1, n1, n1, n2, n2, n2, n2, n2, n2, n2, n2, 
n2, n2, n2, n2, n3, n2, n3, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, 
n2, n2, n4, n4, n4, n4, n4, n4, n4, n4, n4, n2, n2, n2, n2, n2, n2, 
n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n1, n5, n6, n6, n7, 
n6, n6, n5, n1, n2, n5, n6, n6, n8, n6, n6, n5, n2, n2, n5, n6, n6, 
n9, n6, n6, n5, n2, n2, n5, n6, n6, n6, n6, n6, n5, n2, n4, n10, n10, 
n10, n10, n10, n10, n10, n4, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, 
n2, n2, n2, n2, n2, n2, n2, n2, n1, n6, n7, n7, n7, n7, n7, n6, n1, 
n2, n6, n11, n11, n2, n12, n12, n6, n2, n2, n6, n2, n2, n2, n2, n2, 
n6, n2, n2, n6, n2, n2, n2, n2, n2, n6, n2, n4, n10, n13, n13, n13, 
n13, n13, n10, n4, n2, n2, n4, n4, n4, n4, n4, n2, n2, n2, n2, n2, 
n2, n2, n2, n2, n2, n2, n1, n6, n7, n7, n7, n7, n7, n6, n1, n2, n6, 
n2, n2, n2, n2, n2, n6, n2, n2, n14, n2, n2, n2, n2, n2, n14, n2, n2, 
n14, n2, n2, n2, n2, n2, n14, n2, n4, n10, n13, n15, n2, n15, n13, 
n10, n4, n2, n2, n4, n10, n10, n10, n4, n2, n2, n2, n2, n2, n2, n2, 
n2, n2, n2, n2, n1, n6, n7, n7, n7, n7, n7, n6, n1, n2, n6, n16, n2, 
n2, n2, n17, n6, n2, n2, n14, n18, n2, n2, n2, n2, n14, n2, n2, n14, 
n2, n2, n2, n2, n2, n14, n2, n4, n10, n13, n2, n2, n2, n13, n10, n4, 
n2, n2, n4, n10, n13, n10, n4, n2, n2, n2, n2, n2, n2, n4, n2, n2, 
n2, n2, n1, n6, n7, n7, n7, n7, n7, n6, n1, n2, n6, n2, n2, n2, n2, 
n19, n6, n2, n2, n14, n2, n2, n2, n2, n2, n14, n2, n2, n14, n2, n2, 
n2, n2, n2, n14, n2, n4, n10, n13, n15, n2, n15, n13, n10, n4, n2, 
n2, n4, n10, n10, n10, n4, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, 
n2, n1, n6, n7, n7, n7, n7, n7, n6, n1, n2, n6, n20, n2, n21, n2, n2, 
n6, n2, n2, n6, n22, n2, n2, n2, n2, n6, n2, n2, n6, n2, n2, n2, n2, 
n2, n6, n2, n4, n10, n13, n13, n13, n13, n13, n10, n4, n2, n2, n4, 
n4, n4, n4, n4, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n1, n5, 
n6, n6, n6, n6, n6, n5, n1, n2, n5, n6, n6, n6, n6, n6, n5, n2, n2, 
n5, n6, n14, n14, n14, n6, n5, n2, n2, n5, n6, n14, n14, n14, n6, n5, 
n2, n4, n10, n10, n10, n10, n10, n10, n10, n4, n2, n2, n2, n2, n2, 
n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n1, n1, n1, n1, 
n1, n1, n1, n1, n1, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, 
n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n4, n4, 
n4, n4, n4, n4, n4, n4, n4, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, 
n2, n2, n2, n2, n2, n2, n2, n2, 

}
}
