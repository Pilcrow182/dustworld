minetest.register_craft({
	output = 'default:sand 3',
	recipe = {
		{'stairs:stair_sandstone'},
	}
})

minetest.register_craft({
	output = 'survivalist:crucible',
	recipe = {
		{'default:steel_ingot', '', 'default:steel_ingot'},
		{'default:steel_ingot', '', 'default:steel_ingot'},
		{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
	}
})

minetest.register_craft({
	output = 'survivalist:barrel',
	recipe = {
		{'default:wood', '', 'default:wood'},
		{'default:wood', '', 'default:wood'},
		{'default:wood', 'stairs:slab_wood', 'default:wood'},
	}
})

minetest.register_craft({
	output = 'survivalist:silk_mesh',
	recipe = {
		{'survivalist:silk_string', '', 'survivalist:silk_string'},
		{'', 'survivalist:silk_string', ''},
		{'survivalist:silk_string', '', 'survivalist:silk_string'},
	}
})

minetest.register_craft({
	output = 'survivalist:sieve',
	recipe = {
		{'default:wood', 'survivalist:silk_mesh', 'default:wood'},
		{'group:stick', '', 'group:stick'},
	}
})

minetest.register_craft({
	output = 'survivalist:barrel',
	recipe = {
		{'default:wood', '', 'default:wood'},
		{'default:wood', '', 'default:wood'},
		{'default:wood', 'stairs:slab_wood', 'default:wood'},
	}
})

minetest.register_craft({
	output = 'survivalist:crook',
	recipe = {
		{'group:stick', 'group:stick', 'group:stick'},
		{'group:stick', '', 'group:stick'},
		{'', '', 'group:stick'},
	}
})

minetest.register_craft({
	output = 'survivalist:shears',
	recipe = {
		{'default:steel_ingot', '', 'default:steel_ingot'},
		{'', 'group:stick', ''},
		{'group:stick', '', 'group:stick'},
	}
})

minetest.register_craft({
	output = 'survivalist:silk',
	recipe = {
		{'survivalist:silk_string', 'survivalist:silk_string'},
		{'survivalist:silk_string', 'survivalist:silk_string'},
	}
})

minetest.register_craft({
	output = 'survivalist:silk_string 4',
	recipe = {
		{'survivalist:silk'},
	}
})

minetest.register_craft({
	output = 'default:cobble',
	recipe = {
		{'survivalist:rock', 'survivalist:rock'},
		{'survivalist:rock', 'survivalist:rock'},
	}
})

minetest.register_craft({
	output = 'survivalist:broken_iron_ingot',
	recipe = {
		{'survivalist:iron_fragment', 'survivalist:iron_fragment'},
		{'survivalist:iron_fragment', 'survivalist:iron_fragment'},
	}
})

minetest.register_craft({
	output = 'survivalist:broken_copper_ingot',
	recipe = {
		{'survivalist:copper_fragment', 'survivalist:copper_fragment'},
		{'survivalist:copper_fragment', 'survivalist:copper_fragment'},
	}
})

minetest.register_craft({
	output = 'survivalist:broken_gold_ingot',
	recipe = {
		{'survivalist:gold_fragment', 'survivalist:gold_fragment'},
		{'survivalist:gold_fragment', 'survivalist:gold_fragment'},
	}
})

minetest.register_craft({
	type = "cooking",
	output = "default:steel_ingot",
	recipe = "survivalist:broken_iron_ingot",
})

minetest.register_craft({
	type = "cooking",
	output = "default:copper_ingot",
	recipe = "survivalist:broken_copper_ingot",
})

minetest.register_craft({
	type = "cooking",
	output = "default:gold_ingot",
	recipe = "survivalist:broken_gold_ingot",
})

minetest.register_craft({
	type = 'shapeless',
	output = 'default:desert_sand 2',
	recipe = {'default:sand', 'default:clay'}
})

minetest.register_craft({
	type = 'shapeless',
	output = 'default:desert_sand 2',
	recipe = {'default:sand', 'bonemeal:bonemeal_block'}
})

minetest.register_craft({
	type = 'shapeless',
	output = 'default:mese_crystal_fragment',
	recipe = {'survivalist:mese_dust', 'survivalist:mese_dust', 'survivalist:mese_dust', 'survivalist:mese_dust'}
})

minetest.register_craft({
	output = 'default:mese_crystal',
	recipe = {
		{'default:mese_crystal_fragment', 'default:mese_crystal_fragment', 'default:mese_crystal_fragment'},
		{'default:mese_crystal_fragment', 'default:mese_crystal_fragment', 'default:mese_crystal_fragment'},
		{'default:mese_crystal_fragment', 'default:mese_crystal_fragment', 'default:mese_crystal_fragment'}
	}
})

minetest.register_craft({
	output = 'survivalist:machine_grinder_1',
	recipe = {
		{'group:wood', 'group:wood', 'group:wood'},
		{'survivalist:gear_stone', 'default:chest', 'survivalist:gear_stone'},
		{'group:wood', 'default:copperblock', 'group:wood'},
	}
})

minetest.register_craft({
	output = 'survivalist:machine_compressor_1',
	recipe = {
		{'group:wood', 'group:wood', 'group:wood'},
		{'mesecons_pistons:piston_normal_off', 'default:chest', 'mesecons_pistons:piston_normal_off'},
		{'group:wood', 'default:steelblock', 'group:wood'},
	}
})


minetest.register_craft({
	output = 'survivalist:motor',
	recipe = {
		{'default:steel_ingot', 'mesecons_pistons:piston_normal_off', 'default:steel_ingot'},
		{'default:steel_ingot', 'default:furnace', 'default:steel_ingot'},
		{'default:steel_ingot', 'mesecons_pistons:piston_normal_off', 'default:steel_ingot'},
	}
})

minetest.register_craft({
	output = 'survivalist:machine_autogrinder',
	recipe = {
		{'survivalist:motor'},
		{'survivalist:machine_grinder_1'},
	}
})

minetest.register_craft({
	output = 'survivalist:machine_autocompressor',
	recipe = {
		{'survivalist:motor'},
		{'survivalist:machine_compressor_1'},
	}
})

minetest.register_craft({
	output = 'survivalist:gear_wood',
	recipe = {
		{'', 'group:stick', ''},
		{'group:stick', '', 'group:stick'},
		{'', 'group:stick', ''},
	}
})

minetest.register_craft({
	output = 'survivalist:gear_stone',
	recipe = {
		{'', 'default:stone', ''},
		{'default:stone', 'survivalist:gear_wood', 'default:stone'},
		{'', 'default:stone', ''},
	}
})

minetest.register_craft({
	output = 'survivalist:gear_steel',
	recipe = {
		{'', 'default:steel_ingot', ''},
		{'default:steel_ingot', 'survivalist:gear_stone', 'default:steel_ingot'},
		{'', 'default:steel_ingot', ''},
	}
})

minetest.register_craft({
	output = 'survivalist:gear_gold',
	recipe = {
		{'', 'default:gold_ingot', ''},
		{'default:gold_ingot', 'survivalist:gear_steel', 'default:gold_ingot'},
		{'', 'default:gold_ingot', ''},
	}
})

minetest.register_craft({
	output = 'survivalist:gear_diamond',
	recipe = {
		{'', 'default:diamond', ''},
		{'default:diamond', 'survivalist:gear_gold', 'default:diamond'},
		{'', 'default:diamond', ''},
	}
})

minetest.register_craft({
	output = 'survivalist:crate',
	recipe = {
		{'group:wood', 'group:wood', 'group:wood'},
		{'group:wood', 'default:chest', 'group:wood'},
		{'group:wood', 'group:wood', 'group:wood'},
	}
})

minetest.register_craft({
	type = 'shapeless',
	output = 'survivalist:apple_sapling',
	recipe = {'survivalist:oak_sapling', 'default:apple'}
})

minetest.register_craft({
	output = 'survivalist:salt_block',
	recipe = {
		{'survivalist:salt', 'survivalist:salt'},
		{'survivalist:salt', 'survivalist:salt'},
	}
})

minetest.register_craft({
	output = 'survivalist:salt 4',
	recipe = {
		{'survivalist:salt_block'},
	}
})

minetest.register_craft({
	type = 'shapeless',
	output = 'default:sand 2',
	recipe = {'group:sand', 'survivalist:salt_block'}
})

minetest.register_craft({
	output = 'survivalist:mulch_block',
	recipe = {
		{'survivalist:mulch', 'survivalist:mulch'},
		{'survivalist:mulch', 'survivalist:mulch'},
	}
})

minetest.register_craft({
	output = 'survivalist:mulch 9',
	recipe = {
		{'survivalist:mulch_block'},
	}
})

minetest.register_craft({
	type = 'shapeless',
	output = 'default:clay 2',
	recipe = {'default:sand', 'survivalist:mulch_block'}
})

if minetest.get_modpath("bonemeal") ~= nil then
	minetest.register_craft({
		type = 'shapeless',
		output = 'survivalist:mulch_block 2',
		recipe = {'survivalist:mulch_block', 'bonemeal:bonemeal_block'}
	})

	minetest.register_craft({
		type = 'shapeless',
		output = 'survivalist:mulch 2',
		recipe = {'survivalist:mulch', 'bonemeal:bonemeal'}
	})

	minetest.register_craft({
		type = "cooking",
		output = "bonemeal:bonemeal",
		recipe = "survivalist:mulch",
		cooktime = 4
	})

	minetest.register_craft({
		type = "cooking",
		output = "bonemeal:bonemeal_block",
		recipe = "survivalist:mulch_block",
		cooktime = 12
	})
end
