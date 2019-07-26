local start_timer = function(pos)
	local timer = minetest.get_node_timer(pos)
	if not timer then return end
	timer:start(mesecon.setting("blinky_test_interval", 0.25))
end

mesecon.register_node("mesecons_blinktest:test", {
	description="Blinky Plant",
	drawtype = "plantlike",
	inventory_image = "jeija_blinky_plant_off.png",
	paramtype = "light",
	is_ground_content = false,
	walkable = false,
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, -0.5+0.7, 0.3},
	},
	on_timer = function(pos)
		local node = minetest.get_node(pos, elapsed)
		if mesecon.flipstate(pos, node) == "on" then
			mesecon.receptor_on(pos)
			minetest.after(0.5, function(pos)
				start_timer(pos)
			end, pos)
			return false
		else
			mesecon.receptor_off(pos)
			return true
		end
	end,
	on_construct = function(pos)
		start_timer(pos)
	end,
},{
	tiles = {"jeija_blinky_plant_off.png"},
	groups = {dig_immediate=3},
	mesecons = {receptor = { state = mesecon.state.off }}
},{
	tiles = {"jeija_blinky_plant_on.png"},
	groups = {dig_immediate=3, not_in_creative_inventory=1},
	mesecons = {receptor = { state = mesecon.state.on }}
})

