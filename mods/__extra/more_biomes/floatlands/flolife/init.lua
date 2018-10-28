-- This file supplies plants for the flolands modpack
-- Last revision:  2013-06-10

local SPAWN_DELAY = 1000
local SPAWN_CHANCE = 200
local floatgrass_seed_diff = 329

minetest.register_alias("floatgrass:floatgrass", "flolife:floatgrass")

dofile(minetest.get_modpath("flolife").."/floatoak.lua")
dofile(minetest.get_modpath("flolife").."/legacy.lua")
dofile(minetest.get_modpath("flolife").."/stairs.lua")

minetest.register_node("flolife:floatgrass", {
	description = "Floatgrass",
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"flolife_floatgrass.png"},
	inventory_image = "flolife_floatgrass.png",
	wield_image = "flolife_floatgrass.png",
	paramtype = "light",
	walkable = false,
	light_source = 9,
	groups = { snappy = 3, flammable=2, flora=1 },
	sounds = default.node_sound_leaves_defaults(),
	drop = 'flolife:floatgrass',
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
	},
	buildable_to = true,
})

plantslib:spawn_on_surfaces({
	spawn_delay = SPAWN_DELAY,
	spawn_plants = {"flolife:floatgrass"},
	avoid_radius = 4,
	spawn_chance = SPAWN_CHANCE,
	spawn_surfaces = {"flolands:floatsand"},
	avoid_nodes = {"flolife:floatgrass"},
	seed_diff = floatgrass_seed_diff,
	light_min = 5
})

print("[Floatgrass] Loaded.")
