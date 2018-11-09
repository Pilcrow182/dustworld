-- compatibility code for Pilcrow's Survivalist mod
if minetest.get_modpath("survivalist") then
	minetest.register_craftitem(":survivalist:float_crystal_fragment", {
		description = "Floc Crystal Fragment",
		inventory_image = "survivalist_float_crystal_fragment.png",
	})

	minetest.register_craftitem(":survivalist:talinite_fragment",{
		description = "Talinite Fragment",
		inventory_image = "survivalist_talinite_fragment.png"
	})

	minetest.register_craftitem(":survivalist:broken_talinite_ingot",{
		description = "Broken Talinite Ingot",
		inventory_image = "survivalist_broken_talinite_ingot.png"
	})

	minetest.register_craft({
		output = 'flolands:floatcrystal',
		recipe = {
			{'survivalist:float_crystal_fragment', 'survivalist:float_crystal_fragment', 'survivalist:float_crystal_fragment'},
			{'survivalist:float_crystal_fragment', 'survivalist:float_crystal_fragment', 'survivalist:float_crystal_fragment'},
			{'survivalist:float_crystal_fragment', 'survivalist:float_crystal_fragment', 'survivalist:float_crystal_fragment'},
		}
	})

	minetest.register_craft({
		output = 'survivalist:float_crystal_fragment 9',
		recipe = {
			{'flolands:floatcrystal'},
		}
	})

	minetest.register_craft({
		output = 'survivalist:broken_talinite_ingot',
		recipe = {
			{'survivalist:talinite_fragment', 'survivalist:talinite_fragment'},
			{'survivalist:talinite_fragment', 'survivalist:talinite_fragment'},
		}
	})

	minetest.register_craft({
		type = "cooking",
		output = "gloopores:talinite_ingot",
		recipe = "survivalist:broken_talinite_ingot",
	})

	survivalist.register_siftable("flolands:floatsand", {
		droprates = {
			{'bonemeal:bonemeal', 5},
			{'survivalist:salt', 5},
			{'default:mese_crystal_fragment', 6},
			{'survivalist:float_crystal_fragment', 7},
			{'survivalist:talinite_fragment', 9},
			{'survivalist:gold_fragment', 10},
			{'survivalist:copper_fragment', 15},
			{'survivalist:iron_fragment', 20},
		}
	})
end
