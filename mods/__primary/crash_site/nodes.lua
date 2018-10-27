if minetest.get_modpath("wasteland") == nil then
	minetest.register_alias("filler", "default:sand")
else
	minetest.register_alias("filler", "wasteland:dust")
end

minetest.register_node("crash_site:controls",{
	description = "Spacecraft Control Module",
	tiles = {"crash_site_controls.png"},
	is_ground_content = false,
	groups = {cracky=1,level=2},
	sounds = default.node_sound_stone_defaults(),
	paramtype = "light",
	drawtype="nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.0625,-0.5,0.1875,0.0625,0.25,0.3125},
			{-0.5,0.125,0.0625,0.5,0.25,0.1875},
			{-0.5,0.25,0.1875,0.5,0.375,0.3125},
			{-0.5,0.375,0.3125,0.5,0.5,0.4375},
		}
	},
})

minetest.register_node("crash_site:seat",{
	description = "Pilot Seat",
	tiles = {"crash_site_seat.png"},
	is_ground_content = false,
	groups = {cracky=1,level=2},
	sounds = default.node_sound_stone_defaults(),
	paramtype = "light",
	drawtype="nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5,-0.1875,-0.5,0.5,0,0.25},
			{-0.5,0,-0.5,0.5,0.75,-0.3125},
			{-0.125,-0.5,-0.3125,0.125,-0.1875,-0.0625},
		}
	},
})

minetest.register_node("crash_site:steel_stair",{
	description = "Steel-Plated Stair",
	tiles = {"crash_site_steel.png"},
	is_ground_content = false,
	groups = {cracky=1,level=2},
	sounds = default.node_sound_stone_defaults(),
	paramtype = "light",
	drawtype="nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5,-0.5,-0.5,0.5,0,0.5},
			{-0.5,0,-0.5,0.5,0.5,0},
		}
	},
})

minetest.register_node("crash_site:carbon", {
	description = "Carbon-Plated Ship Hull",
	tiles = {"crash_site_carbon.png"},
	is_ground_content = false,
	groups = {cracky=1,level=2},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("crash_site:steel", {
	description = "Steel-Plated Ship Hull",
	tiles = {"crash_site_steel.png"},
	is_ground_content = false,
	groups = {cracky=1,level=2},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("crash_site:floor", {
	description = "Worn Flooring",
	tiles = {"crash_site_floor.png"},
	is_ground_content = false,
	groups = {cracky=1,level=2},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("crash_site:stripes", {
	description = "Striped Steel Flooring",
	tiles = {"crash_site_stripes.png"},
	is_ground_content = false,
	groups = {cracky=1,level=2},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("crash_site:caution", {
	description = "Caution-Striped Steel",
	tiles = {"crash_site_caution.png"},
	is_ground_content = false,
	groups = {cracky=1,level=2},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("crash_site:deco1", {
	description = "Broken Machine",
	tiles = {"crash_site_deco1.png"},
	light_source = LIGHT_MAX - 8,
	is_ground_content = false,
	groups = {cracky=1,level=2},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("crash_site:deco2", {
	description = "Broken Machine",
	tiles = {"crash_site_deco2.png"},
	light_source = LIGHT_MAX - 8,
	is_ground_content = false,
	groups = {cracky=1,level=2},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("crash_site:deco3", {
	description = "Broken Machine",
	tiles = {"crash_site_deco3.png"},
	light_source = LIGHT_MAX - 8,
	is_ground_content = false,
	groups = {cracky=1,level=2},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("crash_site:deco4", {
	description = "Broken Machine",
	tiles = {"crash_site_deco4.png"},
	light_source = LIGHT_MAX - 8,
	is_ground_content = false,
	groups = {cracky=1,level=2},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("crash_site:deco5", {
	description = "Broken Machine",
	tiles = {"crash_site_deco5.png"},
	light_source = LIGHT_MAX - 8,
	is_ground_content = false,
	groups = {cracky=1,level=2},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("crash_site:fuel_frozen", {
	description = "Frozen Meseium",
	tiles = {"crash_site_fuel.png"},
	light_source = LIGHT_MAX - 3,
	is_ground_content = false,
	on_dig = function(pos, node, digger)
		minetest.set_node(pos, {name="crash_site:fuel_frozen"})
		if not crash_site.fuel_cooling(pos) then minetest.set_node(pos, {name="crash_site:fuel"}) end
	end,
	groups = {cracky=3,oddly_breakable_by_hand=3},
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_node("crash_site:fuel", {
	description = "Liquid Meseium",
	inventory_image = minetest.inventorycube("crash_site_fuel.png"),
	drawtype = "liquid",
	tiles = {
		{name="crash_site_fuel_animated.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.0}}
	},
	special_tiles = {
		{
			name="crash_site_fuel_animated.png",
			animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.0},
			backface_culling = false,
		}
	},
	paramtype = "light",
	light_source = LIGHT_MAX - 3,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	drop = "",
	drowning = 1,
	liquidtype = "source",
	liquid_alternative_flowing = "crash_site:fuel_flowing",
	liquid_alternative_source = "crash_site:fuel_source",
	liquid_viscosity = WATER_VISC,
	liquid_renewable = false,
	damage_per_second = 2,
	post_effect_color = {a=192, r=222, g=200, b=20},
	groups = {liquid=2, hot=2, igniter=1},
})

minetest.register_node("crash_site:fuel_flowing", {
	description = "Liquid Meseium",
	inventory_image = minetest.inventorycube("crash_site_fuel.png"),
	drawtype = "flowingliquid",
	tiles = {"crash_site_fuel.png"},
	special_tiles = {
		{
			image="crash_site_fuel_animated.png",
			backface_culling=false,
			animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.0}
		},
		{
			image="crash_site_fuel_animated.png",
			backface_culling=true,
			animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.0}
		},
	},
	paramtype = "light",
	paramtype2 = "flowingliquid",
	light_source = LIGHT_MAX - 1,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	drop = "",
	drowning = 1,
	liquidtype = "flowing",
	liquid_alternative_flowing = "crash_site:fuel_flowing",
	liquid_alternative_source = "crash_site:fuel",
	liquid_viscosity = WATER_VISC,
	liquid_renewable = false,
	damage_per_second = 2,
	post_effect_color = {a=192, r=222, g=200, b=20},
	groups = {liquid=2, hot=2, igniter=1, not_in_creative_inventory=1},
})

bucket.register_liquid(
	"crash_site:fuel",
	"crash_site:fuel_flowing",
	"crash_site:fuel_bucket",
	"crash_site_fuel_bucket.png",
	"Liquid Meseium Bucket"
)

minetest.register_craft({
	type = "fuel",
	recipe = "crash_site:fuel",
	burntime = 1800,
})

minetest.register_craft({
	type = "fuel",
	recipe = "crash_site:fuel_bucket",
	burntime = 1800,
	replacements = {{"crash_site:fuel_bucket", "bucket:bucket_empty"}},
})
