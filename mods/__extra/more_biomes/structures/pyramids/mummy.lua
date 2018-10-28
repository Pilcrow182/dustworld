pyramids = {}

local spawner_range = 17
local spawner_max_mobs = 8

mummy_mesh = "mobs_mummy.x"
mummy_texture = {"mobs_mummy.png"}

spawner_DEF = {
	hp_max = 1,
	physical = true,
	collisionbox = {0,0,0,0,0,0},
	visual = "mesh",
	visual_size = {x=3.3,y=3.3},
	mesh = mummy_mesh,
	textures = mummy_texture,
	makes_footstep_sound = false,
	timer = 0,
	automatic_rotate = math.pi * 2.9,
	m_name = "dummy"
}

minetest.register_entity("pyramids:mummy_spawner", spawner_DEF)

minetest.register_craftitem("pyramids:spawn_egg", {
	description = "Mummy spawn-egg",
	inventory_image = "pyramids_mummy_egg.png",
	liquids_pointable = false,
	stack_max = 99,
	on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.type == "node" then
			minetest.env:add_entity(pointed_thing.above,"pyramids:mummy")
			if not minetest.setting_getbool("creative_mode") then itemstack:take_item() end
			return itemstack
		end
	end,

})

function pyramids.spawn_mummy (pos, number)
	for i=0,number do
		minetest.env:add_entity(pos,"mobs:mummy")
	end
end

minetest.register_node("pyramids:spawner_mummy", {
	description = "Mummy spawner",
	paramtype = "light",
	tiles = {"pyramids_spawner.png"},
	is_ground_content = true,
	drawtype = "allfaces",--_optional",
	groups = {cracky=1,level=1},
	drop = "",
	on_construct = function(pos)
		pos.y = pos.y - 0.28
		minetest.env:add_entity(pos,"pyramids:mummy_spawner")
	end,
	on_destruct = function(pos)
		for  _,obj in ipairs(minetest.env:get_objects_inside_radius(pos, 1)) do
			if not obj:is_player() then 
				if obj ~= nil and obj:get_luaentity().m_name == "dummy" then
					obj:remove()	
				end
			end
		end
	end
})
if not minetest.setting_getbool("only_peaceful_mobs") then
	minetest.register_abm({
		nodenames = {"pyramids:spawner_mummy"},
		interval = 2.0,
		chance = 5, -- chance = 20,
		action = function(pos, node, active_object_count, active_object_count_wider)
			local player_near = false
			local mobs = 0
			for  _,obj in ipairs(minetest.env:get_objects_inside_radius(pos, spawner_range)) do
				if obj:is_player() then
					player_near = true 
				elseif obj:get_luaentity().mob_name == "mummy" then
					mobs = mobs + 1
				end
			end
			if player_near and mobs < spawner_max_mobs then
				pos.x, pos.y, pos.z = pos.x + math.random(-4,4), pos.y - 1, pos.z - math.random(2,11)
				if minetest.env:get_node(pos).name == "air" and minetest.registered_nodes[minetest.env:get_node({x = pos.x, y = pos.y - 1, z = pos.z}).name].walkable then
					minetest.env:add_entity(pos, "mobs:mummy")
-- 					minetest.chat_send_all("spawning mummy at "..minetest.pos_to_string(pos))
				end
			end
		end
	})
end
