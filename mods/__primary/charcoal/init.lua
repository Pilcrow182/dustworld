minetest.register_craft({
	output = 'default:torch 2',
	recipe = {
		{'charcoal:charcoal'},
		{'group:stick'},
	}
})

minetest.register_craft({
	output = 'charcoal:charcoal_block',
	recipe = {
		{'charcoal:charcoal', 'charcoal:charcoal', 'charcoal:charcoal'},
		{'charcoal:charcoal', 'charcoal:charcoal', 'charcoal:charcoal'},
		{'charcoal:charcoal', 'charcoal:charcoal', 'charcoal:charcoal'},
	}
})

minetest.register_craft({
	type = "cooking",
	output = "charcoal:charcoal 4",
	recipe = "group:tree",
	cooktime = 13
})

minetest.register_craft({
	type = "cooking",
	output = "charcoal:charcoal",
	recipe = "group:wood",
	cooktime = 7
})

minetest.register_craft({
	type = "cooking",
	output = "charcoal:charcoal",
	recipe = "default:dry_shrub",
	cooktime = 7
})

minetest.register_craft({
	output = 'charcoal:charcoal 9',
	recipe = {
		{'charcoal:charcoal_block'},
	}
})

minetest.register_craft({
	output = 'default:coal_lump',
	type = "shapeless",
	recipe = {'charcoal:charcoal', 'charcoal:charcoal'}
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:dry_shrub",
	burntime = 7,
})

minetest.register_craft({
	type = "fuel",
	recipe = "charcoal:charcoal",
	burntime = 20,
})

minetest.register_craft({
	type = "fuel",
	recipe = "charcoal:charcoal_block",
	burntime = 185,
})

minetest.register_craftitem("charcoal:charcoal", {
	description = "Charcoal",
	inventory_image = "charcoal_charcoal.png",
})

minetest.register_node("charcoal:charcoal_block", {
	description = "Charcoal Block",
	tiles = {"charcoal_charcoal_block.png"},
	is_ground_content = true,
	groups = {cracky=3,flammable=2},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node(":default:coalblock", {
	description = "Coal Block",
	tiles = {"default_coal_block.png"},
	is_ground_content = true,
	groups = {cracky=3,flammable=2},
	sounds = default.node_sound_stone_defaults(),
})
