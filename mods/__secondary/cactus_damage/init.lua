minetest.register_node(":default:cactus", {
	description = "Cactus",
	tiles = {"default_cactus_top.png", "default_cactus_top.png", "default_cactus_side.png"},
	is_ground_content = true,
	groups = {snappy=1,choppy=3,flammable=2},
	sounds = default.node_sound_wood_defaults(),
	damage_per_second = 1,
--[[
	paramtype = "light",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {{-7/16, -0.5, -7/16, 7/16, 0.5, 7/16}, {-8/16, -0.5, -7/16, -7/16, 0.5, -7/16},
			 {7/16, -0.5, -7/16, 7/16, 0.5, -8/16},{-7/16, -0.5, 7/16, -7/16, 0.5, 8/16},{7/16, -0.5, 7/16, 8/16, 0.5, 7/16}}--
	},
	selection_box = {
		type = "fixed",
		fixed = {-7/16, -0.5, -7/16, 7/16, 0.5, 7/16},
				
	},
--]]
})

minetest.register_abm({
	nodenames = {"default:cactus"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		--pos.y =pos.y-0.4
		for _,object in ipairs(minetest.env:get_objects_inside_radius(pos, 15.1/16)) do--1.3
			if object:get_hp() > 0 then
				object:set_hp(object:get_hp()-1)
			elseif not object:is_player() and object:get_hp() == 0 and object:get_luaentity().name ~= "__builtin:item" then
				object:remove()
			end
		end
	end
})
