ruins = {}

local spawner_range = 17
local spawner_max_mobs = 6

golem_mesh = "mobs_stone_monster.x"
golem_texture = {"mobs_stone_monster.png"}

spawner_DEF = {
	hp_max = 1,
	physical = true,
	collisionbox = {0,0,0,0,0,0},
	visual = "mesh",
	visual_size = {x=1,y=1},
	mesh = golem_mesh,
	textures = golem_texture,
	makes_footstep_sound = false,
	timer = 0,
	automatic_rotate = math.pi * 2.9,
	m_name = "dummy"
}

minetest.register_entity("ruins:golem_spawner", spawner_DEF)

function ruins.spawn_golem (pos, number)
	for i=0,number do
		minetest.add_entity(pos,"mobs:stone_monster")
	end
end

minetest.register_node("ruins:spawner_golem", {
	description = "Golem spawner",
	paramtype = "light",
	tiles = {"ruins_spawner.png"},
	is_ground_content = true,
	drawtype = "allfaces",--_optional",
	groups = {cracky=1,level=1},
	drop = "",
	on_construct = function(pos)
		pos.y = pos.y - 0.28
		minetest.add_entity(pos,"ruins:golem_spawner")
	end,
	on_destruct = function(pos)
		for  _,obj in ipairs(minetest.get_objects_inside_radius(pos, 1)) do
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
	nodenames = {"ruins:spawner_golem"},
	interval = 2.0,
	chance = 20,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local player_near = false
		local mobs = 0
		for  _,obj in ipairs(minetest.get_objects_inside_radius(pos, spawner_range)) do
			if obj:is_player() then
				player_near = true 
			else
				if obj:get_luaentity().type == "monster" then mobs = mobs + 1 end
			end
		end
		if player_near then
			if mobs < spawner_max_mobs then
				pos.x = pos.x+1
				local p = minetest.find_node_near(pos, 5, {"air"})	
				minetest.add_entity(p,"mobs:stone_monster")
			end
		end
	end
 })
end
