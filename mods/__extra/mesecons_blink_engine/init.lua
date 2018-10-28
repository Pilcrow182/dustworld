minetest.register_node("mesecons_blink_engine:engine_on", {
	drawtype = "plantlike",
	visual_scale = 1,
	tiles = {"mesecons_blink_engine_on.png"},
	paramtype = "light",
	walkable = false,
	groups = {dig_immediate=3, not_in_creative_inventory=1, mesecon = 2},
	drop="mesecons_blink_engine:engine_unpowered",
	description = "Blink Engine",
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, -0.5+0.7, 0.3},
	},
	mesecons = {receptor = {
		state = mesecon.state.on,
		rules = {
			{x = -1, y = 0, z = 0},
			{x = 1, y = 0, z = 0},
			{x = 0, y = -1, z = 0},
			{x = 0, y = 1, z = 0},
			{x = 0, y = 0, z = -1},
			{x = 0, y = 0, z = 1},
		},
		offstate = "mesecons_blink_engine:engine_unpowered"
	}}
})

minetest.register_node("mesecons_blink_engine:engine_off", {
	drawtype = "plantlike",
	visual_scale = 1,
	tiles = {"mesecons_blink_engine_off.png"},
	inventory_image = "mesecons_blink_engine_off.png",
	paramtype = "light",
	walkable = false,
	groups = {dig_immediate=3, mesecon = 2},
	drop="mesecons_blink_engine:engine_unpowered",
	description="Blink Engine",
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, -0.5+0.7, 0.3},
	},
	mesecons = {receptor = {
		state = mesecon.state.off,
		rules = {
			{x = -1, y = 0, z = 0},
			{x = 1, y = 0, z = 0},
			{x = 0, y = -1, z = 0},
			{x = 0, y = 1, z = 0},
			{x = 0, y = 0, z = -1},
			{x = 0, y = 0, z = 1},
		},
		offstate = "mesecons_blink_engine:engine_unpowered"
	}}
})

minetest.register_node("mesecons_blink_engine:engine_unpowered", {
	drawtype = "plantlike",
	visual_scale = 1,
	tiles = {"mesecons_blink_engine_off.png"},
	inventory_image = "mesecons_blink_engine_off.png",
	paramtype = "light",
	walkable = false,
	groups = {dig_immediate=3, mesecon = 2},
	drop="mesecons_blink_engine:engine_unpowered",
	description="Blink Engine",
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, -0.5+0.7, 0.3},
	},
	mesecons = {receptor = {
		state = mesecon.state.off,
		rules = {
			{x = -1, y = 0, z = 0},
			{x = 1, y = 0, z = 0},
			{x = 0, y = -1, z = 0},
			{x = 0, y = 1, z = 0},
			{x = 0, y = 0, z = -1},
			{x = 0, y = 0, z = 1},
		},
		onstate = "mesecons_blink_engine:engine_on"
	}}
})

minetest.register_abm(
	{nodenames = {"mesecons_blink_engine:engine_off"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		--minetest.env:remove_node(pos)
		minetest.env:add_node(pos, {name="mesecons_blink_engine:engine_on"})
		nodeupdate(pos)
		mesecon:receptor_on(pos)
	end,
})

minetest.register_abm({
	nodenames = {"mesecons_blink_engine:engine_on"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		--minetest.env:remove_node(pos)
		minetest.env:add_node(pos, {name="mesecons_blink_engine:engine_off"})
		nodeupdate(pos)
		mesecon:receptor_off(pos)
	end,
})
