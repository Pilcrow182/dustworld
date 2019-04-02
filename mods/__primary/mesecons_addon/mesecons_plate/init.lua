for _,state in pairs({"off", "on"}) do
	local def = {
		description = "Mesecon Plate",
		tiles = {"mesecons_wire_"..state..".png"},
		drawtype = "nodebox",
		node_box = {type = "fixed", fixed = { -8/16, -8/16, -8/16, 8/16, -7/16, 8/16 }},
		paramtype = "light",
		sunlight_propagates = true,
		walkable = false,
		is_ground_content = false,
		groups = {dig_immediate = 3,mesecon=2},
		mesecons= {
			conductor = {
				state = state,
				onstate = "mesecons_plate:plate_on",
				offstate = "mesecons_plate:plate_off",
				rules = {
					{y = 0, x =  1, z =  0},
					{y = 0, x = -1, z =  0},
					{y = 0, x =  0, z =  1},
					{y = 0, x =  0, z = -1}
				}
			}
		},
		drop = "mesecons_plate:plate_off"
	}
	if state == "on" then def.groups["not_in_creative_inventory"] = 1 end
	minetest.register_node("mesecons_plate:plate_"..state, def)
end

minetest.register_craft({
	output = "mesecons_plate:plate_off 4",
	recipe = {
		{'group:mesecon_conductor_craftable', 'group:mesecon_conductor_craftable'},
		{'group:mesecon_conductor_craftable', 'group:mesecon_conductor_craftable'},
	}
})

minetest.register_craft({
	output = "mesecons:wire_00000000_off",
	recipe = {{'mesecons_plate:plate_off'}}
})

