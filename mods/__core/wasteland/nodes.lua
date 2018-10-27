minetest.register_node("wasteland:dust", {
	description = "Dust",
	tiles = {"wasteland_dust.png"},
	is_ground_content = true,
	groups = {crumbly=3, falling_node=1, sand=1},
	sounds = default.node_sound_sand_defaults(),
})
