local n1 = { name = "instacabin:void" }
local n2 = { name = "stairs:stair_wood" }
local n3 = { name = "torch:torch_wood_wall", param2 = 1 }
local n4 = { name = "default:cobble" }
local n5 = { name = "default:tree", param2 = 1 }
local n6 = { name = "default:wood", param2 = 1 }
local n7 = { name = "doors:door_wood_a" }
local n8 = { name = "doors:hidden" }
local n9 = { name = "torch:torch_wood_wall", param2 = 2 }
local n10 = { name = "torch:torch_wood_wall" }
local n11 = { name = "default:chest", param2 = 3 }
local n12 = { name = "default:chest", param2 = 1 }
local n13 = { name = "torch:torch_wood_wall", param2 = 3 }
local n14 = { name = "torch:torch_wood_ceiling" }
local n15 = { name = "default:furnace", param2 = 3 }
local n16 = { name = "default:furnace", param2 = 1 }
local n17 = { name = "default:ladder_wood", param2 = 4 }
local n18 = { name = "bed:bed_bottom", param2 = 1 }
local n19 = { name = "bed:bed_top", param2 = 1 }
local n20 = { name = "default:fence_wood", param2 = 3 }
local n21 = { name = "bed:bed_top", param2 = 3 }
local n22 = { name = "bed:bed_bottom", param2 = 3 }

instacabin.schems.tower = {
	yslice_prob = {
		
	},
	size = {
		y = 9,
		x = 9,
		z = 9
	}
,
	data = {
n1, n1, n1, n1, n2, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
n1, n1, n1, n1, n3, n1, n3, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
n1, n1, n1, n1, n3, n1, n3, n1, n3, n1, n3, n1, n1, n1, n1, n1, n1, 
n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n4, n5, 
n6, n5, n4, n1, n1, n1, n1, n4, n5, n7, n5, n4, n1, n1, n1, n1, n4, 
n5, n8, n5, n4, n1, n1, n1, n1, n4, n5, n5, n5, n4, n1, n1, n1, n1, 
n4, n4, n4, n4, n4, n1, n1, n1, n1, n4, n4, n4, n4, n4, n1, n1, n9, 
n5, n5, n5, n5, n5, n5, n5, n10, n1, n4, n4, n4, n4, n4, n4, n4, n1, 
n1, n4, n1, n4, n1, n4, n1, n4, n1, n1, n4, n6, n6, n6, n6, n6, n4, 
n1, n1, n4, n11, n1, n1, n1, n12, n4, n1, n1, n4, n1, n1, n1, n1, n1, 
n4, n1, n1, n4, n1, n13, n1, n13, n1, n4, n1, n1, n4, n1, n1, n1, n1, 
n1, n4, n1, n1, n4, n1, n1, n1, n1, n1, n4, n1, n1, n5, n4, n4, n4, 
n4, n4, n5, n1, n1, n4, n1, n1, n1, n1, n1, n4, n1, n1, n1, n1, n13, 
n1, n13, n1, n1, n1, n1, n4, n6, n6, n6, n6, n6, n4, n1, n1, n4, n11, 
n1, n1, n1, n12, n4, n1, n1, n4, n1, n1, n1, n1, n1, n4, n1, n1, n4, 
n10, n1, n1, n1, n9, n4, n1, n1, n4, n1, n1, n1, n1, n1, n4, n1, n1, 
n4, n1, n14, n1, n14, n1, n4, n1, n9, n5, n4, n4, n4, n4, n4, n5, 
n10, n1, n4, n1, n1, n1, n1, n1, n4, n1, n1, n4, n10, n1, n1, n1, n9, 
n4, n1, n1, n4, n6, n6, n6, n6, n6, n4, n1, n1, n4, n15, n1, n1, n1, 
n16, n4, n1, n1, n4, n1, n1, n1, n1, n1, n4, n1, n1, n4, n1, n1, n1, 
n1, n1, n4, n1, n1, n4, n1, n1, n1, n1, n1, n4, n1, n1, n4, n1, n1, 
n1, n1, n1, n4, n1, n1, n5, n4, n4, n4, n4, n4, n5, n1, n1, n4, n1, 
n1, n1, n1, n1, n4, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n4, 
n6, n6, n6, n6, n6, n4, n1, n1, n4, n1, n1, n17, n1, n1, n4, n1, n1, 
n4, n1, n1, n17, n1, n1, n4, n1, n1, n4, n10, n1, n17, n1, n9, n4, 
n1, n1, n4, n1, n1, n17, n1, n1, n4, n1, n1, n4, n1, n14, n17, n14, 
n1, n4, n1, n9, n5, n4, n4, n17, n4, n4, n5, n10, n1, n4, n1, n1, n1, 
n1, n1, n4, n1, n1, n4, n10, n1, n1, n1, n9, n4, n1, n1, n4, n6, n6, 
n6, n6, n6, n4, n1, n1, n4, n18, n19, n20, n21, n22, n4, n1, n1, n4, 
n1, n1, n20, n1, n1, n4, n1, n1, n4, n1, n3, n20, n3, n1, n4, n1, n1, 
n4, n1, n1, n20, n1, n1, n4, n1, n1, n4, n1, n1, n20, n1, n1, n4, n1, 
n1, n5, n4, n4, n4, n4, n4, n5, n1, n1, n4, n1, n1, n1, n1, n1, n4, 
n1, n1, n1, n1, n3, n1, n3, n1, n1, n1, n1, n1, n4, n4, n4, n4, n4, 
n1, n1, n1, n1, n4, n4, n4, n4, n4, n1, n1, n1, n1, n4, n4, n4, n4, 
n4, n1, n1, n1, n1, n4, n4, n4, n4, n4, n1, n1, n1, n1, n4, n4, n4, 
n4, n4, n1, n1, n1, n1, n4, n4, n4, n4, n4, n1, n1, n9, n5, n5, n5, 
n5, n5, n5, n5, n10, n1, n4, n4, n4, n4, n4, n4, n4, n1, n1, n4, n1, 
n4, n1, n4, n1, n4, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n13, n1, n13, n1, n13, n1, 
n13, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
n1, n1, n1, 

}
}
