minetest.register_alias("moreblocks:glowglass", "glowglass:basic")
minetest.register_alias("moreblocks:super_glowglass", "glowglass:super")

minetest.register_node("glowglass:basic", {
	description = "Glow Glass",
	drawtype = "glasslike",
	tiles = {"glowglass.png"},
	inventory_image = minetest.inventorycube("glowglass.png"),
	paramtype = "light",
	sunlight_propagates = true,
	light_source = 11,
	groups = {snappy=2,cracky=3,oddly_breakable_by_hand=3},
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_node("glowglass:super", {
	description = "Super Glow Glass",
	drawtype = "glasslike",
	tiles = {"glowglass.png"},
	inventory_image = minetest.inventorycube("glowglass.png"),
	paramtype = "light",
	sunlight_propagates = true,
	light_source = 15,
	groups = {snappy=2,cracky=3,oddly_breakable_by_hand=3},
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_node("glowglass:black", {
	description = "Black Glow Glass",
	drawtype = "glasslike",
	tiles = {"glowglass_black.png"},
	inventory_image = minetest.inventorycube("glowglass_black.png"),
	paramtype = "light",
	sunlight_propagates = true,
	light_source = 11,
	groups = {snappy=2,cracky=3,oddly_breakable_by_hand=3},
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_node("glowglass:superblack", {
	description = "Super Black Glow Glass",
	drawtype = "glasslike",
	tiles = {"glowglass_black.png"},
	inventory_image = minetest.inventorycube("glowglass_black.png"),
	paramtype = "light",
	sunlight_propagates = true,
	light_source = 15,
	groups = {snappy=2,cracky=3,oddly_breakable_by_hand=3},
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_craft({
	output = "glowglass:basic 1",
	type = "shapeless",
	recipe = {"default:torch", "default:glass"},
})

minetest.register_craft({
	output = "glowglass:super 1",
	type = "shapeless",
	recipe = {"default:torch", "default:torch", "default:glass"},
})

minetest.register_craft({
	output = "glowglass:black 1",
	type = "shapeless",
	recipe = {"default:torch", "default:obsidian_glass"},
})

minetest.register_craft({
	output = "glowglass:superblack 1",
	type = "shapeless",
	recipe = {"default:torch", "default:torch", "default:obsidian_glass"},
})

if minetest.get_modpath("hardened_glass") then
	minetest.register_node("glowglass:hardened", {
		description = "Hardened Glow Glass",
		drawtype = "glasslike",
		tiles = {"glowglass_hardened.png"},
		inventory_image = minetest.inventorycube("glowglass_hardened.png"),
		paramtype = "light",
		sunlight_propagates = true,
		light_source = 11,
		groups = {snappy=2,cracky=2,oddly_breakable_by_hand=2},
		sounds = default.node_sound_glass_defaults(),
	})

	minetest.register_node("glowglass:superhardened", {
		description = "Super Hardened Glow Glass",
		drawtype = "glasslike",
		tiles = {"glowglass_hardened.png"},
		inventory_image = minetest.inventorycube("glowglass_hardened.png"),
		paramtype = "light",
		sunlight_propagates = true,
		light_source = 15,
		groups = {snappy=2,cracky=2,oddly_breakable_by_hand=2},
		sounds = default.node_sound_glass_defaults(),
	})

	minetest.register_craft({
		output = "glowglass:hardened 1",
		type = "shapeless",
		recipe = {"default:torch", "hardened_glass:glass"},
	})

	minetest.register_craft({
		output = "glowglass:superhardened 1",
		type = "shapeless",
		recipe = {"default:torch", "default:torch", "hardened_glass:glass"},
	})
end
