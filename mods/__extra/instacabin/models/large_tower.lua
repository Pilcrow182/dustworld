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
local n14 = { name = "bed:bed_top", param2 = 3 }
local n15 = { name = "bed:bed_bottom", param2 = 3 }
local n16 = { name = "default:fence_wood", param2 = 1 }
local n17 = { name = "bed:bed_bottom", param2 = 1 }
local n18 = { name = "bed:bed_top", param2 = 1 }
local n19 = { name = "torch:torch_wood_ceiling" }
local n20 = { name = "default:ladder_wood", param2 = 5 }
local n21 = { name = "default:furnace", param2 = 3 }
local n22 = { name = "default:furnace", param2 = 1 }
local n23 = { name = "default:ladder_wood", param2 = 4 }
local n24 = { name = "default:fence_wood", param2 = 3 }

instacabin.schems.large_tower = {
	yslice_prob = {
		
	},
	size = {
		y = 16,
		x = 9,
		z = 9
	}
,
	data = {
n1, n1, n1, n1, n2, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
n1, n1, n1, n1, n3, n1, n3, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
n1, n1, n1, n1, n1, n3, n1, n3, n1, n3, n1, n1, n1, n1, n1, n1, n1, 
n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n3, 
n1, n3, n1, n3, n1, n3, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n4, n5, n6, n5, n4, n1, n1, 
n1, n1, n4, n5, n7, n5, n4, n1, n1, n1, n1, n4, n5, n8, n5, n4, n1, 
n1, n1, n1, n4, n5, n5, n5, n4, n1, n1, n1, n1, n4, n4, n4, n4, n4, 
n1, n1, n1, n1, n4, n4, n4, n4, n4, n1, n1, n1, n1, n5, n5, n5, n5, 
n5, n1, n1, n1, n1, n4, n4, n4, n4, n4, n1, n1, n1, n1, n4, n4, n4, 
n4, n4, n1, n1, n1, n1, n4, n4, n4, n4, n4, n1, n1, n1, n1, n4, n4, 
n4, n4, n4, n1, n1, n1, n1, n4, n4, n4, n4, n4, n1, n1, n1, n1, n4, 
n4, n4, n4, n4, n1, n1, n9, n5, n5, n5, n5, n5, n5, n5, n10, n1, n4, 
n4, n4, n4, n4, n4, n4, n1, n1, n4, n1, n4, n1, n4, n1, n4, n1, n1, 
n4, n6, n6, n6, n6, n6, n4, n1, n1, n4, n11, n1, n1, n1, n12, n4, n1, 
n1, n4, n1, n1, n1, n1, n1, n4, n1, n1, n4, n1, n13, n1, n13, n1, n4, 
n1, n1, n4, n1, n1, n1, n1, n1, n4, n1, n1, n4, n1, n1, n1, n1, n1, 
n4, n1, n9, n5, n6, n6, n6, n6, n6, n5, n10, n1, n4, n14, n15, n16, 
n17, n18, n4, n1, n1, n4, n1, n1, n16, n1, n1, n4, n1, n1, n4, n1, 
n13, n16, n13, n1, n4, n1, n1, n4, n1, n1, n16, n1, n1, n4, n1, n1, 
n4, n1, n1, n16, n1, n1, n4, n1, n1, n4, n6, n6, n6, n6, n6, n4, n1, 
n1, n5, n4, n4, n4, n4, n4, n5, n1, n1, n4, n1, n1, n1, n1, n1, n4, 
n1, n1, n1, n1, n13, n1, n13, n1, n1, n1, n1, n4, n6, n6, n6, n6, n6, 
n4, n1, n1, n4, n11, n1, n1, n1, n12, n4, n1, n1, n4, n1, n1, n1, n1, 
n1, n4, n1, n1, n4, n10, n1, n1, n1, n9, n4, n1, n1, n4, n1, n1, n1, 
n1, n1, n4, n1, n1, n4, n1, n19, n1, n19, n1, n4, n1, n1, n5, n6, n6, 
n6, n6, n6, n5, n1, n1, n4, n1, n1, n20, n1, n1, n4, n1, n1, n4, n1, 
n1, n20, n1, n1, n4, n1, n1, n4, n10, n1, n20, n1, n9, n4, n1, n1, 
n4, n1, n1, n20, n1, n1, n4, n1, n1, n4, n1, n19, n20, n19, n1, n4, 
n1, n1, n4, n6, n6, n20, n6, n6, n4, n1, n9, n5, n4, n4, n20, n4, n4, 
n5, n10, n1, n4, n1, n1, n1, n1, n1, n4, n1, n1, n4, n10, n1, n1, n1, 
n9, n4, n1, n1, n4, n6, n6, n6, n6, n6, n4, n1, n1, n4, n21, n1, n1, 
n1, n22, n4, n1, n1, n4, n1, n1, n1, n1, n1, n4, n1, n1, n4, n1, n1, 
n1, n1, n1, n4, n1, n1, n4, n1, n1, n1, n1, n1, n4, n1, n1, n4, n1, 
n1, n1, n1, n1, n4, n1, n9, n5, n6, n6, n6, n6, n6, n5, n10, n1, n4, 
n21, n1, n1, n1, n22, n4, n1, n1, n4, n1, n1, n1, n1, n1, n4, n1, n1, 
n4, n1, n1, n1, n1, n1, n4, n1, n1, n4, n1, n1, n1, n1, n1, n4, n1, 
n1, n4, n1, n1, n1, n1, n1, n4, n1, n1, n4, n6, n6, n6, n6, n6, n4, 
n1, n1, n5, n4, n4, n4, n4, n4, n5, n1, n1, n4, n1, n1, n1, n1, n1, 
n4, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n4, n6, n6, n6, n6, 
n6, n4, n1, n1, n4, n1, n1, n23, n1, n1, n4, n1, n1, n4, n1, n1, n23, 
n1, n1, n4, n1, n1, n4, n10, n1, n23, n1, n9, n4, n1, n1, n4, n1, n1, 
n23, n1, n1, n4, n1, n1, n4, n1, n19, n23, n19, n1, n4, n1, n1, n5, 
n6, n6, n23, n6, n6, n5, n1, n1, n4, n11, n1, n1, n1, n12, n4, n1, 
n1, n4, n1, n1, n1, n1, n1, n4, n1, n1, n4, n10, n1, n1, n1, n9, n4, 
n1, n1, n4, n1, n1, n1, n1, n1, n4, n1, n1, n4, n1, n19, n1, n19, n1, 
n4, n1, n1, n4, n6, n6, n6, n6, n6, n4, n1, n9, n5, n4, n4, n4, n4, 
n4, n5, n10, n1, n4, n1, n1, n1, n1, n1, n4, n1, n1, n4, n10, n1, n1, 
n1, n9, n4, n1, n1, n4, n6, n6, n6, n6, n6, n4, n1, n1, n4, n14, n15, 
n24, n17, n18, n4, n1, n1, n4, n1, n1, n24, n1, n1, n4, n1, n1, n4, 
n1, n3, n24, n3, n1, n4, n1, n1, n4, n1, n1, n24, n1, n1, n4, n1, n1, 
n4, n1, n1, n24, n1, n1, n4, n1, n9, n5, n6, n6, n6, n6, n6, n5, n10, 
n1, n4, n11, n1, n1, n1, n12, n4, n1, n1, n4, n1, n1, n1, n1, n1, n4, 
n1, n1, n4, n1, n3, n1, n3, n1, n4, n1, n1, n4, n1, n1, n1, n1, n1, 
n4, n1, n1, n4, n1, n1, n1, n1, n1, n4, n1, n1, n4, n6, n6, n6, n6, 
n6, n4, n1, n1, n5, n4, n4, n4, n4, n4, n5, n1, n1, n4, n1, n1, n1, 
n1, n1, n4, n1, n1, n1, n1, n3, n1, n3, n1, n1, n1, n1, n1, n4, n4, 
n4, n4, n4, n1, n1, n1, n1, n4, n4, n4, n4, n4, n1, n1, n1, n1, n4, 
n4, n4, n4, n4, n1, n1, n1, n1, n4, n4, n4, n4, n4, n1, n1, n1, n1, 
n4, n4, n4, n4, n4, n1, n1, n1, n1, n4, n4, n4, n4, n4, n1, n1, n1, 
n1, n5, n5, n5, n5, n5, n1, n1, n1, n1, n4, n4, n4, n4, n4, n1, n1, 
n1, n1, n4, n4, n4, n4, n4, n1, n1, n1, n1, n4, n4, n4, n4, n4, n1, 
n1, n1, n1, n4, n4, n4, n4, n4, n1, n1, n1, n1, n4, n4, n4, n4, n4, 
n1, n1, n1, n1, n4, n4, n4, n4, n4, n1, n1, n9, n5, n5, n5, n5, n5, 
n5, n5, n10, n1, n4, n4, n4, n4, n4, n4, n4, n1, n1, n4, n1, n4, n1, 
n4, n1, n4, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
n1, n1, n1, n1, n1, n1, n1, n1, n1, n13, n1, n13, n1, n13, n1, n1, 
n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
n1, n1, n1, n1, n13, n1, n13, n1, n13, n1, n13, n1, n1, n1, n1, n1, 
n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 

}
}
